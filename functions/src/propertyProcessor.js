const {fetchZillowDataWithCache} = require("./zillowApi");
const {fetchRedfinDataWithCache} = require("./redfinApi");
const {calculateStrategy} = require("./strategyCalculator");
const {
  analyzeDescription,
  calculateBedroomPriceAverages,
  appendZillowUrl,
} = require("./utils");
const {round} = Math;

async function processProperty(prop, params, sequence, total) {
  if (!prop.price || !prop.livingArea) {
    return [{
      error: "Missing price or livingArea",
      zpid: prop.zpid,
      sequence,
      total,
    }];
  }

  const address = prop.address || prop.streetAddress || "";

  // Filter out apartments based on address using regex patterns
  const apartmentPatterns = [
    { pattern: /\bapt\b/i, name: "APT (word boundary)" },
    { pattern: /\bapt[#\-\s\d]/i, name: "APT + separator" },
    { pattern: /[,.\(]apt/i, name: "APT after punctuation" },
    { pattern: /apartment/i, name: "apartment" },
    { pattern: /\bunit\b/i, name: "unit (word boundary)" },
    { pattern: /\bunit[#\-\s\d]/i, name: "unit + separator" },
    { pattern: /[,.\(]unit/i, name: "unit after punctuation" },
    { pattern: /\bste\b/i, name: "ste (word boundary)" },
    { pattern: /\bste[#\-\s\d]/i, name: "ste + separator" },
    { pattern: /[,.\(]ste/i, name: "ste after punctuation" },
    { pattern: /\bsuite\b/i, name: "suite (word boundary)" },
    { pattern: /\bsuite[#\-\s\d]/i, name: "suite + separator" },
  ];

  for (const {pattern, name} of apartmentPatterns) {
    if (pattern.test(address)) {
      console.log(`Filtering out property ${prop.zpid} - matches '${name}' pattern in address: "${address}"`);
      return [];
    }
  }

  const addressParts = address.split(" ");
  const pincode = addressParts[addressParts.length - 1];
  console.log("🗺️ Address parsing:", {
    fullAddress: address,
    addressParts: addressParts,
    extractedPincode: pincode
  });
  const zpid = prop.zpid;

  const [zestimateRes, propertyDetailsRes, soldRedfinRes, forSaleRedfinRes] = await Promise.all([
    fetchZillowDataWithCache("zestimate", {zpid}).catch(() => ({data: {}})),
    fetchZillowDataWithCache("propertyDetails", {zpid}).catch(() => ({data: {}})),
    fetchRedfinDataWithCache("propertySearch", {location: pincode, search_type: "Sold"}).catch(() => ({data: {}})),
    fetchRedfinDataWithCache("propertySearch", {location: pincode, search_type: "ForSale"}).catch(() => ({data: {}})),
  ]);

  console.log("🔍 SOLD REDFIN RESPONSE:", JSON.stringify(soldRedfinRes, null, 2));
  console.log("🏠 FOR SALE REDFIN RESPONSE:", JSON.stringify(forSaleRedfinRes, null, 2));

  // Debug the data extraction
  console.log("📊 Sold data path check:", {
    hasData: !!soldRedfinRes.data,
    hasDataData: !!soldRedfinRes.data?.data,
    hasHomes: !!soldRedfinRes.data?.data?.homes,
    homesLength: soldRedfinRes.data?.data?.homes?.length || 0
  });

  console.log("🏡 For sale data path check:", {
    hasData: !!forSaleRedfinRes.data,
    hasDataData: !!forSaleRedfinRes.data?.data,
    hasHomes: !!forSaleRedfinRes.data?.data?.homes,
    homesLength: forSaleRedfinRes.data?.data?.homes?.length || 0
  });

  const zestimate = Math.round(zestimateRes.data?.value || 0);
  const recentSold = Array.isArray(soldRedfinRes.data?.data?.homes) ? soldRedfinRes.data.data.homes : [];
  const forSaleHomes = Array.isArray(forSaleRedfinRes.data?.data?.homes) ? forSaleRedfinRes.data.data.homes : [];

  console.log("📋 Final arrays:", {
    recentSoldCount: recentSold.length,
    forSaleHomesCount: forSaleHomes.length,
    sampleForSaleHome: forSaleHomes[0] || "No for-sale homes found"
  });

  // Filter out condos, apartments, and mobile homes based on description
  const description = (propertyDetailsRes.data?.description || "").toLowerCase();
  const excludedPropertyTypes = ["condo", "condos", "apartment", "apartments", "apt", "mobile", "mobile home", "condominiums", "double wide"];

  for (const propertyType of excludedPropertyTypes) {
    if (description.includes(propertyType)) {
      console.log(`Filtering out property ${prop.zpid} - contains '${propertyType}' in description: "${description.substring(0, 100)}..."`);
      return [];
    }
  }

  // --- Comp helper functions ---
  function extractCompPrice(c) {
    return c.data?.aboveTheFold?.addressSectionInfo?.priceInfo?.amount ||
      (typeof c.price === "object" ? c.price?.value : c.price) || 0;
  }
  function extractCompSqft(c) {
    return c.data?.aboveTheFold?.addressSectionInfo?.sqFt?.value ||
      (typeof c.sqFt === "object" ? c.sqFt?.value : c.sqFt) || 0;
  }
  function extractLotSize(c) {
    // If lotSize is an object with value property, extract it
    if (typeof c.lotSize === "object" && c.lotSize !== null) {
      return c.lotSize.value || 0;
    }
    return c.lotSize || 0;
  }
  function extractLevels(c) {
    // Extract levels (stories) from lotSize object if available
    if (typeof c.lotSize === "object" && c.lotSize !== null) {
      return c.lotSize.level || null;
    }
    return null;
  }
  function calculateMedian(sortedArray) {
    const mid = Math.floor(sortedArray.length / 2);
    return sortedArray.length % 2 === 0 ?
      (sortedArray[mid - 1] + sortedArray[mid]) / 2 :
      sortedArray[mid];
  }
  function calculateMAD(values, median) {
    const deviations = values.map((value) => Math.abs(value - median));
    return calculateMedian(deviations.sort((a, b) => a - b));
  }
  function percentile(sortedArray, p) {
    const index = (p / 100) * (sortedArray.length - 1);
    if (Math.floor(index) === index) {
      return sortedArray[index];
    } else {
      const lower = Math.floor(index);
      const upper = Math.ceil(index);
      const weight = index - lower;
      return sortedArray[lower] * (1 - weight) + sortedArray[upper] * weight;
    }
  }
  function detectOutliersEnhanced(comps, subjectProperty, subjectPricePerSqft) {
    if (comps.length < 3) return comps;
    const pricesPerSqFt = comps.map((c) => extractCompPrice(c) / extractCompSqft(c));
    const marketReasonableRange = {
      min: subjectPricePerSqft > 0 ? subjectPricePerSqft * 0.3 : 100,
      max: subjectPricePerSqft > 0 ? subjectPricePerSqft * 1.3 : 600,
    };
    const sortedPrices = [...pricesPerSqFt].sort((a, b) => a - b);
    const median = calculateMedian(sortedPrices);
    const mad = calculateMAD(sortedPrices, median);
    const p10 = percentile(sortedPrices, 10);
    const p80 = percentile(sortedPrices, 80);
    const filteredComps = comps.filter((comp, index) => {
      const pricePerSqft = pricesPerSqFt[index];
      const modifiedZScore = mad > 0 ? Math.abs(0.6745 * (pricePerSqft - median) / mad) : 0;
      const passesZScore = modifiedZScore < 3.5;
      const withinPercentiles = pricePerSqft >= p10 && pricePerSqft <= p80;
      const withinMarketRange = pricePerSqft >= marketReasonableRange.min && pricePerSqft <= marketReasonableRange.max;
      return passesZScore && withinPercentiles && withinMarketRange;
    });
    return filteredComps;
  }
  function calculateWeightedPricePerSqft(comps, subjectProperty) {
    const subjectSqft = subjectProperty.livingArea || 0;
    const subjectBeds = subjectProperty.bedrooms || 0;
    const weightedPrices = comps.map((comp) => {
      const compSqft = extractCompSqft(comp);
      const compPrice = extractCompPrice(comp);
      const compBeds = comp.beds || 0;
      const sizeSimilarity = subjectSqft > 0 ?
        1 - Math.abs(compSqft - subjectSqft) / Math.max(compSqft, subjectSqft) : 0.5;
      const bedSimilarity = Math.max(0, 1 - Math.abs(compBeds - subjectBeds) / 5);
      const weight = (sizeSimilarity * 0.6 + bedSimilarity * 0.4) * 0.5 + 0.5; // min 0.5
      return {
        pricePerSqft: compPrice / compSqft,
        weight: weight,
      };
    });
    const totalWeight = weightedPrices.reduce((sum, w) => sum + w.weight, 0);
    const weightedAvg = totalWeight > 0 ?
      weightedPrices.reduce((sum, w) => sum + (w.pricePerSqft * w.weight), 0) / totalWeight : 250;
    return Math.round(weightedAvg);
  }

  // --- Extract levels data from Redfin comps by finding subject property ---
  const allRedfinHomes = [...forSaleHomes, ...recentSold];
  let subjectLevels = null;

  // Try to find subject property by matching address or property characteristics
  const subjectAddress = address.toLowerCase().trim();
  const subjectSqft = prop.livingArea || 0;
  const subjectBeds = prop.bedrooms || 0;
  const subjectPrice = prop.price || 0;

  const matchedProperty = allRedfinHomes.find(home => {
    const homeAddress = (home.address || "").toLowerCase().trim();
    const homeSqft = extractCompSqft(home) || 0;
    const homeBeds = home.beds || 0;
    const homePrice = extractCompPrice(home) || 0;

    // Try address matching first - require at least 2 of first 3 parts to match
    if (homeAddress && subjectAddress) {
      const subjectParts = subjectAddress.split(/[\s,]+/);
      const homeParts = homeAddress.split(/[\s,]+/);

      if (subjectParts.length >= 2 && homeParts.length >= 2) {
        const matchCount = subjectParts.slice(0, 3).filter((part, i) =>
          homeParts[i] && homeParts[i].includes(part)
        ).length;
        if (matchCount >= 2) return true;
      }
    }

    // Fallback: Match by characteristics - require 2 of 3 conditions
    if (subjectSqft > 0 && homeSqft > 0 && subjectBeds > 0) {
      const sqftMatch = Math.abs(homeSqft - subjectSqft) <= 50;
      const bedsMatch = homeBeds === subjectBeds;
      const priceMatch = subjectPrice > 0 && homePrice > 0 &&
                        Math.abs(homePrice - subjectPrice) / subjectPrice < 0.10;

      const matchCount = [sqftMatch, bedsMatch, priceMatch].filter(Boolean).length;
      if (matchCount >= 2) return true;
    }

    return false;
  });

  if (matchedProperty) {
    subjectLevels = extractLevels(matchedProperty);
    console.log("✅ Found subject property in Redfin data:", {
      address: matchedProperty.address,
      levels: subjectLevels,
      sqft: extractCompSqft(matchedProperty),
      beds: matchedProperty.beds,
      lotSize: extractLotSize(matchedProperty)
    });
  } else {
    console.log("⚠️ Subject property not found in Redfin results - will use fallback level assumptions");
    console.log("   Search criteria:", {
      address: subjectAddress.substring(0, 50),
      sqft: subjectSqft,
      beds: subjectBeds,
      price: subjectPrice,
      availableHomes: allRedfinHomes.length
    });
  }

  // --- Enhanced avg price/sqft from comps (with multi-layered outlier filtering) ---
  let pricePerSqFt = 250;
  const subjectPricePerSqft = prop.price && prop.livingArea ? prop.price / prop.livingArea : 0;
  const qualityValidatedComps = recentSold.filter((c) => {
    const price = extractCompPrice(c);
    const sqft = extractCompSqft(c);
    const beds = c.beds || 0;
    const lotSize = extractLotSize(c);
    if (!price || !sqft || price <= 0 || sqft <= 0) return false;
    const pricePerSqft = price / sqft;
    const isReasonable = pricePerSqft >= 50 && pricePerSqft <= 1000;
    const sizeReasonable = sqft >= 400 && sqft <= 8000;
    const priceReasonable = price >= 50000 && price <= 5000000;
    const bedsReasonable = beds >= 1 && beds <= 10;
    const lotSizeReasonable = lotSize >= 3200; // Filter out lots smaller than 3,200 sqft
    return isReasonable && sizeReasonable && priceReasonable && bedsReasonable && lotSizeReasonable;
  });

  if (qualityValidatedComps.length > 0) {
    const filteredComps = detectOutliersEnhanced(qualityValidatedComps, prop, subjectPricePerSqft);

    // Filter comps by size similarity (±25% of subject property size)
    const subjectSqft = prop.livingArea || 0;
    const sizeSimilarComps = filteredComps.filter((c) => {
      const compSqft = extractCompSqft(c);
      if (!compSqft || compSqft <= 0 || !subjectSqft) return true; // Include if no size data
      const sizeRatio = compSqft / subjectSqft;
      return sizeRatio >= 0.75 && sizeRatio <= 1.25; // Within ±25% of subject size
    });

    // Use size-similar comps if we have enough, otherwise fall back to all filtered comps
    const compsToUse = sizeSimilarComps.length >= 3 ? sizeSimilarComps : filteredComps;

    console.log(`📏 Size filtering: ${filteredComps.length} comps → ${sizeSimilarComps.length} size-similar (±25% of ${subjectSqft} sqft) → using ${compsToUse.length} comps`);

    if (compsToUse.length >= 3) {
      pricePerSqFt = calculateWeightedPricePerSqft(compsToUse, prop);
    } else if (compsToUse.length > 0) {
      const avgPrice = compsToUse.reduce((sum, c) =>
        sum + (extractCompPrice(c) / extractCompSqft(c)), 0) / compsToUse.length;
      pricePerSqFt = Math.round(avgPrice);
    } else if (subjectPricePerSqft > 0 && subjectPricePerSqft < 800) {
      pricePerSqFt = Math.round(subjectPricePerSqft * 1.1);
    } else {
      pricePerSqFt = params.regionalPricePerSqft || 250;
    }
  }

  let twoBedAvg = 0;
  const twoBedComps = qualityValidatedComps.filter((p) => p.beds === 2);
  if (twoBedComps.length) {
    const sum = twoBedComps.reduce((s, p) => {
      const price = extractCompPrice(p);
      return s + (price || 0);
    }, 0);
    twoBedAvg = Math.round(sum / twoBedComps.length);
  }

  const descriptionAnalysis = analyzeDescription(propertyDetailsRes.data?.description || "");
  const bedroomAnalysis = calculateBedroomPriceAverages(recentSold);

  // Filter out homes newer than 2011
  const yearBuilt = propertyDetailsRes.data?.yearBuilt || 0;
  if (yearBuilt > 2011) {
    console.log(`Filtering out property ${prop.zpid} - built ${yearBuilt}, newer than 2011`);
    return [];
  }

  // Run all strategies (with override passing supported)
  const strategies = ["Fix & Flip", "Add-On", "ADU", "New Build", "Rental"];
  const results = strategies.map((method) => {
    try {
      // Pass filtered comps + all property fields + all params for override
      const enhancedParams = {
        ...params,
        filteredComps: qualityValidatedComps,
      };
      // Add levels data to prop before passing to strategy calculator
      const propWithLevels = {
        ...prop,
        levels: subjectLevels
      };
      const strategyResult = calculateStrategy(method, propWithLevels, enhancedParams, pricePerSqFt, twoBedAvg, bedroomAnalysis);
      console.log(`🔍 Strategy result for ${prop.zpid} ${method}:`, {
        hasResult: !!strategyResult,
        hasMethod: strategyResult?.method,
        hasNetReturn: strategyResult?.netReturn,
        keys: strategyResult ? Object.keys(strategyResult) : null
      });
      if (!strategyResult) return null; // strategyCalculator already filtered based on business rules
      return {
        ...strategyResult,
        method,
        address,
        zpid,
        propertyId: zpid,
        calculationId: `${zpid}_${method}_${Date.now()}_${Math.random().toString(36).substr(2, 5)}`,
        yearBuilt: propertyDetailsRes.data?.yearBuilt || 0,
        description: propertyDetailsRes.data?.description || "",
        imgSrc: prop.imgSrc || "",
        detailUrl: appendZillowUrl(prop.detailUrl),
        latlng: {
          latitude: prop.latitude ? Number(prop.latitude.toFixed(4)) : 0,
          longitude: prop.longitude ? Number(prop.longitude.toFixed(4)) : 0,
        },
        zestimate,
        pricePerSqft: pricePerSqFt,
        avgPricePerSqFt: pricePerSqFt,
        avgCompPrice: qualityValidatedComps.length > 0 ?
          Math.round(qualityValidatedComps.reduce((sum, c) => sum + extractCompPrice(c), 0) / qualityValidatedComps.length) :
          0,
        compCount: qualityValidatedComps.length,
        descriptionAnalysis,
        sequence,
        total,
        lotAreaValue: round(prop.lotAreaValue),
        pincode,
        price: prop.price,
        livingArea: prop.livingArea,
        bedrooms: prop.bedrooms,
        bathrooms: prop.bathrooms,
        rentZestimate: prop.rentZestimate,
        propertyIndex: sequence,
        totalProperties: total,
        redfinSoldComps: recentSold.map((p) => ({
          price: p.price,
          photos: p.photos,
          baths: p.baths,
          beds: p.beds,
          lotSize: p.lotSize,
          sqFt: p.sqFt,
          comp1Value: extractCompPrice(p),
          comp1LvgArea: extractCompSqft(p),
          latLong: p.latLong,
        })).slice(0, 10),
        redfinForSaleComps: forSaleHomes.map((p) => ({
          price: p.price,
          photos: p.photos,
          baths: p.baths,
          beds: p.beds,
          lotSize: p.lotSize,
          sqFt: p.sqFt,
          comp1Value: extractCompPrice(p),
          comp1LvgArea: extractCompSqft(p),
          latLong: p.latLong,
        })).slice(0, 10),
      };
    } catch (e) {
      return {
        error: `Failed strategy ${method}: ${e.message}`,
        zpid,
        method,
        sequence,
        total,
      };
    }
  }).filter((result) => result !== null);

  // Sanitize all results for FlutterFlow
  const sanitizedResults = results.map((result) => sanitizeForFlutterFlow(result));

  // Single-row mode
  if (params.strategy) {
    const chosen = sanitizedResults.find((result) => result.method === params.strategy);
    if (!chosen) {
      return [{
        error: `Strategy "${params.strategy}" not available for this property`,
        zpid,
        sequence,
        total,
      }];
    }
    return [chosen];
  } else {
    return sanitizedResults;
    // return sanitizedResults.length > 0 ? sanitizedResults : [{
    //   error: "No valid strategies found for this property",
    //   zpid,
    //   sequence,
    //   total,
    // }];
  }
}

// Nuclear option: Force all numeric fields to be proper doubles for FlutterFlow
function sanitizeForFlutterFlow(obj) {
  if (obj === null || obj === undefined) return {};
  if (typeof obj !== "object") return obj;
  const numericFields = [
    "futureValue", "impValue", "totalCosts", "netSaleProceeds", "netReturn", "netROI",
    "sellingCosts", "cashNeeded", "loanAmount", "downPayment", "monthlyPayment",
    "loanPayments", "loanFees", "permitsFees", "propertyTaxes", "propertyIns",
    "price", "livingArea", "bedrooms", "bathrooms", "sequence", "total",
    "monthlyRent", "annualRent", "annualNOI", "annualCashFlow", "monthlyCashFlow",
    "bestReturn", "bestROI", "strategiesAvailable", "zestimate", "pricePerSqft",
    "cashOnCashReturn", "optimalOffer", "avgDollarPerSqft", "avgDollarPerBdrm",
    "avgRentPerSqft", "duration", "futureLivingArea", "mtgRate", "extraValue",
    "totalValue", "mortgage", "propTaxIns", "yearBuilt", "lotAreaValue",
    "propertyIndex", "totalProperties", "rentZestimate", "irr", "roe", "groc", "dscr",
    "avgPricePerSqFt", "avgCompPrice", "compCount",
  ];
  const sanitized = {};
  for (const [key, value] of Object.entries(obj)) {
    if (numericFields.includes(key)) {
      const num = Number(value);
      sanitized[key] = (isNaN(num) || !isFinite(num)) ? 0.0 : Number(num.toFixed(2));
    } else if (key === "method") {
      sanitized[key] = String(value || "unknown");
    } else if (value === null || value === undefined) {
      sanitized[key] = "";
    } else if (typeof value === "string") {
      sanitized[key] = String(value || "");
    } else if (typeof value === "boolean") {
      sanitized[key] = Boolean(value);
    } else if (Array.isArray(value)) {
      if (key === "redfinSoldComps" || key === "redfinForSaleComps") {
        sanitized[key] = value.map((item) => ({
          ...item,
          comp1Value: Number(item.comp1Value) || 0,
          comp1LvgArea: Number(item.comp1LvgArea) || 0,
        }));
      } else {
        sanitized[key] = value.map((item) => sanitizeForFlutterFlow(item));
      }
    } else if (typeof value === "object" && value !== null) {
      sanitized[key] = sanitizeForFlutterFlow(value);
    } else {
      sanitized[key] = value;
    }
  }
  return sanitized;
}

module.exports = {
  processProperty,
};

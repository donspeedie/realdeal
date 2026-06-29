const { fetchZillowDataWithCache, fetchRedfinDataWithCache, fetchMarketSignal, fetchDistressCheck } = require("./oaDataApi");
const { calculateStrategy } = require("./strategyCalculator");
const {
  analyzeDescription,
  calculateBedroomPriceAverages,
  appendZillowUrl,
} = require("./utils");
const { round } = Math;

async function processProperty(prop, params, sequence, total) {
  if (!prop.price || !prop.livingArea) {
    return [{
      error: "Missing price or livingArea",
      zpid: prop.zpid,
      sequence,
      total,
    }];
  }

  // Normalize lot size to sqft (Zillow API returns lotAreaUnit as "sqft" or "acres")
  let lotSize = prop.lotAreaValue || 0;
  if (prop.lotAreaUnit && prop.lotAreaUnit.toLowerCase() === "acres") {
    lotSize = lotSize * 43560;
  }

  // Filter out properties with lot sizes below minimum
  const MIN_LOT_SIZE = 3200; // 3,200 sqft minimum
  if (lotSize > 0 && lotSize < MIN_LOT_SIZE) {
    return [];
  }

  const address = prop.address || prop.streetAddress || "";

  // Filter out apartments based on address using regex patterns
  const apartmentPatterns = [
    /\bapt\b/i, /\bapt[#\s\d-]/i, /[,.()]apt/i, /apartment/i,
    /\bunit\b/i, /\bunit[#\s\d-]/i, /[,.()]unit/i,
    /\bste\b/i, /\bste[#\s\d-]/i, /[,.()]ste/i,
    /\bsuite\b/i, /\bsuite[#\s\d-]/i,
  ];

  for (const pattern of apartmentPatterns) {
    if (pattern.test(address)) {
      return [];
    }
  }

  const addressParts = address.split(" ");
  const pincode = addressParts[addressParts.length - 1];
  const zpid = prop.zpid;

  const soldParams = { location: pincode };
  const forSaleParams = { location: pincode };
  let zestimateRes = { data: {} };
  let propertyDetailsRes = { data: {} };
  let soldRedfinRes = { data: {} };
  let forSaleRedfinRes = { data: {} };
  let marketSignalRes = { signal: "yellow", composite_score: 50, recommendation: "" };
  let distressRes = { has_distress: false, is_foreclosure: false, is_pre_foreclosure: false, has_tax_delinquency: false };

  // Extract street address and city for OA address-based lookups
  const streetAddress = prop.streetAddress || address.split(",")[0].trim();
  const cityFromAddress = address.split(",").length > 1 ? address.split(",")[1].trim() : "";

  // OA Data API config — uses address+city instead of zpid
  const oaLookupConfig = { address: streetAddress, city: cityFromAddress, state: "CA" };

  if (params.redfinForSaleComps && Array.isArray(params.redfinForSaleComps) && params.redfinSoldComps && Array.isArray(params.redfinSoldComps)) {
    // Using provided Redfin comps from params
    [zestimateRes, propertyDetailsRes, marketSignalRes, distressRes] = await Promise.all([
      fetchZillowDataWithCache("zestimate", oaLookupConfig).catch(() => ({ data: {} })),
      fetchZillowDataWithCache("propertyDetails", oaLookupConfig).catch(() => ({ data: {} })),
      fetchMarketSignal(pincode).catch(() => ({ signal: "yellow", composite_score: 50, recommendation: "" })),
      fetchDistressCheck(streetAddress, cityFromAddress).catch(() => ({ has_distress: false, is_foreclosure: false, is_pre_foreclosure: false, has_tax_delinquency: false })),
    ]);
  } else {
    // Fetching comps + valuation from OA Data API
    [zestimateRes, propertyDetailsRes, soldRedfinRes, forSaleRedfinRes, marketSignalRes, distressRes] = await Promise.all([
      fetchZillowDataWithCache("zestimate", oaLookupConfig).catch(() => ({ data: {} })),
      fetchZillowDataWithCache("propertyDetails", oaLookupConfig).catch(() => ({ data: {} })),
      fetchRedfinDataWithCache("searchSold", soldParams).catch(() => ({ data: {} })),
      fetchRedfinDataWithCache("searchForSale", forSaleParams).catch(() => ({ data: {} })),
      fetchMarketSignal(pincode).catch(() => ({ signal: "yellow", composite_score: 50, recommendation: "" })),
      fetchDistressCheck(streetAddress, cityFromAddress).catch(() => ({ has_distress: false, is_foreclosure: false, is_pre_foreclosure: false, has_tax_delinquency: false })),
    ]);
  }

  const zestimate = Math.round(zestimateRes.data?.value || 0);
  const recentSold = Array.isArray(params.redfinSoldComps) ? params.redfinSoldComps : Array.isArray(soldRedfinRes.data?.data?.homes) ? soldRedfinRes.data.data.homes : [];
  const forSaleHomes = Array.isArray(params.redfinForSaleComps) ? params.redfinForSaleComps : Array.isArray(forSaleRedfinRes.data?.data?.homes) ? forSaleRedfinRes.data.data.homes : [];

  // recentSold: ${recentSold.length}, forSaleHomes: ${forSaleHomes.length}

  // Filter out condos, apartments, mobile homes, townhomes, and multi-family properties based on description
  const description = (propertyDetailsRes.data?.description || "").toLowerCase();
  const excludedPropertyTypes = ["condo", "condos", "apartment", "apartments", "apt", "mobile", "mobile home", "condominiums", "double wide", "townhome", "townhouse", "duplex", "triplex", "fourplex", "multi-family", "multifamily", "multi-unit", "multiunit"];

  for (const propertyType of excludedPropertyTypes) {
    if (description.includes(propertyType)) {
      console.log(`Filtering out property ${prop.zpid} - contains '${propertyType}' in description: "${description.substring(0, 100)}..."`);
      return [];
    }
  }

  // === EDGE CASES ===
  // Filter out properties with abnormally high sqft/bedroom ratios (indicates multi-family conversions)
  const bedrooms = prop.bedrooms || 1; // Default to 1 to avoid division by zero
  const sqftPerBedroom = prop.livingArea / bedrooms;
  const MAX_SQFT_PER_BEDROOM = 1200; // Threshold for flagging multi-unit properties

  if (sqftPerBedroom > MAX_SQFT_PER_BEDROOM) {
    console.log(`Filtering out property ${prop.zpid} - abnormal sqft/bedroom ratio: ${Math.round(sqftPerBedroom)} sqft/bed (${prop.livingArea} sqft ÷ ${bedrooms} beds) > ${MAX_SQFT_PER_BEDROOM} threshold - likely multi-family conversion`);
    return [];
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

    // Try address matching first (most reliable) - require at least 2 of first 3 parts to match
    if (homeAddress && subjectAddress) {
      // Extract street number and street name for comparison
      const subjectParts = subjectAddress.split(/[\s,]+/);
      const homeParts = homeAddress.split(/[\s,]+/);

      // Check if at least 2 of first 3 parts match (more lenient than requiring all 3)
      if (subjectParts.length >= 2 && homeParts.length >= 2) {
        const matchCount = subjectParts.slice(0, 3).filter((part, i) =>
          homeParts[i] && homeParts[i].includes(part)
        ).length;
        if (matchCount >= 2) return true;
      }
    }

    // Fallback: Match by property characteristics - require 2 of 3 conditions (sqft, beds, price)
    if (subjectSqft > 0 && homeSqft > 0 && subjectBeds > 0) {
      const sqftMatch = Math.abs(homeSqft - subjectSqft) <= 50; // Within 50 sqft
      const bedsMatch = homeBeds === subjectBeds;
      const priceMatch = subjectPrice > 0 && homePrice > 0 &&
        Math.abs(homePrice - subjectPrice) / subjectPrice < 0.10; // Within 10% (widened from 5%)

      // Require at least 2 of 3 conditions to match (more flexible)
      const matchCount = [sqftMatch, bedsMatch, priceMatch].filter(Boolean).length;
      if (matchCount >= 2) return true;
    }

    return false;
  });

  if (matchedProperty) {
    subjectLevels = extractLevels(matchedProperty);
    // Found subject in Redfin data
  } else {
    // Subject not in Redfin results - using fallback level assumptions
  }

  // --- Enhanced avg price/sqft from comps (with multi-layered outlier filtering) ---
  let pricePerSqFt = 250;
  const subjectPricePerSqft = prop.price && prop.livingArea ? prop.price / prop.livingArea : 0;

  // Comp filtering: zpid=${prop.zpid} price=$${subjectPrice} sqft=${prop.livingArea}

  const qualityValidatedComps = recentSold.filter((c) => {
    const price = extractCompPrice(c);
    const sqft = extractCompSqft(c);
    const beds = c.beds || 0;
    const lotSize = extractLotSize(c);
    if (!price || !sqft || price <= 0 || sqft <= 0) return false;
    const pricePerSqft = price / sqft;

    // Tightened price range: ±20% of subject property price (was ±30%)
    const priceRatioReasonable = subjectPrice > 0
      ? (price >= subjectPrice * 0.8 && price <= subjectPrice * 1.2)
      : true; // Skip filter if no subject price

    // Tightened price/sqft range based on subject property (±25% instead of absolute $50-$1000)
    const pricePerSqftReasonable = subjectPricePerSqft > 0
      ? (pricePerSqft >= subjectPricePerSqft * 0.75 && pricePerSqft <= subjectPricePerSqft * 1.25)
      : (pricePerSqft >= 50 && pricePerSqft <= 1000); // Fallback to absolute range

    const sizeReasonable = sqft >= 400 && sqft <= 8000;
    const priceReasonable = price >= 50000 && price <= 5000000;
    const bedsReasonable = beds >= 1 && beds <= 10;
    const lotSizeReasonable = lotSize >= 3200; // Filter out lots smaller than 3,200 sqft
    return priceRatioReasonable && pricePerSqftReasonable && sizeReasonable && priceReasonable && bedsReasonable && lotSizeReasonable;
  });

  if (qualityValidatedComps.length > 0) {
    const filteredComps = detectOutliersEnhanced(qualityValidatedComps, prop, subjectPricePerSqft);

    // Filter comps by size similarity (±20% of subject property size, tightened from ±25%)
    const subjectSqft = prop.livingArea || 0;
    const sizeSimilarComps = filteredComps.filter((c) => {
      const compSqft = extractCompSqft(c);
      if (!compSqft || compSqft <= 0 || !subjectSqft) return true; // Include if no size data
      const sizeRatio = compSqft / subjectSqft;
      return sizeRatio >= 0.8 && sizeRatio <= 1.2; // Within ±20% of subject size
    });

    // Use size-similar comps if we have enough, otherwise fall back to all filtered comps
    const compsToUse = sizeSimilarComps.length >= 3 ? sizeSimilarComps : filteredComps;

    console.log(`📏 Size filtering: ${filteredComps.length} comps → ${sizeSimilarComps.length} size-similar (±20% of ${subjectSqft} sqft) → using ${compsToUse.length} comps`);

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
      // Separate global settings from property-specific overrides
      // Property-specific overrides should ONLY come from prop object, NOT from params
      const globalSettings = {
        ...params,
        filteredComps: qualityValidatedComps,
      };

      // Remove property-specific override fields from global settings to prevent cross-contamination
      delete globalSettings.impValue;
      delete globalSettings.futureValue;
      delete globalSettings.loanPayments;
      delete globalSettings.loanFees;
      delete globalSettings.sellingCosts;
      delete globalSettings.permitsFees;

      const enhancedParams = globalSettings;
      // Add levels data and normalized lot size to prop before passing to strategy calculator
      const propWithLevels = {
        ...prop,
        lotAreaValue: lotSize,
        levels: subjectLevels
      };
      const strategyResult = calculateStrategy(method, propWithLevels, enhancedParams, pricePerSqFt, twoBedAvg, bedroomAnalysis);
      // strategyResult logged only on error
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
        lotAreaValue: round(lotSize),
        pincode,
        price: prop.price,
        livingArea: prop.livingArea,
        bedrooms: prop.bedrooms,
        bathrooms: prop.bathrooms,
        rentZestimate: prop.rentZestimate,
        propertyIndex: sequence,
        totalProperties: total,
        redfinSoldComps: qualityValidatedComps.map((p) => ({
          address: p.address,
          price: p.price,
          photos: p.photos,
          baths: Number(p.baths || 0),
          beds: Number(p.beds || 0),
          lotSize: p.lotSize,
          sqFt: p.sqFt,
          comp1Value: extractCompPrice(p),
          comp1LvgArea: extractCompSqft(p),
          latLong: p.latLong,
        })).slice(0, 10),
        redfinForSaleComps: forSaleHomes.map((p) => ({
          address: p.address,
          price: p.price,
          photos: p.photos,
          baths: Number(p.baths || 0),
          beds: Number(p.beds || 0),
          lotSize: p.lotSize,
          sqFt: p.sqFt,
          comp1Value: extractCompPrice(p),
          comp1LvgArea: extractCompSqft(p),
          latLong: p.latLong,
        })).slice(0, 10),
        marketSignal: marketSignalRes.signal || "yellow",
        marketScore: marketSignalRes.composite_score || 50,
        marketRecommendation: marketSignalRes.recommendation || "",
        distressFlags: {
          hasDistress: distressRes.has_distress || false,
          isForeclosure: distressRes.is_foreclosure || false,
          isPreForeclosure: distressRes.is_pre_foreclosure || false,
          hasTaxDelinquency: distressRes.has_tax_delinquency || false,
          leadScore: distressRes.lead_score || null,
          leadTier: distressRes.lead_tier || null,
        },
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

  // Results: ${results.length}/${strategies.length} strategies for zpid ${prop.zpid}

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
    // Returning ${sanitizedResults.length} results for ${prop.zpid}
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

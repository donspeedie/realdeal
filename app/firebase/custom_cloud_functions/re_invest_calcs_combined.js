const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

// Helper: Format Zillow URL
const appendZillowUrl = (url) => {
  if (!url) return "";
  let cleanedUrl = url.trim();
  if (!cleanedUrl.startsWith("/")) cleanedUrl = "/" + cleanedUrl;
  return encodeURI(`https://www.zillow.com${cleanedUrl}`);
};

// Helper: Calculate average price per area with outlier detection
const calculateAvgPricePerArea = (comps, subjectPrice, subjectArea) => {
  if (!Array.isArray(comps)) comps = [];
  const raw = comps
    .filter(
      (c) =>
        c &&
        !isNaN(parseFloat(c.price)) &&
        parseFloat(c.livingArea ?? c.livingAreaValue) > 0,
    )
    .map((c, i) => ({
      compId: `comp${i + 1}`,
      price: parseFloat(c.price),
      area: parseFloat(c.livingArea ?? c.livingAreaValue),
      pricePerSf:
        parseFloat(c.price) / parseFloat(c.livingArea ?? c.livingAreaValue),
    }));

  if (raw.length === 0) {
    if (
      !isNaN(subjectPrice) &&
      !isNaN(subjectArea) &&
      subjectPrice > 0 &&
      subjectArea > 0
    )
      return {
        avgPricePerArea: subjectPrice / subjectArea,
        compCount: 0,
        compBreakdown: [],
      };
    return { avgPricePerArea: 250, compCount: 0, compBreakdown: [] };
  }

  raw.sort((a, b) => a.pricePerSf - b.pricePerSf);
  let used = raw;
  if (raw.length > 1) {
    const q1 = raw[Math.floor(raw.length * 0.25)].pricePerSf;
    const q3 =
      raw[Math.min(Math.ceil(raw.length * 0.75) - 1, raw.length - 1)]
        .pricePerSf;
    const iqr = q3 - q1;
    used = raw.filter(
      (r) => r.pricePerSf >= q1 - 1.5 * iqr && r.pricePerSf <= q3 + 1.5 * iqr,
    );
    if (used.length === 0) used = raw;
  }
  const avg = used.reduce((sum, c) => sum + c.pricePerSf, 0) / used.length;
  const breakdown = raw.map((r) => ({
    ...r,
    pricePerSf: parseFloat(r.pricePerSf.toFixed(2)),
    included: used.some((u) => u.compId === r.compId),
  }));
  return {
    avgPricePerArea: avg,
    compCount: used.length,
    compBreakdown: breakdown,
  };
};

// Helper: Analyze description for investment keywords
const INVESTMENT_KEYWORDS = [
  "fix",
  "repair",
  "contractor",
  "investor",
  "flip",
  "damage",
  "opportunity",
  "potential",
  "rehab",
  "renovate",
  "renovation",
  "remodel",
  "fixer",
  "handyman",
  "distressed",
  "tlc",
];
const analyzeDescription = (text) => {
  if (!text || typeof text !== "string")
    return { hasKeywords: false, matchedKeywords: [], keywordCount: 0 };
  const lower = text.toLowerCase();
  const matched = INVESTMENT_KEYWORDS.filter((k) => lower.includes(k));
  return {
    hasKeywords: matched.length > 0,
    matchedKeywords: matched,
    keywordCount: matched.length,
  };
};

// Helper: Calculate future property value
const calculateFutureValue = (
  avgPricePerArea,
  livingArea,
  impFactor,
  extra = 0,
) => Math.round(avgPricePerArea * livingArea * impFactor + extra);

// Helper: Calculate loan fees
const calculateLoanFees = (mortgage, rate) =>
  Math.min(Math.round(mortgage * rate), 20000);

exports.reInvestCalcsCombined = functions
  .region("us-west1")
  .runWith({ memory: "128MB" })
  .https.onCall(async (data, context) => {
    console.log("Invoked with:", JSON.stringify(data));

    // Fetch all Zillow properties
    let allProps = [];
    let page = 1;
    let totalPages = 1;
    try {
      do {
        const res = await axios.get(
          "https://zillow-com1.p.rapidapi.com/propertyExtendedSearch",
          {
            params: {
              propertyType: data.propertyType || "SINGLE_FAMILY",
              status_Type: data.status_Type || "FOR_SALE",
              location: data.location,
              page,
              minPrice: data.minPrice,
              maxPrice: data.maxPrice,
              daysOn: data.daysOn,
              lotSizeMin: data.lotSizeMin,
            },
            headers: {
              "X-Rapidapi-Key":
                "deb506d049msh6c9af2ef7c77712p10ea19jsn780ae6896eba",
              "X-Rapidapi-Host": "zillow-com1.p.rapidapi.com",
            },
          },
        );
        const { props, totalPages: tp } = res.data;
        allProps = allProps.concat(Array.isArray(props) ? props : []);
        totalPages = tp || 1;
        page++;
      } while (page <= totalPages);
    } catch (err) {
      console.error("Zillow API error", err);
      throw new functions.https.HttpsError("internal", "Failed Zillow fetch");
    }

    if (allProps.length === 0) return [];

    // Process each property
    const allResults = [];
    for (const prop of allProps) {
      try {
        // Destructure property data
        const {
          livingArea: apiLivingArea,
          address: apiAddress,
          imgSrc: apiImgSrc,
          latitude: apiLatitude,
          longitude: apiLongitude,
          lotAreaValue: apiLotAreaValue,
          priceChange: apiPriceChange,
          detailUrl: apiDetailUrl,
          bedrooms: apiBedrooms,
          bathrooms: apiBathrooms,
          daysOnZillow: apiDays,
          rentZestimate: apiRentZestimate,
          price: apiPrice,
          carouselPhotos = [],
          listingStatus,
          yearBuilt,
          zpid = 0,
          zestimate = 0,
          description = "",
        } = prop;

        // Combine with user inputs
        const inputs = {
          ...data,
          livingArea: apiLivingArea,
          address: apiAddress,
          imgSrc: apiImgSrc,
          latitude: apiLatitude,
          longitude: apiLongitude,
          lotAreaValue: apiLotAreaValue,
          priceChange: apiPriceChange,
          detailUrl: apiDetailUrl,
          bedrooms: apiBedrooms,
          bathrooms: apiBathrooms,
          daysOnZillow: apiDays,
          rentZestimate: apiRentZestimate,
          price: apiPrice,
          carouselPhotos,
          listingStatus,
          yearBuilt,
          zpid,
          zestimate,
          description: description || data.description || "",
        };

        // Skip non-qualifying properties
        const descAnalysis = analyzeDescription(inputs.description);
        if (
          !inputs.price ||
          (inputs.price < 30000 && !descAnalysis.hasKeywords)
        )
          continue;
        if (
          inputs.yearBuilt &&
          inputs.yearBuilt > 2000 &&
          !descAnalysis.hasKeywords
        )
          continue;

        // Calculate market metrics
        const url = appendZillowUrl(inputs.detailUrl);
        const { avgPricePerArea, compBreakdown } = calculateAvgPricePerArea(
          inputs.comps,
          inputs.price,
          inputs.livingArea,
        );

        // Define calculation function for this property
        const calc = (
          method,
          duration,
          futureValue,
          improvementValue,
          projArea = 0,
          projBeds = 0,
          projBaths = 0,
        ) => {
          const purchaseDate = new Date();
          const saleDate = new Date(purchaseDate);
          saleDate.setMonth(saleDate.getMonth() + Math.max(1, duration));

          // Calculate financial metrics
          const totalValue = Math.round(inputs.price + improvementValue);
          const downPayment = Math.round(
            totalValue * (inputs.dwnPmtRate || 0.2),
          );
          const mortgage = totalValue - downPayment;
          const loanFees = calculateLoanFees(
            mortgage,
            inputs.loanFeesRate || 0.01,
          );
          const totalInterest = Math.round(
            mortgage * (inputs.financingRate || 0.07) * (duration / 12),
          );
          const sellingCosts = Math.round(
            futureValue * (inputs.salRate || 0.06),
          );
          const totalCosts = Math.round(
            totalValue +
              sellingCosts +
              totalInterest +
              loanFees +
              (inputs.permitsFees || 0) +
              (inputs.propertyTaxes || 0) +
              (inputs.propertyIns || 0),
          );

          return {
            address: inputs.address,
            price: inputs.price,
            futureValue,
            improvementValue,
            method,
            duration,
            netROI: parseFloat(
              ((futureValue - totalCosts) / downPayment).toFixed(2),
            ),
            cashNeeded:
              downPayment +
              (inputs.propertyTaxes || 0) +
              (inputs.propertyIns || 0),
            propertyType: inputs.propertyType,
            bedrooms: inputs.bedrooms + projBeds,
            bathrooms: inputs.bathrooms + projBaths,
            livingArea: inputs.livingArea + projArea,
            latlng: { latitude: inputs.latitude, longitude: inputs.longitude },
            compBreakdown,
            descAnalysis,
            zpid: inputs.zpid,
            detailUrl: url,
            imgSrc: inputs.imgSrc,
          };
        };

        // Generate all strategy calculations
        const strategies = [
          [
            "Fix&Flip",
            data.fixnflipDuration || 6,
            calculateFutureValue(avgPricePerArea, inputs.livingArea, 1.1),
            inputs.livingArea * 100,
          ],
          [
            "Add-On",
            data.addOnDuration || 12,
            calculateFutureValue(
              avgPricePerArea,
              inputs.livingArea,
              1.2,
              data.oneBdrmMarketValue || 50000,
            ),
            inputs.livingArea * 120,
            data.addOnArea || 500,
            1,
            0.5,
          ],
          [
            "ADU",
            data.aduDuration || 10,
            calculateFutureValue(
              avgPricePerArea,
              inputs.livingArea,
              1.15,
              data.twoBedAvgValue || 75000,
            ),
            inputs.livingArea * 110 + (data.twoBdrmAduCost || 80000),
            data.aduArea || 800,
            2,
            1,
          ],
          [
            "New",
            data.newDuration || 12,
            calculateFutureValue(avgPricePerArea, inputs.livingArea, 1.3),
            inputs.livingArea * 200,
            data.newArea || inputs.livingArea * 1.2,
            data.newBeds || 3,
            data.newBaths || 2,
          ],
        ];

        // Process valid strategies
        strategies.forEach(([method, duration, fv, iv, area, beds, baths]) => {
          if (fv > inputs.price * 1.1) {
            // Minimum 10% appreciation
            const result = calc(method, duration, fv, iv, area, beds, baths);
            if (result.netROI > 0.15) allResults.push(result);
          }
        });
      } catch (err) {
        console.error(`Error processing property ${prop.zpid}:`, err);
      }
    }

    console.log(`Returning ${allResults.length} valid investments`);
    return allResults.sort((a, b) => b.netROI - a.netROI); // Sort by highest ROI first
  });

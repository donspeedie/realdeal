const axios = require("axios");
const {getCachedOrFetch} = require("./cacheUtils");

const BASE_URLS = {
  propertyExtendedSearch: "https://zillow-com1.p.rapidapi.com/propertyExtendedSearch",
  zestimate: "https://zillow-com1.p.rapidapi.com/zestimate",
  comps: "https://zillow-com1.p.rapidapi.com/propertyComps",
  propertyDetails: "https://zillow-com1.p.rapidapi.com/property",
  compsDetails: "https://zillow-com1.p.rapidapi.com/propertyComps",
};

async function fetchZillowDataWithCache(endpoint, config, maxRetries = 3) {
  // Standardizes a configuration object for cache key generation
  function standardizeConfig(config) {
  // Clone to avoid mutating the input
    const cleaned = {...config};

    // Example normalizations:
    if (cleaned.location) cleaned.location = String(cleaned.location).trim().toLowerCase();

    // Standardize price filters to integers
    if (cleaned.minPrice) cleaned.minPrice = parseInt(cleaned.minPrice, 10);
    if (cleaned.maxPrice) cleaned.maxPrice = parseInt(cleaned.maxPrice, 10);

    // Round lat/lng to 4 decimals if present
    if (cleaned.latitude) cleaned.latitude = Math.round(Number(cleaned.latitude) * 10000) / 10000;
    if (cleaned.longitude) cleaned.longitude = Math.round(Number(cleaned.longitude) * 10000) / 10000;

    // Remove undefined, null, or empty string values
    Object.keys(cleaned).forEach(
        (key) => (cleaned[key] === undefined || cleaned[key] === null || cleaned[key] === "") && delete cleaned[key],
    );

    // Sort object keys for stable JSON stringification
    return Object.keys(cleaned).sort().reduce((res, key) => {
      res[key] = cleaned[key];
      return res;
    }, {});
  }

  const keyConfig = standardizeConfig(config);
  const docId = `${endpoint}_${Buffer.from(JSON.stringify(keyConfig)).toString("base64")}`;
  async function realFetch() {
    let retries = 0;
    while (retries <= maxRetries) {
      try {
        const response = await axios.get(BASE_URLS[endpoint], {
          params: config,
          headers: {
            "X-Rapidapi-Key": process.env.RAPID_API_KEY,
            "X-Rapidapi-Host": "zillow-com1.p.rapidapi.com",
          },
          timeout: 15000,
        });
        return {
          status: response.status,
          data: response.data,
        // headers: response.headers, // <-- remove or sanitize if needed
        };
      } catch (err) {
        console.log(err.response);
        if (err.response.status === 429) {
          await new Promise((r) => setTimeout(r, 2000 + retries * 1000));
          retries++;
        } else {
          throw err;
        }
      }
    }
    throw new Error("Zillow API failed after retries.");
  }

  return getCachedOrFetch(`zillow_${endpoint}`, docId, realFetch);
}

module.exports = {fetchZillowDataWithCache};

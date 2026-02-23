const axios = require("axios");
const {getCachedOrFetch} = require("./cacheUtils");

const RAPIDAPI_HOST = "real-time-real-estate-data.p.rapidapi.com";

const BASE_URLS = {
  propertyExtendedSearch: `https://${RAPIDAPI_HOST}/search`,
  zestimate: `https://${RAPIDAPI_HOST}/zestimate`,
  comps: `https://${RAPIDAPI_HOST}/property-details`,
  propertyDetails: `https://${RAPIDAPI_HOST}/property-details`,
  compsDetails: `https://${RAPIDAPI_HOST}/property-details`,
};

// Map old param names to new API param names per endpoint
function adaptParams(endpoint, config) {
  if (endpoint === "propertyExtendedSearch") {
    const adapted = {...config};
    // Map camelCase params to snake_case for new API
    if (adapted.minPrice !== undefined) {
      adapted.min_price = adapted.minPrice;
      delete adapted.minPrice;
    }
    if (adapted.maxPrice !== undefined) {
      adapted.max_price = adapted.maxPrice;
      delete adapted.maxPrice;
    }
    if (adapted.propertyType !== undefined) {
      // Map old property type values to new API values
      const typeMap = {"SINGLE_FAMILY": "HOUSES", "TOWNHOUSE": "TOWNHOMES", "MULTI_FAMILY": "MULTI_FAMILY", "CONDO": "CONDOS_COOPS", "LOT": "LOTSLAND", "APARTMENT": "APARTMENTS", "MANUFACTURED": "MANUFACTURED"};
      adapted.home_type = typeMap[adapted.propertyType] || adapted.propertyType;
      delete adapted.propertyType;
    }
    if (adapted.status_Type !== undefined) {
      adapted.home_status = adapted.status_Type;
      delete adapted.status_Type;
    }
    if (adapted.lotSizeMin !== undefined) {
      adapted.min_lot_size = adapted.lotSizeMin;
      delete adapted.lotSizeMin;
    }
    return adapted;
  }
  return config;
}

// Normalize new API response to match old response shape
function adaptResponse(endpoint, rawData) {
  if (!rawData) {
    console.warn(`[ZillowAPI] adaptResponse: rawData is ${rawData} for ${endpoint}`);
    return endpoint === "propertyExtendedSearch" ? {props: [], totalResultCount: 0} : {};
  }

  // New API wraps responses in {status: "OK", data: [...]}
  const data = (rawData.status === "OK" && rawData.data !== undefined)
    ? rawData.data
    : rawData;

  // Search endpoint: new API returns flat array, old returned {props: [], totalResultCount}
  if (endpoint === "propertyExtendedSearch" && Array.isArray(data)) {
    return { props: data, totalResultCount: data.length };
  }

  // Search endpoint: handle {props: [...]} already in correct shape
  if (endpoint === "propertyExtendedSearch" && !data?.props) {
    console.warn(`[ZillowAPI] adaptResponse: no props array for ${endpoint}`, JSON.stringify(data).substring(0, 200));
    return {props: [], totalResultCount: 0};
  }

  if (endpoint === "zestimate" && data) {
    if (data.zestimate !== undefined && data.value === undefined) {
      return { ...data, value: data.zestimate };
    }
  }
  return data;
}

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
        const adaptedParams = adaptParams(endpoint, config);
        const response = await axios.get(BASE_URLS[endpoint], {
          params: adaptedParams,
          headers: {
            "X-Rapidapi-Key": process.env.RAPID_API_KEY,
            "X-Rapidapi-Host": RAPIDAPI_HOST,
          },
          timeout: 15000,
        });
        return {
          status: response.status,
          data: adaptResponse(endpoint, response.data),
        };
      } catch (err) {
        const errStatus = err.response?.status;
        const errData = err.response?.data;
        console.warn(`[ZillowAPI] ${endpoint} error: status=${errStatus} message=${err.message}`, errData ? JSON.stringify(errData).substring(0, 200) : "");
        if (errStatus === 429) {
          await new Promise((r) => setTimeout(r, 2000 + retries * 1000));
          retries++;
        } else {
          throw new Error(`Zillow API ${endpoint} failed: ${err.message} (status=${errStatus})`);
        }
      }
    }
    throw new Error("Zillow API failed after retries.");
  }

  return getCachedOrFetch(`zillow_${endpoint}`, docId, realFetch);
}

module.exports = {fetchZillowDataWithCache};

/**
 * OA Data API adapter — drop-in replacement for zillowApi.js + redfinApi.js.
 *
 * Routes all property data requests to OA's canonical data API instead of
 * RapidAPI subscriptions. Same function signatures, same response shapes.
 *
 * Environment:
 *   OA_DATA_API_URL — Base URL (default: http://localhost:8010)
 */

const axios = require("axios");
const { getCachedOrFetch } = require("./cacheUtils");

const OA_DATA_API_URL = process.env.OA_DATA_API_URL || "http://localhost:8010";

/**
 * Normalize a location string for the OA Data API.
 *
 * The OA Data API's location parser does not handle the "City, State" format
 * (e.g. "Stockton, CA" returns 0 results while "Stockton" returns matches).
 * RealDeal historically passed Zillow-shape "City, State" strings, which caused
 * silent 0-result responses in production scans. Strip the state suffix so the
 * parser receives a bare city. See VERIFICATION_CHECKLIST.md §0 (fix option a).
 *
 * @param {string} location - Raw location (may be "City, State" or "City").
 * @returns {string} The city portion, trimmed. Non-strings pass through as-is.
 */
function normalizeLocation(location) {
  if (typeof location !== "string") return location;
  const city = location.split(",")[0].trim();
  return city || location;
}

/**
 * Replaces fetchZillowDataWithCache from zillowApi.js.
 * Routes to OA Data API based on endpoint name.
 *
 * Supported endpoints:
 *   - "zestimate" → /api/v1/valuation/estimate
 *   - "propertyDetails" → /api/v1/valuation/details
 *   - "propertyExtendedSearch" → /api/v1/listings/search
 */
async function fetchZillowDataWithCache(endpoint, config, maxRetries = 2) {
  const docId = `oa_zillow_${endpoint}_${Buffer.from(JSON.stringify(config)).toString("base64")}`;

  async function realFetch() {
    let retries = 0;
    while (retries <= maxRetries) {
      try {
        let url;
        let params = {};

        if (endpoint === "zestimate") {
          // zpid is "oa_<id>" — extract address from the prop context
          // For zestimate, we need address+city. The caller passes {zpid}.
          // Since OA uses address-based lookup, we pass zpid as-is and
          // the API will resolve it. If zpid starts with "oa_", use the
          // listing search to find it.
          if (config.address && config.city) {
            url = `${OA_DATA_API_URL}/api/v1/valuation/estimate`;
            params = { address: config.address, city: config.city, state: config.state || "CA" };
          } else {
            // Fallback: return empty data (no zpid-based lookup in OA)
            return { status: 200, data: { value: 0 } };
          }
        } else if (endpoint === "propertyDetails") {
          if (config.address && config.city) {
            url = `${OA_DATA_API_URL}/api/v1/valuation/details`;
            params = { address: config.address, city: config.city, state: config.state || "CA" };
          } else {
            // Fallback: return empty property details
            return { status: 200, data: {} };
          }
        } else if (endpoint === "propertyExtendedSearch") {
          url = `${OA_DATA_API_URL}/api/v1/listings/search`;
          params = {
            location: normalizeLocation(config.location),
            min_price: config.minPrice || config.min_price,
            max_price: config.maxPrice || config.max_price,
          };
        } else {
          console.warn(`[OA-API] Unknown Zillow endpoint: ${endpoint}`);
          return { status: 200, data: {} };
        }

        const response = await axios.get(url, { params, timeout: 10000 });

        if (endpoint === "zestimate") {
          // OA returns {status, data: {value}} — matches Zillow shape
          return { status: 200, data: response.data.data || { value: 0 } };
        } else if (endpoint === "propertyDetails") {
          // OA returns {status, data: {propertyDetails: {...}}} — unwrap to match
          const details = response.data.data?.propertyDetails || {};
          return { status: 200, data: details };
        } else if (endpoint === "propertyExtendedSearch") {
          // OA returns {props: [...], totalResultCount} — matches adapted Zillow shape
          return { status: 200, data: response.data };
        }

        return { status: 200, data: response.data };
      } catch (err) {
        if (err.response?.status === 404) {
          // Property not in coverage — return empty gracefully
          if (endpoint === "zestimate") return { status: 200, data: { value: 0 } };
          if (endpoint === "propertyDetails") return { status: 200, data: {} };
          return { status: 200, data: { props: [], totalResultCount: 0 } };
        }
        if (err.response?.status === 429 || err.code === "ECONNREFUSED") {
          await new Promise((r) => setTimeout(r, 1000 + retries * 500));
          retries++;
        } else {
          console.warn(`[OA-API] ${endpoint} error: ${err.message}`);
          throw err;
        }
      }
    }
    throw new Error(`OA Data API ${endpoint} failed after ${maxRetries} retries`);
  }

  return getCachedOrFetch(`oa_zillow_${endpoint}`, docId, realFetch);
}

/**
 * Replaces fetchRedfinDataWithCache from redfinApi.js.
 * Routes to OA Data API comp endpoints.
 *
 * Supported endpoints:
 *   - "searchSold" → /api/v1/comps/sold
 *   - "searchForSale" → /api/v1/comps/for-sale
 */
async function fetchRedfinDataWithCache(endpoint, config, maxRetries = 2) {
  const docId = `oa_redfin_${endpoint}_${Buffer.from(JSON.stringify(config)).toString("base64")}`;

  async function realFetch() {
    let retries = 0;
    while (retries <= maxRetries) {
      try {
        let url;
        const params = { location: normalizeLocation(config.location), limit: 50 };

        if (endpoint === "searchSold") {
          url = `${OA_DATA_API_URL}/api/v1/comps/sold`;
        } else if (endpoint === "searchForSale") {
          url = `${OA_DATA_API_URL}/api/v1/comps/for-sale`;
        } else {
          console.warn(`[OA-API] Unknown Redfin endpoint: ${endpoint}`);
          return { status: 200, data: { data: { homes: [] } } };
        }

        const response = await axios.get(url, { params, timeout: 10000 });

        // OA returns {status, data: {data: {homes: [...]}}} — matches Redfin shape
        return { status: 200, data: response.data.data || { data: { homes: [] } } };
      } catch (err) {
        if (err.response?.status === 429 || err.code === "ECONNREFUSED") {
          await new Promise((r) => setTimeout(r, 1000 + retries * 500));
          retries++;
        } else {
          console.warn(`[OA-API] ${endpoint} error: ${err.message}`);
          throw err;
        }
      }
    }
    throw new Error(`OA Data API ${endpoint} failed after ${maxRetries} retries`);
  }

  return getCachedOrFetch(`oa_redfin_${endpoint}`, docId, realFetch);
}

/**
 * Fetch market signal for a ZIP code.
 * New endpoint — not in original Zillow/Redfin APIs.
 */
async function fetchMarketSignal(zipCode) {
  try {
    const response = await axios.get(`${OA_DATA_API_URL}/api/v1/market/signal`, {
      params: { zip_code: zipCode },
      timeout: 5000,
    });
    return response.data;
  } catch (err) {
    console.warn(`[OA-API] Market signal error: ${err.message}`);
    return { signal: "yellow", composite_score: 50, recommendation: "Data unavailable" };
  }
}

/**
 * Check distress signals for a property address.
 * New endpoint — not in original Zillow/Redfin APIs.
 */
async function fetchDistressCheck(address, city) {
  try {
    const response = await axios.get(`${OA_DATA_API_URL}/api/v1/distress/check`, {
      params: { address, city },
      timeout: 5000,
    });
    return response.data;
  } catch (err) {
    console.warn(`[OA-API] Distress check error: ${err.message}`);
    return {
      has_distress: false,
      is_foreclosure: false,
      is_pre_foreclosure: false,
      has_tax_delinquency: false,
    };
  }
}

module.exports = {
  fetchZillowDataWithCache,
  fetchRedfinDataWithCache,
  fetchMarketSignal,
  fetchDistressCheck,
  normalizeLocation,
};

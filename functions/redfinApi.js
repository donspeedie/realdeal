const axios = require("axios");
const {getCachedOrFetch} = require("./cacheUtils");

const RAPIDAPI_HOST = "redfin-base.p.rapidapi.com";

const BASE_URLS = {
  searchSold: `https://${RAPIDAPI_HOST}/redfin/search/location/for-sold`,
  searchForSale: `https://${RAPIDAPI_HOST}/redfin/search/location/for-sale`,
};

async function fetchRedfinDataWithCache(endpoint, config, maxRetries = 3) {
  // Create a unique cache key based on endpoint and parameters
  const docId = `${endpoint}_${Buffer.from(JSON.stringify(config)).toString("base64")}`;

  // Wrap the actual fetching logic for cache
  async function realFetch() {
    let retries = 0;

    // Redfin API: ${endpoint}

    while (retries <= maxRetries) {
      try {
        // Strip search_type param — now encoded in the endpoint URL
        const params = {...config};
        delete params.search_type;
        const response = await axios.get(BASE_URLS[endpoint], {
          params: params,
          headers: {
            "X-Rapidapi-Key": process.env.RAPID_API_KEY,
            "X-Rapidapi-Host": RAPIDAPI_HOST,
          },
          timeout: 15000,
        });

        // Redfin success: ${endpoint}
        return {
          status: response.status,
          data: response.data,
        // headers: response.headers, // <-- remove or sanitize if needed
        };
      } catch (err) {
        // Redfin error: ${err.response?.status || err.message}

        if (err.response?.status === 429) {
          await new Promise((r) => setTimeout(r, 2000 + retries * 1000));
          retries++;
        } else {
          throw err;
        }
      }
    }
    throw new Error("Redfin API failed after retries.");
  }
  // Use the cache utility, store in a per-endpoint collection
  return getCachedOrFetch(`redfin_${endpoint}`, docId, realFetch);
}

module.exports = {fetchRedfinDataWithCache};

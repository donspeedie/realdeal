import axios from 'axios';
import { getCachedOrFetch } from '../cache';

const RAPIDAPI_HOST = "real-time-real-estate-data.p.rapidapi.com";

const BASE_URLS = {
  propertyExtendedSearch: `https://${RAPIDAPI_HOST}/search`,
  zestimate: `https://${RAPIDAPI_HOST}/zestimate`,
  comps: `https://${RAPIDAPI_HOST}/property-details`,
  propertyDetails: `https://${RAPIDAPI_HOST}/property-details`,
  compsDetails: `https://${RAPIDAPI_HOST}/property-details`,
} as const;

type ZillowEndpoint = keyof typeof BASE_URLS;

interface ZillowApiConfig {
  location?: string;
  minPrice?: number;
  maxPrice?: number;
  latitude?: number;
  longitude?: number;
  [key: string]: any;
}

interface ZillowApiResponse {
  status: number;
  data: any;
}

export async function fetchZillowDataWithCache(
  endpoint: ZillowEndpoint,
  config: ZillowApiConfig,
  maxRetries: number = 3
): Promise<ZillowApiResponse> {
  // Standardizes a configuration object for cache key generation
  function standardizeConfig(config: ZillowApiConfig): Record<string, any> {
    // Clone to avoid mutating the input
    const cleaned = { ...config };

    // Example normalizations:
    if (cleaned.location) cleaned.location = String(cleaned.location).trim().toLowerCase();

    // Standardize price filters to integers
    if (cleaned.minPrice) cleaned.minPrice = parseInt(String(cleaned.minPrice), 10);
    if (cleaned.maxPrice) cleaned.maxPrice = parseInt(String(cleaned.maxPrice), 10);

    // Round lat/lng to 4 decimals if present
    if (cleaned.latitude) cleaned.latitude = Math.round(Number(cleaned.latitude) * 10000) / 10000;
    if (cleaned.longitude) cleaned.longitude = Math.round(Number(cleaned.longitude) * 10000) / 10000;

    // Remove undefined, null, or empty string values
    Object.keys(cleaned).forEach(
      (key) => (cleaned[key] === undefined || cleaned[key] === null || cleaned[key] === "") && delete cleaned[key],
    );

    // Sort object keys for stable JSON stringification
    return Object.keys(cleaned).sort().reduce((res: Record<string, any>, key) => {
      res[key] = cleaned[key];
      return res;
    }, {});
  }

  const keyConfig = standardizeConfig(config);
  const docId = `${endpoint}_${Buffer.from(JSON.stringify(keyConfig)).toString("base64")}`;

  async function realFetch(): Promise<ZillowApiResponse> {
    let retries = 0;
    while (retries <= maxRetries) {
      try {
        const response = await axios.get(BASE_URLS[endpoint], {
          params: config,
          headers: {
            "X-Rapidapi-Key": process.env.RAPID_API_KEY,
            "X-Rapidapi-Host": RAPIDAPI_HOST,
          },
          timeout: 15000,
        });
        // New API wraps responses in {status: "OK", data: [...]}
        const rawData = response.data;
        let unwrapped = (rawData && rawData.status === "OK" && rawData.data !== undefined)
          ? rawData.data
          : rawData;
        // Search endpoint: new API returns flat array, old returned {props: [], totalResultCount}
        if (endpoint === "propertyExtendedSearch" && Array.isArray(unwrapped)) {
          unwrapped = { props: unwrapped, totalResultCount: unwrapped.length };
        }
        return {
          status: response.status,
          data: unwrapped,
        };
      } catch (err: any) {
        console.log(err.response);
        if (err.response?.status === 429) {
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
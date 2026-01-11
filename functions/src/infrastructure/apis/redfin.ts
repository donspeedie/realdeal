import axios from 'axios';
import { getCachedOrFetch } from '../cache';

const BASE_URLS = {
  propertySearch: "https://redfin-com-data.p.rapidapi.com/property/search",
} as const;

type RedfinEndpoint = keyof typeof BASE_URLS;

interface RedfinApiConfig {
  [key: string]: any;
}

interface RedfinApiResponse {
  status: number;
  data: any;
}

export async function fetchRedfinDataWithCache(
  endpoint: RedfinEndpoint,
  config: RedfinApiConfig,
  maxRetries: number = 3
): Promise<RedfinApiResponse> {
  // Create a unique cache key based on endpoint and parameters
  const docId = `${endpoint}_${Buffer.from(JSON.stringify(config)).toString("base64")}`;

  // Wrap the actual fetching logic for cache
  async function realFetch(): Promise<RedfinApiResponse> {
    let retries = 0;
    while (retries <= maxRetries) {
      try {
        const response = await axios.get(BASE_URLS[endpoint], {
          params: config,
          headers: {
            "X-Rapidapi-Key": process.env.RAPID_API_KEY,
          },
          timeout: 15000,
        });
        return {
          status: response.status,
          data: response.data,
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
    throw new Error("Redfin API failed after retries.");
  }

  // Use the cache utility, store in a per-endpoint collection
  return getCachedOrFetch(`redfin_${endpoint}`, docId, realFetch);
}
interface DescriptionAnalysis {
  hasKeywords: boolean;
  keywords: string[];
  keywordCount: number;
}

interface PropertyWithPrice {
  price: number;
  livingArea: number;
}

interface BedroomPriceAverage {
  bedrooms: number;
  count: number;
  avgPrice: number;
  minPrice: number;
  maxPrice: number;
  avgPricePerSqFt: number;
}

interface ZillowProperty {
  beds?: number;
  price?: number | { value?: number };
  sqFt?: number | { value?: number };
  livingArea?: number;
  data?: {
    aboveTheFold?: {
      addressSectionInfo?: {
        priceInfo?: { amount?: number };
        sqFt?: { value?: number };
      };
    };
  };
}

export const analyzeDescription = (text: string): DescriptionAnalysis => {
  const keywords = ["fix", "repair", "contractor", "investor", "flip", "damage"];
  const lower = (text || "").toLowerCase();
  return {
    hasKeywords: keywords.some((k) => lower.includes(k)),
    keywords: keywords.filter((k) => lower.includes(k)),
    keywordCount: keywords.filter((k) => lower.includes(k)).length,
  };
};

export const calculateAvgSqFt = (group: PropertyWithPrice[]): number => {
  const valid = group.filter((p) => p.livingArea > 0 && p.price > 0);
  if (!valid.length) return 0;
  const total = valid.reduce((sum, p) => sum + (p.price / p.livingArea), 0);
  return Math.round(total / valid.length);
};

export const calculateBedroomPriceAverages = (properties: ZillowProperty[]): BedroomPriceAverage[] => {
  const groups: PropertyWithPrice[][] = Array(5).fill(null).map(() => []);

  for (const p of properties) {
    const beds = Math.min(5, Math.max(1, Math.floor(Number(p.beds) || 0)));
    const price = Number(p.data?.aboveTheFold?.addressSectionInfo?.priceInfo?.amount ||
                        (typeof p.price === "object" ? p.price?.value : p.price));
    const livingArea = Number(p.data?.aboveTheFold?.addressSectionInfo?.sqFt?.value ||
                             (typeof p.sqFt === "object" ? p.sqFt?.value : p.sqFt || p.livingArea)) || 0;
    if (!isNaN(price)) groups[beds - 1].push({price, livingArea});
  }

  return groups.map((group, idx) => {
    const prices = group.map((p) => p.price).filter((x) => !isNaN(x));
    if (!prices.length) return null;
    const sorted = [...prices].sort((a, b) => a - b);
    const avg = Math.round(sorted.reduce((s, v) => s + v, 0) / sorted.length);
    return {
      bedrooms: idx + 1,
      count: sorted.length,
      avgPrice: avg,
      minPrice: sorted[0],
      maxPrice: sorted[sorted.length - 1],
      avgPricePerSqFt: calculateAvgSqFt(group),
    };
  }).filter((item): item is BedroomPriceAverage => item !== null);
};

export const appendZillowUrl = (url: string): string => {
  if (!url) return "";
  return encodeURI(`https://www.zillow.com${url.startsWith("/") ? url : "/" + url}`);
};
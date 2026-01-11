const analyzeDescription = (text) => {
  const keywords = ["fix", "repair", "contractor", "investor", "flip", "damage"];
  const lower = (text || "").toLowerCase();
  return {
    hasKeywords: keywords.some((k) => lower.includes(k)),
    keywords: keywords.filter((k) => lower.includes(k)),
    keywordCount: keywords.filter((k) => lower.includes(k)).length,
  };
};

const calculateAvgSqFt = (group) => {
  const valid = group.filter((p) => p.livingArea > 0 && p.price > 0);
  if (!valid.length) return 0;
  const total = valid.reduce((sum, p) => sum + (p.price / p.livingArea), 0);
  return Math.round(total / valid.length);
};

const calculateBedroomPriceAverages = (properties) => {
  const groups = Array(5).fill().map(() => []);
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
  }).filter(Boolean);
};

const appendZillowUrl = (url) => {
  if (!url) return "";
  return encodeURI(`https://www.zillow.com${url.startsWith("/") ? url : "/" + url}`);
};

module.exports = {
  analyzeDescription,
  calculateBedroomPriceAverages,
  appendZillowUrl,
};

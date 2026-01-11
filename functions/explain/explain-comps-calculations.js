// Comprehensive explanation of how comparable sales (comps) calculations work

console.log("=== HOW RECENTLY SOLD COMPS CALCULATIONS WORK ===\n");

console.log("📍 STEP 1: GEOGRAPHIC SEARCH");
console.log("• Extracts ZIP CODE from property address");
console.log("• Example: '123 Main St, Sacramento, CA 95820' → '95820'");
console.log("• Searches Redfin for recently SOLD homes in that ZIP code");
console.log("• Also searches for homes currently FOR SALE (separate dataset)");

console.log("\n🔍 STEP 2: QUALITY VALIDATION FILTER");
console.log("Raw comps are filtered for data quality:");
console.log("• Price: $50,000 - $5,000,000");
console.log("• Square feet: 400 - 8,000 sqft");
console.log("• Price per sqft: $50 - $1,000/sqft");
console.log("• Bedrooms: 1 - 10 bedrooms");
console.log("• Must have complete price AND sqft data");

console.log("\n📊 STEP 3: STATISTICAL OUTLIER DETECTION");
console.log("Multi-layered outlier filtering using:");

console.log("\n  🎯 Modified Z-Score Test:");
console.log("  • Calculates median and MAD (Median Absolute Deviation)");
console.log("  • Formula: |0.6745 × (price_per_sqft - median) / MAD|");
console.log("  • Rejects comps with Z-score > 3.5");

console.log("\n  📈 Percentile Filter:");
console.log("  • Keeps comps between 10th and 90th percentiles");
console.log("  • Removes extreme high/low values automatically");

console.log("\n  🏠 Subject Property Range:");
console.log("  • Min: Subject price/sqft × 0.3 (or $100 minimum)");
console.log("  • Max: Subject price/sqft × 1.3 (or $600 maximum)");
console.log("  • Ensures comps are reasonably similar to subject");

console.log("\n⚖️ STEP 4: WEIGHTED AVERAGE CALCULATION");
console.log("Comps are weighted by similarity to subject property:");

console.log("\n  📐 Size Similarity (60% weight):");
console.log("  • Formula: 1 - |comp_sqft - subject_sqft| / max(comp_sqft, subject_sqft)");
console.log("  • Closer sizes = higher weight");

console.log("\n  🛏️ Bedroom Similarity (40% weight):");
console.log("  • Formula: 1 - |comp_beds - subject_beds| / 5");
console.log("  • Closer bedroom count = higher weight");

console.log("\n  🎲 Final Weight:");
console.log("  • Combined: (size_similarity × 0.6 + bed_similarity × 0.4) × 0.5 + 0.5");
console.log("  • Minimum weight: 0.5 (ensures all valid comps contribute)");
console.log("  • Maximum weight: 1.0 (perfect match)");

console.log("\n💰 STEP 5: PRICE PER SQFT CALCULATION");
console.log("Final price per sqft determination:");

console.log("\n  ✅ If 3+ filtered comps: Use weighted average");
console.log("  ✅ If 1-2 filtered comps: Use simple average");
console.log("  ⚠️  If no valid comps: Use subject property × 1.1");
console.log("  🔄 Ultimate fallback: $250/sqft default");

console.log("\n🏢 STEP 6: SPECIALIZED CALCULATIONS");

console.log("\n  🛏️ Two-Bedroom Average:");
console.log("  • Filters comps to only 2-bedroom properties");
console.log("  • Calculates simple average price (not per sqft)");
console.log("  • Used for ADU valuation strategies");

console.log("\n  📈 Bedroom Analysis:");
console.log("  • Groups comps by bedroom count");
console.log("  • Calculates average prices for each bedroom tier");
console.log("  • Used for Add-On bedroom value calculations");

console.log("\n🎯 REAL-WORLD EXAMPLE WALKTHROUGH:");

// Simulate a realistic scenario
const exampleSubject = {
  address: "8635 Bridgecross Dr Sacramento, CA 95835",
  price: 499000,
  livingArea: 1522,
  bedrooms: 5,
  bathrooms: 3
};

const exampleComps = [
  { price: 520000, sqft: 1600, beds: 4, pricePerSqft: 325 },
  { price: 475000, sqft: 1450, beds: 4, pricePerSqft: 328 },
  { price: 510000, sqft: 1580, beds: 5, pricePerSqft: 323 },
  { price: 495000, sqft: 1520, beds: 5, pricePerSqft: 326 },
  { price: 180000, sqft: 800, beds: 2, pricePerSqft: 225 }, // Outlier - too small
  { price: 850000, sqft: 1600, beds: 4, pricePerSqft: 531 }, // Outlier - too expensive
];

console.log(`\nSubject Property: ${exampleSubject.livingArea} sqft, ${exampleSubject.bedrooms} beds`);
console.log("Raw Comps Found: 6 properties");

// Simulate quality filter
const qualityFiltered = exampleComps.filter(c =>
  c.pricePerSqft >= 50 && c.pricePerSqft <= 1000 &&
  c.sqft >= 400 && c.sqft <= 8000 &&
  c.price >= 50000 && c.price <= 5000000
);
console.log(`After Quality Filter: ${qualityFiltered.length} properties`);

// Simulate outlier detection (simplified)
const median = 326;
const outlierFiltered = qualityFiltered.filter(c =>
  Math.abs(c.pricePerSqft - median) < 50 // Simplified outlier test
);
console.log(`After Outlier Filter: ${outlierFiltered.length} properties`);

// Simulate weighting (simplified)
const weights = outlierFiltered.map(c => {
  const sizeSim = 1 - Math.abs(c.sqft - exampleSubject.livingArea) / Math.max(c.sqft, exampleSubject.livingArea);
  const bedSim = Math.max(0, 1 - Math.abs(c.beds - exampleSubject.bedrooms) / 5);
  return (sizeSim * 0.6 + bedSim * 0.4) * 0.5 + 0.5;
});

console.log(`\nWeighted Calculations:`);
outlierFiltered.forEach((c, i) => {
  console.log(`  Comp ${i+1}: ${c.sqft}sqft, ${c.beds}bed, $${c.pricePerSqft}/sqft, weight: ${weights[i].toFixed(2)}`);
});

const weightedAvg = outlierFiltered.reduce((sum, c, i) => sum + (c.pricePerSqft * weights[i]), 0) /
                    weights.reduce((sum, w) => sum + w, 0);

console.log(`\nFinal Price Per SqFt: $${Math.round(weightedAvg)}/sqft`);

console.log("\n🔑 KEY BENEFITS OF THIS APPROACH:");
console.log("✅ Geographic relevance (same ZIP code)");
console.log("✅ Data quality assurance (multiple filters)");
console.log("✅ Statistical rigor (outlier detection)");
console.log("✅ Similarity weighting (size & bedroom matching)");
console.log("✅ Robust fallbacks (never fails to produce a value)");
console.log("✅ Market-based pricing (actual recent sales)");

console.log("\n⚠️ LIMITATIONS:");
console.log("• Limited to ZIP code geography (may miss closer properties in adjacent ZIPs)");
console.log("• No consideration of sale date/seasonality");
console.log("• No adjustment for property condition/features");
console.log("• Relies on Redfin data availability and accuracy");

console.log("\n💡 USAGE IN VALUATIONS:");
console.log("The calculated price per sqft is used as the base market rate for:");
console.log("• Fix & Flip future values: livingArea × pricePerSqft × 1.03");
console.log("• Add-On calculations: existing area + new area valuations");
console.log("• New Build projections: expanded area × pricePerSqft × 1.25");
console.log("• Market reasonableness checks across all strategies");
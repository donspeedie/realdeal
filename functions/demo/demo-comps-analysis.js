// Demonstration of how comparable sales (comps) analysis works
console.log("=== COMPARABLE SALES (COMPS) ANALYSIS BREAKDOWN ===\n");

function demonstrateCompsProcess() {
  console.log("📍 STEP 1: LOCATION-BASED COMP SEARCH");
  console.log("━".repeat(50));
  console.log("• Extract ZIP CODE from subject property address");
  console.log("• Search Redfin for recently SOLD properties in same ZIP");
  console.log("• No specific date filter (gets 'recent' sales from Redfin)");
  console.log("• Example: '123 Main St, Sacramento, CA 95835' → Search ZIP 95835");

  console.log("\n📊 STEP 2: DATA QUALITY FILTERING");
  console.log("━".repeat(50));
  console.log("Filters applied to raw comp data:");
  console.log("✓ Has valid price (> $0)");
  console.log("✓ Has valid square footage (> $0)");
  console.log("✓ Price per sqft: $50 - $1,000 (removes outliers)");
  console.log("✓ Size: 400 - 8,000 sqft (realistic range)");
  console.log("✓ Price: $50k - $5M (market reasonable)");
  console.log("✓ Bedrooms: 1 - 10 (valid bedroom count)");

  console.log("\n🎯 STEP 3: STATISTICAL OUTLIER DETECTION");
  console.log("━".repeat(50));
  console.log("Advanced outlier filtering using multiple methods:");

  console.log("\nA) MARKET REASONABLENESS:");
  console.log("   • Compare to subject property price/sqft");
  console.log("   • Range: 30% - 130% of subject's price/sqft");

  console.log("\nB) MODIFIED Z-SCORE (MAD Method):");
  console.log("   • Calculate median price/sqft of all comps");
  console.log("   • Calculate MAD (Median Absolute Deviation)");
  console.log("   • Remove comps with Z-score > 3.5");

  console.log("\nC) PERCENTILE FILTERING:");
  console.log("   • Remove bottom 10% and top 10% of prices");
  console.log("   • Keeps the 'middle 80%' of the market");

  console.log("\n⚖️ STEP 4: WEIGHTED AVERAGE CALCULATION");
  console.log("━".repeat(50));
  console.log("Each comp gets a WEIGHT based on similarity to subject:");

  console.log("\nSIZE SIMILARITY (60% of weight):");
  console.log("   • Formula: 1 - |comp_sqft - subject_sqft| / max(comp_sqft, subject_sqft)");
  console.log("   • More similar size = higher weight");

  console.log("\nBEDROOM SIMILARITY (40% of weight):");
  console.log("   • Formula: max(0, 1 - |comp_beds - subject_beds| / 5)");
  console.log("   • More similar bedroom count = higher weight");

  console.log("\nFINAL WEIGHT:");
  console.log("   • Combined weight = (size_weight × 0.6 + bedroom_weight × 0.4) × 0.5 + 0.5");
  console.log("   • Minimum weight: 0.5 (every comp has some value)");
  console.log("   • Maximum weight: 1.0 (perfect match)");

  console.log("\n💰 STEP 5: PRICE PER SQUARE FOOT CALCULATION");
  console.log("━".repeat(50));
  console.log("Final market price calculation:");
  console.log("• Weighted Average = Σ(comp_price_per_sqft × weight) / Σ(weights)");
  console.log("• Fallback: Simple average if weighted calculation fails");
  console.log("• Default: $250/sqft if no valid comps found");

  console.log("\n🏠 EXAMPLE WALKTHROUGH:");
  console.log("━".repeat(50));

  const exampleSubject = {
    address: "123 Main St, Sacramento, CA 95835",
    livingArea: 1500,
    bedrooms: 3,
    price: 400000
  };

  console.log(`Subject Property: ${exampleSubject.livingArea} sqft, ${exampleSubject.bedrooms} bed, $${exampleSubject.price.toLocaleString()}`);
  console.log(`Subject Price/SqFt: $${Math.round(exampleSubject.price / exampleSubject.livingArea)}/sqft`);

  console.log("\nExample Comps Found (after filtering):");

  const exampleComps = [
    { address: "nearby", sqft: 1450, beds: 3, price: 385000, weight: 0.92 },
    { address: "nearby", sqft: 1600, beds: 3, price: 420000, weight: 0.88 },
    { address: "nearby", sqft: 1400, beds: 2, price: 350000, weight: 0.71 },
    { address: "nearby", sqft: 1550, beds: 4, price: 410000, weight: 0.73 }
  ];

  let totalWeightedPrice = 0;
  let totalWeight = 0;

  console.log("\nWeighted Calculation:");
  exampleComps.forEach((comp, i) => {
    const pricePerSqft = Math.round(comp.price / comp.sqft);
    const weightedContribution = pricePerSqft * comp.weight;
    totalWeightedPrice += weightedContribution;
    totalWeight += comp.weight;

    console.log(`Comp ${i+1}: ${comp.sqft}sqft, ${comp.beds}bed, $${comp.price.toLocaleString()} = $${pricePerSqft}/sqft × ${comp.weight} weight`);
  });

  const finalPricePerSqft = Math.round(totalWeightedPrice / totalWeight);
  console.log(`\nFinal Weighted Price: $${finalPricePerSqft}/sqft`);
  console.log(`Subject's Future Value: ${exampleSubject.livingArea} × $${finalPricePerSqft} × 1.03 = $${Math.round(exampleSubject.livingArea * finalPricePerSqft * 1.03).toLocaleString()}`);

  console.log("\n🔧 KEY FEATURES:");
  console.log("━".repeat(50));
  console.log("✅ Location-based: Uses same ZIP code");
  console.log("✅ Quality filtered: Removes bad/invalid data");
  console.log("✅ Outlier resistant: Multiple statistical filters");
  console.log("✅ Similarity weighted: Emphasizes most similar properties");
  console.log("✅ Robust fallbacks: Handles edge cases gracefully");
  console.log("✅ Market realistic: Caps and ranges prevent wild estimates");

  console.log("\n⚠️  LIMITATIONS:");
  console.log("━".repeat(50));
  console.log("• ZIP code only (doesn't consider neighborhoods within ZIP)");
  console.log("• No sale date filtering (may include old sales)");
  console.log("• Depends on Redfin data availability");
  console.log("• May lack very recent sales (data lag)");
  console.log("• Doesn't account for property condition differences");
}

demonstrateCompsProcess();
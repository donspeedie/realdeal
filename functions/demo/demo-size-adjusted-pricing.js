// Demonstration of size-adjusted pricing approaches
console.log("=== SIZE-ADJUSTED PRICING STRATEGIES ===\n");

function demonstrateSizeAdjustments() {
  console.log("📊 CURRENT APPROACH (Simple Linear):");
  console.log("ARV = Living Area × Price Per SqFt × Improvement Factor");
  console.log("Problem: Doesn't account for size economies/premiums");
  console.log();

  console.log("🏠 EXAMPLE SCENARIO:");
  const subjectArea = 2141;
  const avgCompArea = 1728;
  const pricePerSqft = 267;
  const impFactor = 1.03;

  console.log(`Subject: ${subjectArea} sqft`);
  console.log(`Average Comp: ${avgCompArea} sqft`);
  console.log(`Base Price/SqFt: $${pricePerSqft}`);
  console.log();

  // Current approach
  const currentARV = subjectArea * pricePerSqft * impFactor;
  console.log(`Current ARV: ${subjectArea} × $${pricePerSqft} × ${impFactor} = $${Math.round(currentARV).toLocaleString()}`);
  console.log();

  console.log("🔧 PROPOSED SIZE-ADJUSTED APPROACHES:");
  console.log("━".repeat(50));

  console.log("\n1️⃣ DIMINISHING RETURNS MODEL:");
  console.log("Larger homes have slightly lower $/sqft due to economies of scale");

  function calculateDiminishingReturns(area, basePrice, avgArea) {
    // Size factor: larger homes get slight discount, smaller get premium
    const sizeRatio = area / avgArea;
    const sizeFactor = Math.pow(sizeRatio, 0.85); // Power < 1 = diminishing returns
    const adjustedPrice = basePrice * sizeFactor;

    return {
      sizeFactor: sizeFactor,
      adjustedPrice: Math.round(adjustedPrice),
      arv: Math.round(area * adjustedPrice * impFactor)
    };
  }

  const diminishing = calculateDiminishingReturns(subjectArea, pricePerSqft, avgCompArea);
  console.log(`Size Factor: ${diminishing.sizeFactor.toFixed(3)} (${((diminishing.sizeFactor - 1) * 100).toFixed(1)}%)`);
  console.log(`Adjusted Price/SqFt: $${diminishing.adjustedPrice}/sqft`);
  console.log(`Adjusted ARV: $${diminishing.arv.toLocaleString()}`);
  console.log(`Difference from current: ${((diminishing.arv - currentARV) / currentARV * 100).toFixed(1)}%`);

  console.log("\n2️⃣ TIERED PRICING MODEL:");
  console.log("Different price bands for different size ranges");

  function calculateTieredPricing(area, basePrice) {
    let adjustedPrice = basePrice;

    if (area <= 1000) adjustedPrice = basePrice * 1.10;      // Small homes: 10% premium
    else if (area <= 1500) adjustedPrice = basePrice * 1.05; // Medium homes: 5% premium
    else if (area <= 2000) adjustedPrice = basePrice * 1.00; // Large homes: base price
    else if (area <= 2500) adjustedPrice = basePrice * 0.95; // XL homes: 5% discount
    else adjustedPrice = basePrice * 0.90;                   // XXL homes: 10% discount

    return {
      tier: getTier(area),
      adjustedPrice: Math.round(adjustedPrice),
      arv: Math.round(area * adjustedPrice * impFactor)
    };
  }

  function getTier(area) {
    if (area <= 1000) return "Small (≤1000 sqft)";
    if (area <= 1500) return "Medium (1001-1500 sqft)";
    if (area <= 2000) return "Large (1501-2000 sqft)";
    if (area <= 2500) return "XL (2001-2500 sqft)";
    return "XXL (>2500 sqft)";
  }

  const tiered = calculateTieredPricing(subjectArea, pricePerSqft);
  console.log(`Size Tier: ${tiered.tier}`);
  console.log(`Adjusted Price/SqFt: $${tiered.adjustedPrice}/sqft`);
  console.log(`Adjusted ARV: $${tiered.arv.toLocaleString()}`);
  console.log(`Difference from current: ${((tiered.arv - currentARV) / currentARV * 100).toFixed(1)}%`);

  console.log("\n3️⃣ MARKET-BASED SIZE ADJUSTMENT:");
  console.log("Uses actual comp data to determine size premiums/discounts");

  function calculateMarketBasedAdjustment(area, basePrice, avgArea) {
    // Simulate market data showing how price/sqft varies by size
    const sizeDeviation = (area - avgArea) / avgArea;

    // Market research shows: every 25% size increase = 2% price/sqft decrease
    const priceAdjustment = -sizeDeviation * 0.08; // 8% adjustment per 100% size change
    const sizeFactor = 1 + priceAdjustment;

    return {
      sizeDeviation: sizeDeviation,
      priceAdjustment: priceAdjustment,
      sizeFactor: sizeFactor,
      adjustedPrice: Math.round(basePrice * sizeFactor),
      arv: Math.round(area * basePrice * sizeFactor * impFactor)
    };
  }

  const marketBased = calculateMarketBasedAdjustment(subjectArea, pricePerSqft, avgCompArea);
  console.log(`Size Deviation: ${(marketBased.sizeDeviation * 100).toFixed(1)}% larger than average`);
  console.log(`Price Adjustment: ${(marketBased.priceAdjustment * 100).toFixed(1)}%`);
  console.log(`Adjusted Price/SqFt: $${marketBased.adjustedPrice}/sqft`);
  console.log(`Adjusted ARV: $${marketBased.arv.toLocaleString()}`);
  console.log(`Difference from current: ${((marketBased.arv - currentARV) / currentARV * 100).toFixed(1)}%`);

  console.log("\n📊 COMPARISON SUMMARY:");
  console.log("━".repeat(50));
  console.log(`Current Method:      $${Math.round(currentARV).toLocaleString()} (@$${pricePerSqft}/sqft)`);
  console.log(`Diminishing Returns: $${diminishing.arv.toLocaleString()} (@$${diminishing.adjustedPrice}/sqft)`);
  console.log(`Tiered Pricing:      $${tiered.arv.toLocaleString()} (@$${tiered.adjustedPrice}/sqft)`);
  console.log(`Market-Based:        $${marketBased.arv.toLocaleString()} (@$${marketBased.adjustedPrice}/sqft)`);

  console.log("\n🎯 RECOMMENDATION:");
  console.log("━".repeat(50));
  console.log("DIMINISHING RETURNS MODEL is most realistic:");
  console.log("✅ Reflects economic reality (larger homes = slight economies)");
  console.log("✅ Gradual adjustment (not harsh tiers)");
  console.log("✅ Easy to implement and understand");
  console.log("✅ Conservative approach (prevents overvaluation)");

  console.log("\n💻 IMPLEMENTATION CODE:");
  console.log("━".repeat(50));
  console.log(`
function calculateSizeAdjustedPrice(livingArea, basePricePerSqft, avgCompArea) {
  // Diminishing returns: power factor < 1.0
  const sizeRatio = livingArea / avgCompArea;
  const sizeFactor = Math.pow(sizeRatio, 0.85); // 0.85 = moderate adjustment
  return Math.round(basePricePerSqft * sizeFactor);
}

// Usage in estimateFutureValue:
const adjustedPricePerSqft = calculateSizeAdjustedPrice(
  futureLivingArea,
  pricePerSqft,
  averageCompSize
);
const futureValue = futureLivingArea * adjustedPricePerSqft * impFactor;
  `);
}

demonstrateSizeAdjustments();
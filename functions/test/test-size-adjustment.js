// Test the new size adjustment implementation
const {calculateStrategy} = require("./strategyCalculator");

console.log("=== TESTING SIZE ADJUSTMENT IMPLEMENTATION ===\n");

async function testSizeAdjustment() {
  console.log("🧪 TEST SCENARIO: Sacramento Property from Screenshot");
  console.log("Expected behavior: Larger properties get slightly lower $/sqft");
  console.log();

  // Test property similar to the screenshot
  const testProperty = {
    zpid: "test_size_adj",
    price: 450000,
    livingArea: 2141, // Large property that caused the issue
    bedrooms: 4,
    bathrooms: 3
  };

  // Mock some comparable properties of varying sizes
  const mockComps = [
    { price: 400000, sqft: 1600, beds: 3 }, // Smaller
    { price: 420000, sqft: 1700, beds: 3 }, // Smaller
    { price: 440000, sqft: 1800, beds: 3 }, // Average
    { price: 460000, sqft: 1750, beds: 4 }, // Average
    { price: 480000, sqft: 1900, beds: 4 }  // Closer to subject
  ];

  const avgCompSize = mockComps.reduce((sum, c) => sum + c.sqft, 0) / mockComps.length;
  const basePrice = mockComps.reduce((sum, c) => sum + c.price, 0) / mockComps.length;
  const basePricePerSqft = Math.round(basePrice / avgCompSize);

  console.log("📊 MOCK DATA:");
  console.log(`Subject Property: ${testProperty.livingArea} sqft`);
  console.log(`Average Comp Size: ${Math.round(avgCompSize)} sqft`);
  console.log(`Size Difference: ${((testProperty.livingArea - avgCompSize) / avgCompSize * 100).toFixed(1)}% larger`);
  console.log(`Base Price/SqFt: $${basePricePerSqft}/sqft`);
  console.log();

  // Test the calculation with our new size adjustment
  const testParams = {
    interestRate: 0.06,
    salRate: 0.04,
    permitsFees: 1000,
    fixFlipDuration: 3,
    bypassMinReturn: true,
    // Don't override future value to see the calculated result
  };

  console.log("🔧 TESTING SIZE ADJUSTMENT CALCULATION:");

  // Calculate expected adjustment manually
  const sizeDeviation = (testProperty.livingArea - avgCompSize) / avgCompSize;
  const expectedPriceAdjustment = -sizeDeviation * 0.08;
  const cappedAdjustment = Math.max(-0.15, Math.min(0.15, expectedPriceAdjustment));
  const expectedAdjustedPrice = Math.round(basePricePerSqft * (1 + cappedAdjustment));
  const expectedARV = Math.round(testProperty.livingArea * expectedAdjustedPrice * 1.03);

  console.log(`Manual Calculation:`);
  console.log(`  Size Deviation: ${(sizeDeviation * 100).toFixed(1)}%`);
  console.log(`  Price Adjustment: ${(expectedPriceAdjustment * 100).toFixed(1)}% → ${(cappedAdjustment * 100).toFixed(1)}% (capped)`);
  console.log(`  Adjusted Price/SqFt: $${expectedAdjustedPrice}/sqft`);
  console.log(`  Expected ARV: ${testProperty.livingArea} × $${expectedAdjustedPrice} × 1.03 = $${expectedARV.toLocaleString()}`);
  console.log();

  try {
    const result = calculateStrategy("Fix & Flip", testProperty, testParams, basePricePerSqft, 0, mockComps);

    if (result) {
      console.log("✅ CALCULATION RESULTS:");
      console.log(`Future Value: $${result.futureValue?.toLocaleString()}`);
      console.log(`Future Area: ${result.futureLivingArea} sqft`);
      console.log(`Avg Dollar Per SqFt: $${result.avgDollarPerSqft}/sqft`);

      console.log("\n📈 COMPARISON:");

      // Calculate what old method would have produced
      const oldMethodARV = Math.round(testProperty.livingArea * basePricePerSqft * 1.03);
      console.log(`Old Method (Linear): $${oldMethodARV.toLocaleString()}`);
      console.log(`New Method (Size-Adjusted): $${result.futureValue?.toLocaleString()}`);

      const difference = result.futureValue - oldMethodARV;
      const percentDiff = (difference / oldMethodARV * 100);

      console.log(`Difference: $${difference.toLocaleString()} (${percentDiff.toFixed(1)}%)`);

      if (percentDiff < 0) {
        console.log("✅ SUCCESS: Larger property gets lower valuation (more realistic)");
      } else {
        console.log("⚠️  Unexpected: Larger property got higher valuation");
      }

    } else {
      console.log("❌ Calculation returned null (may not meet minimum requirements)");
    }

  } catch (error) {
    console.error("❌ Error during calculation:", error.message);
  }

  console.log("\n🎯 EXPECTED IMPACT ON ORIGINAL ISSUE:");
  console.log("━".repeat(50));
  console.log("Original Issue: ARV $588,821 vs Avg Comp $461,245");
  console.log("Root Cause: 2,141 sqft subject vs ~1,728 sqft avg comp");
  console.log();
  console.log("With Size Adjustment:");
  console.log("• Larger homes get lower $/sqft (economies of scale)");
  console.log("• Reduces gap between ARV and comp averages");
  console.log("• More realistic valuations for varying property sizes");
  console.log("• Prevents overvaluation of large properties");
}

testSizeAdjustment().catch(console.error);
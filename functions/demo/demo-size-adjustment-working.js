// Demo of the size adjustment working with proper comp data
const {calculateStrategy} = require("./strategyCalculator");

console.log("=== SIZE ADJUSTMENT WORKING DEMO ===\n");

async function demoSizeAdjustment() {
  console.log("🎯 SIMULATING REAL SCENARIO:");
  console.log("Large property (2,141 sqft) vs smaller average comps (1,728 sqft)");
  console.log();

  // Test property from the original issue
  const testProperty = {
    zpid: "demo_size",
    price: 499000,
    livingArea: 2141,
    bedrooms: 5,
    bathrooms: 3
  };

  // Create mock comparable data that matches the real structure
  const mockFilteredComps = [
    {
      price: { value: 420000 },
      sqFt: { value: 1600 },
      beds: 3
    },
    {
      price: { value: 450000 },
      sqFt: { value: 1700 },
      beds: 3
    },
    {
      price: { value: 480000 },
      sqFt: { value: 1800 },
      beds: 4
    },
    {
      price: { value: 510000 },
      sqFt: { value: 1750 },
      beds: 4
    },
    {
      price: { value: 490000 },
      sqFt: { value: 1820 },
      beds: 4
    }
  ];

  const avgCompSize = mockFilteredComps.reduce((sum, c) => sum + c.sqFt.value, 0) / mockFilteredComps.length;
  const avgCompPrice = mockFilteredComps.reduce((sum, c) => sum + c.price.value, 0) / mockFilteredComps.length;

  console.log("📊 MOCK COMPARABLE DATA:");
  console.log(`Number of Comps: ${mockFilteredComps.length}`);
  console.log(`Average Comp Size: ${Math.round(avgCompSize)} sqft`);
  console.log(`Average Comp Price: $${Math.round(avgCompPrice).toLocaleString()}`);
  console.log(`Subject Property: ${testProperty.livingArea} sqft`);
  console.log(`Size Difference: ${((testProperty.livingArea - avgCompSize) / avgCompSize * 100).toFixed(1)}% larger`);
  console.log();

  // Calculate expected price per sqft
  const basePricePerSqft = Math.round(avgCompPrice / avgCompSize);
  console.log(`Base Price Per SqFt: $${basePricePerSqft}/sqft`);

  // Test parameters with proper filtered comps
  const testParams = {
    interestRate: 0.06,
    salRate: 0.04,
    permitsFees: 1000,
    fixFlipDuration: 3,
    filteredComps: mockFilteredComps,  // This is key!
    bypassMinReturn: true
  };

  console.log("\n🔧 RUNNING SIZE ADJUSTMENT CALCULATION:");

  try {
    const result = calculateStrategy("Fix & Flip", testProperty, testParams, basePricePerSqft, 0, []);

    if (result) {
      console.log("\n✅ RESULTS:");
      console.log(`Future Value: $${result.futureValue?.toLocaleString()}`);
      console.log(`Avg Dollar Per SqFt: $${result.avgDollarPerSqft}/sqft`);

      // Calculate what it would have been without size adjustment
      const withoutAdjustment = Math.round(testProperty.livingArea * basePricePerSqft * 1.03);
      console.log(`\n📈 IMPACT OF SIZE ADJUSTMENT:`);
      console.log(`Without Size Adjustment: $${withoutAdjustment.toLocaleString()}`);
      console.log(`With Size Adjustment: $${result.futureValue?.toLocaleString()}`);

      const difference = result.futureValue - withoutAdjustment;
      const percentDiff = (difference / withoutAdjustment * 100);

      console.log(`Difference: $${difference.toLocaleString()} (${percentDiff.toFixed(1)}%)`);

      if (percentDiff < 0) {
        console.log("✅ SUCCESS: Size adjustment reduced valuation for larger property");
      } else if (percentDiff === 0) {
        console.log("⚠️ No adjustment applied (check comp data structure)");
      } else {
        console.log("⚠️ Unexpected increase in valuation");
      }

      console.log("\n💡 SOLUTION TO ORIGINAL ISSUE:");
      console.log("━".repeat(50));
      console.log("Before: ARV higher than comp average due to linear scaling");
      console.log("After: ARV considers size economies, more balanced valuation");
      console.log("Result: Better balance between size and price per sqft");

    } else {
      console.log("❌ Strategy returned null");
    }

  } catch (error) {
    console.error("❌ Error:", error.message);
  }
}

demoSizeAdjustment().catch(console.error);
// Test the avgDollarPerSqft (future cost per sqft) calculation
const {calculateStrategy} = require("./strategyCalculator");

console.log("=== FUTURE COST PER SQUARE FOOT ANALYSIS ===\n");

// Test with Sacramento property from Screenshot #3
const testProperty = {
  zpid: "test_future_sf",
  price: 499000,
  livingArea: 1522,
  bedrooms: 5,
  bathrooms: 3,
  impValue: 56250,
  loanPayments: 7095,
  loanFees: 14193,
  sellingCosts: 25232
};

const testParams = {
  interestRate: 0.06,
  salRate: 0.04,
  permitsFees: 1000,
  fixFlipDuration: 3,
  futureValue: 630788,
  bypassMinReturn: true
};

console.log("🏠 PROPERTY ANALYSIS:");
console.log(`Current Living Area: ${testProperty.livingArea.toLocaleString()} sqft`);
console.log(`Future Value: $${testParams.futureValue.toLocaleString()}`);

const result = calculateStrategy("Fix & Flip", testProperty, testParams, 269, 0, []);

if (result) {
  console.log("\n📊 RESULTS:");
  console.log(`Future Living Area: ${result.futureLivingArea?.toLocaleString()} sqft`);
  console.log(`Future Value: $${result.futureValue?.toLocaleString()}`);
  console.log(`Future Cost Per SqFt: $${result.avgDollarPerSqft?.toLocaleString()}/sqft`);

  // Manual verification
  const manualAvgDollarPerSqft = result.futureLivingArea > 0 ?
    Math.round(result.futureValue / result.futureLivingArea) : 0;

  console.log("\n🔍 MANUAL VERIFICATION:");
  console.log(`Manual Calculation: $${result.futureValue?.toLocaleString()} ÷ ${result.futureLivingArea?.toLocaleString()} = $${manualAvgDollarPerSqft}/sqft`);
  console.log(`System Calculation: $${result.avgDollarPerSqft}/sqft`);
  console.log(`Match: ${result.avgDollarPerSqft === manualAvgDollarPerSqft ? 'YES ✅' : 'NO ❌'}`);

  console.log("\n📈 COMPARISON TO MARKET:");
  const currentMarketPrice = 269; // From screenshot - market price per sqft
  const futureVsMarket = result.avgDollarPerSqft - currentMarketPrice;
  const percentIncrease = ((result.avgDollarPerSqft / currentMarketPrice) - 1) * 100;

  console.log(`Market Price/SqFt: $${currentMarketPrice}/sqft`);
  console.log(`Future Price/SqFt: $${result.avgDollarPerSqft}/sqft`);
  console.log(`Improvement Premium: $${futureVsMarket}/sqft (${percentIncrease.toFixed(1)}% increase)`);

  console.log("\n💡 INTERPRETATION:");
  if (percentIncrease > 10) {
    console.log("✅ Strong value improvement expected");
  } else if (percentIncrease > 5) {
    console.log("✅ Moderate value improvement expected");
  } else if (percentIncrease > 0) {
    console.log("⚠️  Minimal value improvement expected");
  } else {
    console.log("❌ No value improvement expected");
  }

} else {
  console.log("❌ Calculation failed");
}

console.log("\n" + "=".repeat(60));

console.log("\n🏗️ STRATEGY COMPARISON - Future Cost Per SqFt:");

// Test different strategies to show how future area affects cost per sqft
const strategies = ["Fix & Flip", "Add-On", "New Build"];
const baseParams = {
  ...testParams,
  addOnDuration: 6,
  newBuildDuration: 12,
  bypassMinReturn: true
};

strategies.forEach(strategy => {
  console.log(`\n${strategy}:`);
  const strategyResult = calculateStrategy(strategy, testProperty, baseParams, 269, 0, []);

  if (strategyResult) {
    console.log(`  Future Area: ${strategyResult.futureLivingArea?.toLocaleString()} sqft`);
    console.log(`  Future Value: $${strategyResult.futureValue?.toLocaleString()}`);
    console.log(`  Future Cost/SqFt: $${strategyResult.avgDollarPerSqft}/sqft`);

    // Show the impact of area changes
    if (strategy === "Fix & Flip") {
      console.log(`  Area Change: No change (renovation only)`);
    } else {
      const areaChange = strategyResult.futureLivingArea - testProperty.livingArea;
      console.log(`  Area Change: +${areaChange} sqft`);
    }
  } else {
    console.log(`  ❌ Strategy not viable`);
  }
});

console.log("\n📝 SUMMARY:");
console.log("• avgDollarPerSqft = futureValue ÷ futureLivingArea");
console.log("• Shows the projected value per square foot after improvements");
console.log("• Useful for comparing renovation efficiency across strategies");
console.log("• Higher $/sqft indicates better value creation per square foot");
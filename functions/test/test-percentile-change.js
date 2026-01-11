// Test the impact of changing from 10th-90th percentile to 10th-80th percentile filtering
console.log("=== PERCENTILE FILTER CHANGE IMPACT ===\n");

function demonstratePercentileChange() {
  console.log("🔄 CHANGE IMPLEMENTED:");
  console.log("OLD: Kept 10th-90th percentile (middle 80%)");
  console.log("NEW: Keeps 10th-80th percentile (middle 70%)");
  console.log("EFFECT: More aggressive filtering of high-end outliers\n");

  // Example comp data with price per sqft
  const exampleComps = [
    180, 220, 245, 260, 265, 270, 275, 280, 285, 290,  // Low to normal range
    295, 300, 310, 315, 320, 325, 330, 335, 340, 350,  // Normal to high-normal
    380, 420, 450, 480, 520, 650, 750, 890, 950, 1200  // High-end and outliers
  ];

  console.log("📊 EXAMPLE COMPARABLE SALES DATA:");
  console.log(`Raw comp prices per sqft: [${exampleComps.slice(0, 10).join(', ')}, ..., ${exampleComps.slice(-5).join(', ')}]`);
  console.log(`Total comps: ${exampleComps.length}`);
  console.log();

  // Calculate percentiles
  const sorted = [...exampleComps].sort((a, b) => a - b);

  function calculatePercentile(arr, p) {
    const index = (p / 100) * (arr.length - 1);
    if (Math.floor(index) === index) {
      return arr[index];
    } else {
      const lower = Math.floor(index);
      const upper = Math.ceil(index);
      const weight = index - lower;
      return arr[lower] * (1 - weight) + arr[upper] * weight;
    }
  }

  const p10 = calculatePercentile(sorted, 10);
  const p80 = calculatePercentile(sorted, 80);
  const p90 = calculatePercentile(sorted, 90);

  console.log("🎯 PERCENTILE VALUES:");
  console.log(`10th percentile: $${p10}/sqft`);
  console.log(`80th percentile: $${p80}/sqft`);
  console.log(`90th percentile: $${p90}/sqft`);
  console.log();

  // Filter using old method (10th-90th)
  const oldMethod = exampleComps.filter(price => price >= p10 && price <= p90);

  // Filter using new method (10th-80th)
  const newMethod = exampleComps.filter(price => price >= p10 && price <= p80);

  console.log("📈 FILTERING RESULTS:");
  console.log(`OLD METHOD (10th-90th): Kept ${oldMethod.length} comps out of ${exampleComps.length}`);
  console.log(`  Range: $${Math.min(...oldMethod)}-$${Math.max(...oldMethod)}/sqft`);
  console.log(`  Average: $${Math.round(oldMethod.reduce((a, b) => a + b) / oldMethod.length)}/sqft`);
  console.log();

  console.log(`NEW METHOD (10th-80th): Kept ${newMethod.length} comps out of ${exampleComps.length}`);
  console.log(`  Range: $${Math.min(...newMethod)}-$${Math.max(...newMethod)}/sqft`);
  console.log(`  Average: $${Math.round(newMethod.reduce((a, b) => a + b) / newMethod.length)}/sqft`);
  console.log();

  // Show what gets excluded
  const excludedByOld = exampleComps.filter(price => price < p10 || price > p90);
  const excludedByNew = exampleComps.filter(price => price < p10 || price > p80);
  const additionallyExcluded = excludedByNew.filter(price => !excludedByOld.includes(price));

  console.log("❌ EXCLUDED COMPS:");
  console.log(`Old method excluded: [${excludedByOld.join(', ')}]`);
  console.log(`New method excludes: [${excludedByNew.join(', ')}]`);
  console.log(`Additionally excluded by new method: [${additionallyExcluded.join(', ')}]`);
  console.log();

  // Calculate impact on average
  const oldAvg = oldMethod.reduce((a, b) => a + b) / oldMethod.length;
  const newAvg = newMethod.reduce((a, b) => a + b) / newMethod.length;
  const avgDifference = newAvg - oldAvg;
  const percentDifference = ((newAvg / oldAvg) - 1) * 100;

  console.log("💰 IMPACT ON PRICING:");
  console.log(`Average price change: $${avgDifference.toFixed(0)}/sqft (${percentDifference.toFixed(1)}%)`);

  if (avgDifference < 0) {
    console.log("✅ Result: MORE CONSERVATIVE pricing (lower average)");
  } else {
    console.log("⚠️  Result: HIGHER pricing (higher average)");
  }
  console.log();

  console.log("🎯 BUSINESS IMPACT:");
  console.log("✅ More conservative valuations by excluding high-end outliers");
  console.log("✅ Better protection against overvaluation");
  console.log("✅ More consistent with typical market conditions");
  console.log("⚠️  May undervalue in hot/luxury markets");
  console.log("⚠️  Smaller sample size for calculations");
  console.log();

  console.log("📊 RECOMMENDED USE CASES:");
  console.log("• Standard residential markets");
  console.log("• Conservative investment analysis");
  console.log("• Markets with significant luxury segment");
  console.log("• When data quality is questionable");
}

demonstratePercentileChange();
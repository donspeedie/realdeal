// Comprehensive explanation of the Modified Z-Score Test used in comps analysis
console.log("=== MODIFIED Z-SCORE TEST EXPLAINED ===\n");

function explainModifiedZScore() {
  console.log("🧮 WHAT IS THE MODIFIED Z-SCORE TEST?");
  console.log("━".repeat(50));
  console.log("The Modified Z-Score test is a statistical method for detecting outliers");
  console.log("that is MORE ROBUST than the traditional Z-Score because it uses:");
  console.log("• MEDIAN instead of MEAN (less affected by outliers)");
  console.log("• MAD instead of Standard Deviation (more resistant to extreme values)");
  console.log();

  console.log("📊 TRADITIONAL Z-SCORE vs MODIFIED Z-SCORE");
  console.log("━".repeat(50));
  console.log("Traditional Z-Score:");
  console.log("  Z = (value - mean) / standard_deviation");
  console.log("  ❌ Problem: Mean and StdDev are skewed by outliers");
  console.log();
  console.log("Modified Z-Score:");
  console.log("  Modified Z = 0.6745 × (value - median) / MAD");
  console.log("  ✅ Benefit: Median and MAD are outlier-resistant");
  console.log();

  console.log("🔢 STEP-BY-STEP CALCULATION");
  console.log("━".repeat(50));

  // Example dataset of price per sqft from comps
  const pricesPerSqft = [180, 250, 265, 270, 275, 280, 285, 290, 295, 650]; // 650 is clearly an outlier
  console.log("Example Comp Prices per SqFt:");
  console.log(`[${pricesPerSqft.join(', ')}]`);
  console.log("Note: $650/sqft is suspiciously high - likely an outlier");
  console.log();

  console.log("STEP 1: Calculate MEDIAN");
  console.log("━".repeat(20));
  const sortedPrices = [...pricesPerSqft].sort((a, b) => a - b);
  console.log(`Sorted: [${sortedPrices.join(', ')}]`);

  const n = sortedPrices.length;
  let median;
  if (n % 2 === 0) {
    median = (sortedPrices[n/2 - 1] + sortedPrices[n/2]) / 2;
    console.log(`Even count (${n}): median = (${sortedPrices[n/2 - 1]} + ${sortedPrices[n/2]}) / 2 = ${median}`);
  } else {
    median = sortedPrices[Math.floor(n/2)];
    console.log(`Odd count (${n}): median = ${median}`);
  }
  console.log();

  console.log("STEP 2: Calculate ABSOLUTE DEVIATIONS from median");
  console.log("━".repeat(20));
  const deviations = pricesPerSqft.map(price => Math.abs(price - median));
  console.log("For each price, calculate |price - median|:");
  pricesPerSqft.forEach((price, i) => {
    console.log(`  $${price}: |${price} - ${median}| = ${deviations[i]}`);
  });
  console.log();

  console.log("STEP 3: Calculate MAD (Median Absolute Deviation)");
  console.log("━".repeat(20));
  const sortedDeviations = [...deviations].sort((a, b) => a - b);
  console.log(`Sorted deviations: [${sortedDeviations.join(', ')}]`);

  let mad;
  if (sortedDeviations.length % 2 === 0) {
    mad = (sortedDeviations[sortedDeviations.length/2 - 1] + sortedDeviations[sortedDeviations.length/2]) / 2;
  } else {
    mad = sortedDeviations[Math.floor(sortedDeviations.length/2)];
  }
  console.log(`MAD = ${mad}`);
  console.log();

  console.log("STEP 4: Calculate MODIFIED Z-SCORE for each value");
  console.log("━".repeat(20));
  console.log("Formula: Modified Z = 0.6745 × (value - median) / MAD");
  console.log("The constant 0.6745 makes the Modified Z-Score comparable to traditional Z-Score");
  console.log();

  const modifiedZScores = pricesPerSqft.map(price => {
    if (mad === 0) return 0; // Avoid division by zero
    return 0.6745 * (price - median) / mad;
  });

  console.log("Modified Z-Scores:");
  pricesPerSqft.forEach((price, i) => {
    const zScore = modifiedZScores[i];
    const isOutlier = Math.abs(zScore) > 3.5;
    const status = isOutlier ? "🚨 OUTLIER" : "✅ Normal";
    console.log(`  $${price}: Z = 0.6745 × (${price} - ${median}) / ${mad} = ${zScore.toFixed(2)} ${status}`);
  });
  console.log();

  console.log("STEP 5: APPLY THRESHOLD (3.5)");
  console.log("━".repeat(20));
  console.log("Standard threshold for Modified Z-Score: |Z| > 3.5 = outlier");
  console.log("This is equivalent to ~3 standard deviations in normal distribution");
  console.log();

  const filteredPrices = pricesPerSqft.filter((price, i) => Math.abs(modifiedZScores[i]) <= 3.5);
  const removedPrices = pricesPerSqft.filter((price, i) => Math.abs(modifiedZScores[i]) > 3.5);

  console.log("RESULTS:");
  console.log(`✅ Kept: [${filteredPrices.join(', ')}] (${filteredPrices.length} comps)`);
  console.log(`🚨 Removed: [${removedPrices.join(', ')}] (${removedPrices.length} outliers)`);
  console.log();

  console.log("🎯 WHY USE 0.6745 CONSTANT?");
  console.log("━".repeat(50));
  console.log("The constant 0.6745 is the 75th percentile of the standard normal distribution.");
  console.log("It makes Modified Z-Scores directly comparable to traditional Z-Scores:");
  console.log("• Modified Z-Score of ±3.5 ≈ Traditional Z-Score of ±3.5");
  console.log("• Both represent approximately the same level of 'unusualness'");
  console.log("• Maintains familiar interpretation of Z-Score thresholds");
  console.log();

  console.log("📈 COMPARISON: MEAN vs MEDIAN APPROACH");
  console.log("━".repeat(50));

  const mean = pricesPerSqft.reduce((sum, p) => sum + p, 0) / pricesPerSqft.length;
  const variance = pricesPerSqft.reduce((sum, p) => sum + Math.pow(p - mean, 2), 0) / pricesPerSqft.length;
  const stdDev = Math.sqrt(variance);

  console.log("Traditional approach (affected by outlier):");
  console.log(`  Mean: $${mean.toFixed(0)}/sqft (skewed by $650 outlier)`);
  console.log(`  Std Dev: ${stdDev.toFixed(0)} (inflated by outlier)`);
  console.log();
  console.log("Modified approach (resistant to outliers):");
  console.log(`  Median: $${median}/sqft (not skewed by outlier)`);
  console.log(`  MAD: ${mad} (not inflated by outlier)`);
  console.log();

  console.log("🏠 REAL ESTATE APPLICATION");
  console.log("━".repeat(50));
  console.log("In real estate comps analysis, outliers commonly occur due to:");
  console.log("• Data entry errors (wrong price or sqft)");
  console.log("• Unique properties (luxury upgrades, poor condition)");
  console.log("• Different property types mixed in (condos vs houses)");
  console.log("• Market anomalies (distressed sales, family sales)");
  console.log();
  console.log("The Modified Z-Score helps identify these automatically without");
  console.log("manual review of every comp, ensuring reliable market valuations.");
  console.log();

  console.log("⚙️ OUR IMPLEMENTATION");
  console.log("━".repeat(50));
  console.log("In our code (propertyProcessor.js lines 96-97):");
  console.log('const modifiedZScore = mad > 0 ? Math.abs(0.6745 * (pricePerSqft - median) / mad) : 0;');
  console.log('const passesZScore = modifiedZScore < 3.5;');
  console.log();
  console.log("This runs automatically on every comp to filter out statistical outliers");
  console.log("before calculating the final weighted average price per square foot.");
}

explainModifiedZScore();
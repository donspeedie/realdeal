// Analyze why ARV might be higher than average comp price
console.log("=== ANALYZING ARV vs COMP PRICE DISCREPANCY ===\n");

function analyzeARVDiscrepancy() {
  console.log("📊 FROM SCREENSHOT:");
  console.log("After Repair Value (ARV): $588,821");
  console.log("Average $/Comp: $461,245");
  console.log("Discrepancy: $127,576 (27.7% higher)");
  console.log();

  console.log("🔍 POSSIBLE CAUSES OF HIGHER ARV:");
  console.log("━".repeat(50));

  console.log("\n1️⃣ IMPROVEMENT FACTOR APPLIED:");
  console.log("• Fix & Flip uses 1.03 improvement factor (3% premium)");
  console.log("• Formula: ARV = Living Area × Price Per SqFt × 1.03");
  console.log("• This adds a renovation premium above raw comps");

  console.log("\n2️⃣ PRICE PER SQFT vs TOTAL PRICE:");
  console.log("• ARV uses: Price Per SqFt × Subject Property Size");
  console.log("• Comps average: Total comp prices (different sizes)");
  console.log("• If subject is LARGER than average comp, ARV will be higher");

  console.log("\n3️⃣ WEIGHTED CALCULATION:");
  console.log("• Price per sqft is weighted by similarity to subject");
  console.log("• Most similar comps get higher weight");
  console.log("• May result in higher $/sqft than simple comp average");

  console.log("\n4️⃣ OVERRIDE VALUES:");
  console.log("• Future value can be manually overridden");
  console.log("• Check if custom ARV value was provided");

  console.log("\n📐 REVERSE ENGINEERING THE CALCULATION:");
  console.log("━".repeat(50));

  // From screenshot data
  const arv = 588821;
  const avgCompPrice = 461245;
  const pricePerSqft = 267; // From $/SF in screenshot
  const impFactor = 1.03;

  console.log(`Price Per SqFt from screenshot: $${pricePerSqft}/sqft`);
  console.log(`Improvement Factor: ${impFactor}`);

  // Calculate implied living area
  const impliedLivingArea = arv / (pricePerSqft * impFactor);
  console.log(`Implied Living Area: ${arv} ÷ (${pricePerSqft} × ${impFactor}) = ${Math.round(impliedLivingArea)} sqft`);

  // Calculate what average comp size would be
  const avgCompSize = avgCompPrice / pricePerSqft;
  console.log(`Average Comp Size: ${avgCompPrice} ÷ ${pricePerSqft} = ${Math.round(avgCompSize)} sqft`);

  const sizeDifference = impliedLivingArea - avgCompSize;
  console.log(`Size Difference: ${Math.round(sizeDifference)} sqft (${(sizeDifference/avgCompSize*100).toFixed(1)}% larger)`);

  console.log("\n💡 LIKELY EXPLANATION:");
  console.log("━".repeat(50));

  if (sizeDifference > 0) {
    console.log("✅ SUBJECT PROPERTY IS LARGER than average comp");
    console.log(`• Subject: ~${Math.round(impliedLivingArea)} sqft`);
    console.log(`• Avg Comp: ~${Math.round(avgCompSize)} sqft`);
    console.log(`• Size premium: ${Math.round(sizeDifference)} sqft × $${pricePerSqft}/sqft = $${Math.round(sizeDifference * pricePerSqft)}`);
    console.log(`• Improvement factor: ${((impFactor - 1) * 100).toFixed(0)}% = $${Math.round(arv * (impFactor - 1) / impFactor)}`);
  }

  console.log("\n🔍 HOW TO VERIFY:");
  console.log("━".repeat(50));
  console.log("1. Check subject property living area");
  console.log("2. Compare to average comp living area");
  console.log("3. Verify if custom future value override was used");
  console.log("4. Check weighted price/sqft calculation");

  console.log("\n📊 EXPECTED RELATIONSHIPS:");
  console.log("━".repeat(50));
  console.log("• If subject > avg comp size → ARV > avg comp price ✅");
  console.log("• If subject = avg comp size → ARV ≈ avg comp price × 1.03");
  console.log("• If subject < avg comp size → ARV < avg comp price");

  console.log("\n⚠️  POTENTIAL ISSUES TO CHECK:");
  console.log("━".repeat(50));
  console.log("• Price/sqft calculation errors");
  console.log("• Manual override values being used");
  console.log("• Comp filtering removing relevant properties");
  console.log("• Subject property data errors (wrong living area)");
}

analyzeARVDiscrepancy();
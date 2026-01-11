// Explain how Add-On ARV (After Repair Value) is calculated
console.log("=== ADD-ON ARV CALCULATION EXPLAINED ===\n");

function explainAddOnARV() {
  console.log("🏠 ADD-ON STRATEGY OVERVIEW:");
  console.log("Add-On adds a bedroom (typically 120 sqft) to existing property");
  console.log("ARV = Current Property Value + Addition Value + Extra Value");
  console.log();

  console.log("🔢 ADD-ON ARV FORMULA:");
  console.log("━".repeat(50));
  console.log("1. Current Property Value = Existing Area × Market Price/SqFt × Improvement Factor");
  console.log("2. Addition Value = Addition Area × Avg Comp Price/SqFt × Improvement Factor");
  console.log("3. Extra Value = Bedroom premium (if applicable)");
  console.log("4. Total ARV = Current Value + Addition Value + Extra Value");
  console.log();

  console.log("⚙️ ADD-ON CONFIGURATION:");
  console.log("━".repeat(50));
  console.log("• Addition Area: 120 sqft (bedroom size)");
  console.log("• Improvement Factor: 1.0 (no renovation premium)");
  console.log("• Duration: 6 months (default)");
  console.log("• Extra Value: Usually $0, can be bedroom premium");
  console.log();

  console.log("📐 STEP-BY-STEP EXAMPLE:");
  console.log("━".repeat(50));

  // Example calculation
  const originalArea = 1500;
  const addOnArea = 120;
  const futureArea = originalArea + addOnArea;
  const marketPricePerSqft = 300;
  const avgCompPricePerSqft = 310; // Slightly higher from comps analysis
  const impFactor = 1.0;
  const extraValue = 0;

  console.log(`Original Property: ${originalArea} sqft`);
  console.log(`Addition Size: ${addOnArea} sqft`);
  console.log(`Future Total Area: ${futureArea} sqft`);
  console.log(`Market Price/SqFt: $${marketPricePerSqft}/sqft`);
  console.log(`Avg Comp Price/SqFt: $${avgCompPricePerSqft}/sqft`);
  console.log();

  // Calculate each component
  const currentValue = Math.round(originalArea * marketPricePerSqft * impFactor);
  const additionValue = Math.round(addOnArea * avgCompPricePerSqft * impFactor);
  const totalARV = currentValue + additionValue + extraValue;

  console.log("CALCULATION BREAKDOWN:");
  console.log(`Current Property Value:`);
  console.log(`  = ${originalArea} sqft × $${marketPricePerSqft}/sqft × ${impFactor}`);
  console.log(`  = $${currentValue.toLocaleString()}`);
  console.log();

  console.log(`Addition Value:`);
  console.log(`  = ${addOnArea} sqft × $${avgCompPricePerSqft}/sqft × ${impFactor}`);
  console.log(`  = $${additionValue.toLocaleString()}`);
  console.log();

  console.log(`Extra Value: $${extraValue.toLocaleString()}`);
  console.log();

  console.log(`TOTAL ADD-ON ARV:`);
  console.log(`  = $${currentValue.toLocaleString()} + $${additionValue.toLocaleString()} + $${extraValue.toLocaleString()}`);
  console.log(`  = $${totalARV.toLocaleString()}`);
  console.log();

  console.log("🔍 KEY DIFFERENCES FROM FIX & FLIP:");
  console.log("━".repeat(50));
  console.log("✅ Fix & Flip: Area × Price/SqFt × 1.03 (simple linear)");
  console.log("✅ Add-On: (Existing × Market Rate) + (Addition × Comp Rate)");
  console.log("✅ Add-On uses TWO different price rates:");
  console.log("   • Market rate for existing area");
  console.log("   • Average comp rate for addition area");
  console.log("✅ Add-On has NO renovation premium (1.0 factor)");
  console.log();

  console.log("📊 PRICE RATE SOURCES:");
  console.log("━".repeat(50));
  console.log("Market Price/SqFt:");
  console.log("  • Derived from quality-filtered comps");
  console.log("  • Weighted by similarity to subject");
  console.log("  • Used for existing property value");
  console.log();
  console.log("Avg Comp Price/SqFt:");
  console.log("  • Simple average of all valid comps");
  console.log("  • May be slightly different from weighted rate");
  console.log("  • Used specifically for addition value");
  console.log();

  console.log("💡 WHY THIS APPROACH?");
  console.log("━".repeat(50));
  console.log("✅ Recognizes existing property already has market value");
  console.log("✅ Addition gets separate valuation (may be different rate)");
  console.log("✅ No renovation premium (just adding space, not upgrading)");
  console.log("✅ More nuanced than simple linear calculation");
  console.log("✅ Can incorporate bedroom premium if market supports it");
  console.log();

  console.log("🎯 REALISTIC SCENARIO:");
  console.log("━".repeat(50));
  console.log("A 3BR/2BA house becomes 4BR/2BA with bedroom addition");
  console.log("ARV reflects both the original house value AND the addition value");
  console.log("Addition may have different $/sqft than existing house");
  console.log("Final value considers the complete upgraded property");
  console.log();

  console.log("📈 SIZE ADJUSTMENT IMPACT:");
  console.log("━".repeat(50));
  console.log("With the new size adjustment feature:");
  console.log("• Existing area gets size-adjusted rate");
  console.log("• Addition area also gets size-adjusted rate");
  console.log("• Total ARV is more balanced for property size");
  console.log("• Prevents overvaluation of large additions");
}

explainAddOnARV();
// Test ADU future value calculations to identify the high value issue

console.log("=== ADU FUTURE VALUE DEBUG ===\n");

function debugADUCalculations() {
  // Sacramento example property
  const testProperty = {
    zpid: "sacramento_adu_test",
    price: 450000,
    livingArea: 1800,
    bedrooms: 3,
    rentZestimate: 2800  // $2,800/month (causes high GRM)
  };

  console.log("🏠 TEST PROPERTY:");
  console.log(`Price: $${testProperty.price.toLocaleString()}`);
  console.log(`Size: ${testProperty.livingArea} sqft`);
  console.log(`Rent: $${testProperty.rentZestimate}/month`);
  console.log();

  // Step 1: Main House Value Calculation
  const pricePerSqft = 300;  // Typical Sacramento rate
  const mainHouseValue = testProperty.livingArea * Math.min(pricePerSqft, 500);
  console.log("🏡 MAIN HOUSE VALUE:");
  console.log(`${testProperty.livingArea} sqft × $${pricePerSqft}/sqft = $${mainHouseValue.toLocaleString()}`);
  console.log();

  // Step 2: ADU Rent Estimation
  console.log("🏠 ADU RENT ESTIMATION:");
  const rentPerSqft = testProperty.rentZestimate / testProperty.livingArea;
  const aduRent = Math.round(750 * rentPerSqft * 0.85); // 750 sqft × rent/sqft × 85% discount
  console.log(`Main house rent/sqft: $${rentPerSqft.toFixed(2)}/sqft`);
  console.log(`ADU rent estimate: 750 sqft × $${rentPerSqft.toFixed(2)} × 85% = $${aduRent}/month`);
  console.log();

  // Step 3: GRM Method (High Values)
  console.log("📊 GRM METHOD (PROBLEMATIC):");
  const grm = Math.round(testProperty.price / testProperty.rentZestimate);
  const grmValue = aduRent * grm;
  console.log(`Property GRM: $${testProperty.price.toLocaleString()} ÷ $${testProperty.rentZestimate} = ${grm}`);
  console.log(`ADU GRM Value: $${aduRent} × ${grm} = $${grmValue.toLocaleString()}`);
  console.log(`Status: ${grm > 35 ? '❌ TOO HIGH - REJECTED' : '✅ ACCEPTED'}`);
  console.log();

  // Step 4: Cap Rate Method (Current Fallback)
  console.log("📊 CAP RATE METHOD (CURRENT FALLBACK):");
  const annualRent = aduRent * 12;
  let capRate = 0.05; // 5% for this property value range
  if (testProperty.price >= 1500000) capRate = 0.04;
  else if (testProperty.price >= 1000000) capRate = 0.045;
  else if (testProperty.price >= 700000) capRate = 0.05;
  else if (testProperty.price >= 500000) capRate = 0.055;
  else capRate = 0.06;

  const capRateValue = Math.round(annualRent / capRate);
  console.log(`ADU annual rent: $${annualRent.toLocaleString()}`);
  console.log(`Market cap rate: ${(capRate * 100).toFixed(1)}%`);
  console.log(`ADU cap rate value: $${annualRent.toLocaleString()} ÷ ${(capRate * 100).toFixed(1)}% = $${capRateValue.toLocaleString()}`);
  console.log();

  // Step 5: Total Future Value
  console.log("💰 TOTAL FUTURE VALUE:");
  const totalCapRateValue = mainHouseValue + capRateValue;
  console.log(`Main house: $${mainHouseValue.toLocaleString()}`);
  console.log(`ADU income value: $${capRateValue.toLocaleString()}`);
  console.log(`Total: $${totalCapRateValue.toLocaleString()}`);
  console.log();

  // Step 6: Premium Method Comparison
  console.log("📊 PREMIUM METHOD (ALTERNATIVE):");
  let aduPremium = 0.30; // 30% for typical house size
  if (testProperty.livingArea >= 3000) aduPremium = 0.20;
  else if (testProperty.livingArea >= 2000) aduPremium = 0.25;
  else if (testProperty.livingArea >= 1500) aduPremium = 0.30;
  else aduPremium = 0.35;

  const premiumValue = Math.round(mainHouseValue * (1 + aduPremium));
  console.log(`ADU premium: ${(aduPremium * 100)}% for ${testProperty.livingArea} sqft house`);
  console.log(`Premium value: $${mainHouseValue.toLocaleString()} × ${(1 + aduPremium)} = $${premiumValue.toLocaleString()}`);
  console.log();

  console.log("🎯 PROBLEM ANALYSIS:");
  console.log("━".repeat(50));
  console.log(`Income Approach: $${totalCapRateValue.toLocaleString()}`);
  console.log(`Premium Approach: $${premiumValue.toLocaleString()}`);
  console.log(`Difference: $${(totalCapRateValue - premiumValue).toLocaleString()}`);
  console.log();
  console.log("❌ ISSUES IDENTIFIED:");
  console.log("1. Cap rate method treats ADU as full income property");
  console.log("2. Doesn't account for ADU being secondary unit");
  console.log("3. Annual rent ÷ cap rate creates unrealistic valuations");
  console.log("4. Should cap ADU value contribution");
}

debugADUCalculations();
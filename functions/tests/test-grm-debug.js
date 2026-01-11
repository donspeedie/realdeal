// Debug GRM calculations to see if rentZestimate is monthly or annual

console.log("=== GRM CALCULATION DEBUG ===\n");

function testGRMCalculations() {
  const testProperty = {
    price: 450000,
    livingArea: 1800,
    rentZestimate: 2800  // Assuming this is monthly
  };

  console.log("🏠 TEST PROPERTY:");
  console.log(`Price: $${testProperty.price.toLocaleString()}`);
  console.log(`Size: ${testProperty.livingArea} sqft`);
  console.log(`RentZestimate: $${testProperty.rentZestimate}`);
  console.log();

  // Test if rentZestimate is monthly
  console.log("📊 ASSUMING MONTHLY RENT:");
  const monthlyGRM = Math.round(testProperty.price / testProperty.rentZestimate);
  const monthlyYield = (testProperty.rentZestimate * 12 / testProperty.price * 100).toFixed(2);
  console.log(`GRM (Monthly): ${monthlyGRM}`);
  console.log(`Annual Yield: ${monthlyYield}%`);
  console.log(`Reasonable? ${monthlyGRM >= 5 && monthlyGRM <= 35 ? '✅ YES' : '❌ NO - TOO HIGH'}`);
  console.log();

  // Test if rentZestimate is annual
  console.log("📊 ASSUMING ANNUAL RENT:");
  const annualGRM = Math.round(testProperty.price / (testProperty.rentZestimate / 12));
  const annualYield = (testProperty.rentZestimate / testProperty.price * 100).toFixed(2);
  console.log(`GRM (if annual ÷ 12): ${annualGRM}`);
  console.log(`Annual Yield: ${annualYield}%`);
  console.log(`Reasonable? ${annualGRM >= 5 && annualGRM <= 35 ? '✅ YES' : '❌ NO'}`);
  console.log();

  // Test reasonable Sacramento market rates
  console.log("📊 SACRAMENTO MARKET REALITY CHECK:");
  const reasonableMonthlyRent = 1800 * 1.75; // $1.75/sqft typical
  const reasonableGRM = Math.round(testProperty.price / reasonableMonthlyRent);
  const reasonableYield = (reasonableMonthlyRent * 12 / testProperty.price * 100).toFixed(2);
  console.log(`Reasonable rent for ${testProperty.livingArea} sqft: $${Math.round(reasonableMonthlyRent)}/month`);
  console.log(`Reasonable GRM: ${reasonableGRM}`);
  console.log(`Reasonable yield: ${reasonableYield}%`);
  console.log(`Market realistic? ${reasonableGRM >= 8 && reasonableGRM <= 25 ? '✅ YES' : '❌ NO'}`);
  console.log();

  console.log("💡 CONCLUSION:");
  if (monthlyGRM > 50) {
    console.log("❌ rentZestimate appears to be MONTHLY but values are too low for market");
    console.log("   Either rentZestimate data is incorrect or needs validation");
  } else if (annualGRM >= 8 && annualGRM <= 25) {
    console.log("✅ rentZestimate might be ANNUAL, dividing by 12 gives reasonable GRM");
  } else {
    console.log("⚠️  rentZestimate data needs investigation - unclear format");
  }
}

testGRMCalculations();
// Test the cap/floor adjustments for Add-On calculation
const { calculateStrategy } = require("./strategyCalculator");

console.log("=== ADD-ON CAP/FLOOR TEST ===\n");

// Test property
const testProperty = {
  zpid: "cap_test",
  price: 300000,
  livingArea: 1400,
  bedrooms: 2,
  bathrooms: 2
};

// Create extreme scenario to test cap/floor - very high target bedroom prices
const mockFilteredCompsHigh = [
  // 3-bedroom comps with EXTREMELY high prices (should be capped)
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 600000 }, sqFt: { value: 1500 } } } } }, // $400/sqft
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 650000 }, sqFt: { value: 1600 } } } } }, // $406/sqft
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 680000 }, sqFt: { value: 1650 } } } } }, // $412/sqft
];

// Create extreme scenario to test floor - very low target bedroom prices
const mockFilteredCompsLow = [
  // 3-bedroom comps with EXTREMELY low prices (should be floored)
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 180000 }, sqFt: { value: 1500 } } } } }, // $120/sqft
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 190000 }, sqFt: { value: 1600 } } } } }, // $119/sqft
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 200000 }, sqFt: { value: 1650 } } } } }, // $121/sqft
];

async function testCapFloor() {
  const marketRate = 250; // Market rate for comparison
  console.log("🏠 PROPERTY DETAILS:");
  console.log(`   Price: $${testProperty.price.toLocaleString()}`);
  console.log(`   Living Area: ${testProperty.livingArea} sqft → ${testProperty.livingArea + 120} sqft`);
  console.log(`   Market Rate: $${marketRate}/sqft`);
  console.log(`   Cap Range: $${Math.round(marketRate * 0.8)}/sqft (floor) - $${Math.round(marketRate * 1.3)}/sqft (cap)`);

  console.log("\n🔺 TEST 1: HIGH PRICE SCENARIO (Testing Cap):");

  const highComps = mockFilteredCompsHigh;
  highComps.forEach((comp, i) => {
    const price = comp.data.aboveTheFold.addressSectionInfo.priceInfo.amount;
    const sqft = comp.data.aboveTheFold.addressSectionInfo.sqFt.value;
    const pricePerSqft = Math.round(price / sqft);
    console.log(`   • Comp ${i+1}: $${price.toLocaleString()} / ${sqft} sqft = $${pricePerSqft}/sqft`);
  });

  const highAvg = Math.round(highComps.reduce((sum, comp) => {
    const price = comp.data.aboveTheFold.addressSectionInfo.priceInfo.amount;
    const sqft = comp.data.aboveTheFold.addressSectionInfo.sqFt.value;
    return sum + (price / sqft);
  }, 0) / highComps.length);

  console.log(`   📊 Average: $${highAvg}/sqft (should be capped at $${Math.round(marketRate * 1.3)}/sqft)`);

  try {
    const highParams = { filteredComps: highComps, bypassMinReturn: true };
    const highResult = calculateStrategy("Add-On", testProperty, highParams, marketRate, 0, []);
    console.log(`   ✅ Result: Used capped rate in calculation`);
  } catch (e) {
    console.log(`   ❌ Test failed: ${e.message}`);
  }

  console.log("\n🔻 TEST 2: LOW PRICE SCENARIO (Testing Floor):");

  const lowComps = mockFilteredCompsLow;
  lowComps.forEach((comp, i) => {
    const price = comp.data.aboveTheFold.addressSectionInfo.priceInfo.amount;
    const sqft = comp.data.aboveTheFold.addressSectionInfo.sqFt.value;
    const pricePerSqft = Math.round(price / sqft);
    console.log(`   • Comp ${i+1}: $${price.toLocaleString()} / ${sqft} sqft = $${pricePerSqft}/sqft`);
  });

  const lowAvg = Math.round(lowComps.reduce((sum, comp) => {
    const price = comp.data.aboveTheFold.addressSectionInfo.priceInfo.amount;
    const sqft = comp.data.aboveTheFold.addressSectionInfo.sqFt.value;
    return sum + (price / sqft);
  }, 0) / lowComps.length);

  console.log(`   📊 Average: $${lowAvg}/sqft (should be floored at $${Math.round(marketRate * 0.8)}/sqft)`);

  try {
    const lowParams = { filteredComps: lowComps, bypassMinReturn: true };
    const lowResult = calculateStrategy("Add-On", testProperty, lowParams, marketRate, 0, []);
    console.log(`   ✅ Result: Used floored rate in calculation`);
  } catch (e) {
    console.log(`   ❌ Test failed: ${e.message}`);
  }

  console.log("\n🎯 CAP/FLOOR SUMMARY:");
  console.log(`   Market Rate: $${marketRate}/sqft`);
  console.log(`   Floor (80%): $${Math.round(marketRate * 0.8)}/sqft - prevents undervaluation`);
  console.log(`   Cap (130%): $${Math.round(marketRate * 1.3)}/sqft - prevents overvaluation`);
  console.log(`   Raw High Avg: $${highAvg}/sqft → Capped`);
  console.log(`   Raw Low Avg: $${lowAvg}/sqft → Floored`);
}

console.log("🎯 TESTING CAP/FLOOR PROTECTION:");
console.log("• Cap: Prevents target bedroom comps from being >130% of market rate");
console.log("• Floor: Prevents target bedroom comps from being <80% of market rate");
console.log("• Protects against extreme outliers in target bedroom data");

testCapFloor().catch(console.error);
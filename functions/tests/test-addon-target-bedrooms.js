// Test the updated Add-On calculation using target bedroom comps
const { calculateStrategy } = require("./strategyCalculator");

console.log("=== ADD-ON TARGET BEDROOM COMPS TEST ===\n");

// Test property: 2-bedroom that will become 3-bedroom
const testProperty = {
  zpid: "addon_test",
  price: 350000,  // Lower purchase price for better margins
  livingArea: 1400,
  bedrooms: 2,
  bathrooms: 2
};

// Mock filtered comps with different bedroom counts (using correct data structure)
const mockFilteredComps = [
  // 2-bedroom comps
  { beds: 2, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 380000 }, sqFt: { value: 1300 } } } } },
  { beds: 2, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 420000 }, sqFt: { value: 1500 } } } } },
  { beds: 2, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 390000 }, sqFt: { value: 1350 } } } } },

  // 3-bedroom comps (target bedroom count)
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 450000 }, sqFt: { value: 1600 } } } } }, // $281/sqft
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 480000 }, sqFt: { value: 1650 } } } } }, // $291/sqft
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 465000 }, sqFt: { value: 1620 } } } } }, // $287/sqft

  // 4-bedroom comps
  { beds: 4, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 550000 }, sqFt: { value: 1900 } } } } },
  { beds: 4, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 580000 }, sqFt: { value: 2000 } } } } }
];

const testParams = {
  filteredComps: mockFilteredComps,
  addOnDuration: 6,
  bypassMinReturn: true
};

async function testAddOnCalculation() {
  console.log("🏠 PROPERTY DETAILS:");
  console.log(`   Address: Test Property`);
  console.log(`   Price: $${testProperty.price.toLocaleString()}`);
  console.log(`   Living Area: ${testProperty.livingArea} sqft`);
  console.log(`   Bedrooms: ${testProperty.bedrooms} → ${testProperty.bedrooms + 1} (after addition)`);
  console.log(`   Addition Size: 120 sqft`);

  console.log("\n📊 COMPARABLE ANALYSIS:");

  // Show 2-bedroom comps
  const twoBedComps = mockFilteredComps.filter(comp => comp.beds === 2);
  console.log(`\n   2-Bedroom Comps (${twoBedComps.length}):`);
  twoBedComps.forEach((comp, i) => {
    const price = comp.data.aboveTheFold.addressSectionInfo.priceInfo.amount;
    const sqft = comp.data.aboveTheFold.addressSectionInfo.sqFt.value;
    const pricePerSqft = Math.round(price / sqft);
    console.log(`   • Comp ${i+1}: $${price.toLocaleString()} / ${sqft} sqft = $${pricePerSqft}/sqft`);
  });

  // Show 3-bedroom comps (target)
  const threeBedComps = mockFilteredComps.filter(comp => comp.beds === 3);
  console.log(`\n   3-Bedroom Comps (${threeBedComps.length}) - TARGET BEDROOM COUNT:`);
  threeBedComps.forEach((comp, i) => {
    const price = comp.data.aboveTheFold.addressSectionInfo.priceInfo.amount;
    const sqft = comp.data.aboveTheFold.addressSectionInfo.sqFt.value;
    const pricePerSqft = Math.round(price / sqft);
    console.log(`   • Comp ${i+1}: $${price.toLocaleString()} / ${sqft} sqft = $${pricePerSqft}/sqft`);
  });

  // Calculate average target bedroom price per sqft
  const targetPrices = threeBedComps.map(comp => {
    const price = comp.data.aboveTheFold.addressSectionInfo.priceInfo.amount;
    const sqft = comp.data.aboveTheFold.addressSectionInfo.sqFt.value;
    return price / sqft;
  });
  const avgTargetPrice = targetPrices.reduce((sum, price) => sum + price, 0) / targetPrices.length;
  console.log(`\n   ✅ 3-Bedroom Average: $${Math.round(avgTargetPrice)}/sqft`);

  console.log("\n🔨 ADD-ON CALCULATION:");

  try {
    const result = calculateStrategy("Add-On", testProperty, testParams, 250, 0, []);

    console.log(`\n📐 CALCULATION DETAILS:`);
    console.log(`   Future Living Area: ${testProperty.livingArea + 120} sqft`);
    console.log(`   Target Bedroom Count: 3 bedrooms`);
    console.log(`   Improvement Factor: 1.0 (no discount)`);
    console.log(`   Future Value: $${result.futureValue?.toLocaleString()}`);
    console.log(`   Valuation Method: ${result.config?.valuationMethod}`);

    console.log(`\n💰 FINANCIAL RESULTS:`);
    console.log(`   Future Value: $${result.futureValue?.toLocaleString()}`);
    console.log(`   Total Costs: $${result.totalCosts?.toLocaleString()}`);
    console.log(`   Net Return: $${result.netReturn?.toLocaleString()}`);
    console.log(`   ROI: ${result.netROI?.toFixed(2)}%`);

    // Verify calculation manually
    const expectedFutureValue = Math.round((testProperty.livingArea + 120) * avgTargetPrice);
    console.log(`\n🔍 VERIFICATION:`);
    console.log(`   Manual Calculation: ${testProperty.livingArea + 120} sqft × $${Math.round(avgTargetPrice)}/sqft = $${expectedFutureValue.toLocaleString()}`);
    console.log(`   System Calculation: $${result.futureValue?.toLocaleString()}`);
    console.log(`   Match: ${Math.abs(result.futureValue - expectedFutureValue) < 1000 ? '✅' : '❌'}`);

  } catch (error) {
    console.error(`❌ Error calculating Add-On strategy: ${error.message}`);
  }
}

console.log("🎯 TESTING NEW ADD-ON CALCULATION METHOD:");
console.log("• Uses target bedroom count comps (3BR for 2BR→3BR conversion)");
console.log("• Applies target comp average price per sqft to total future area");
console.log("• Uses 1.0 improvement factor (no discount)");
console.log("• Fallback to market rate if insufficient target comps");

testAddOnCalculation().catch(console.error);
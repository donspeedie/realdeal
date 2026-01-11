// Test the size-leveling improvements for Add-On calculation
const { calculateStrategy } = require("./strategyCalculator");

console.log("=== ADD-ON SIZE LEVELING TEST ===\n");

// Test property: 2-bedroom that will become 3-bedroom
const testProperty = {
  zpid: "size_test",
  price: 350000,
  livingArea: 1400,
  bedrooms: 2,
  bathrooms: 2
};

// Mock comps with mix of similar-sized and much larger 3-bedroom properties
const mockFilteredComps = [
  // 2-bedroom comps (baseline)
  { beds: 2, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 380000 }, sqFt: { value: 1300 } } } } },
  { beds: 2, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 420000 }, sqFt: { value: 1500 } } } } },

  // 3-bedroom comps - SIMILAR SIZE (should be included in size filter)
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 430000 }, sqFt: { value: 1500 } } } } }, // $287/sqft
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 450000 }, sqFt: { value: 1600 } } } } }, // $281/sqft
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 465000 }, sqFt: { value: 1650 } } } } }, // $282/sqft

  // 3-bedroom comps - MUCH LARGER (should be filtered out to prevent skewing)
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 750000 }, sqFt: { value: 2500 } } } } }, // $300/sqft - LARGE
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 850000 }, sqFt: { value: 2800 } } } } }, // $304/sqft - LARGE
  { beds: 3, data: { aboveTheFold: { addressSectionInfo: { priceInfo: { amount: 950000 }, sqFt: { value: 3000 } } } } }, // $317/sqft - LARGE
];

const testParams = {
  filteredComps: mockFilteredComps,
  addOnDuration: 6,
  bypassMinReturn: true
};

async function testSizeLeveling() {
  console.log("🏠 PROPERTY DETAILS:");
  console.log(`   Address: Size Leveling Test Property`);
  console.log(`   Price: $${testProperty.price.toLocaleString()}`);
  console.log(`   Living Area: ${testProperty.livingArea} sqft`);
  console.log(`   Future Area: ${testProperty.livingArea + 120} sqft (after 120 sqft addition)`);
  console.log(`   Bedrooms: ${testProperty.bedrooms} → ${testProperty.bedrooms + 1}`);

  console.log("\n📊 COMPARABLE ANALYSIS:");

  // Show all 3-bedroom comps grouped by size
  const threeBedComps = mockFilteredComps.filter(comp => comp.beds === 3);
  const futureArea = testProperty.livingArea + 120;

  console.log(`\n   3-Bedroom Comps Analysis (Target bedroom count):`);

  const similarSizeComps = [];
  const largeSizeComps = [];

  threeBedComps.forEach((comp, i) => {
    const price = comp.data.aboveTheFold.addressSectionInfo.priceInfo.amount;
    const sqft = comp.data.aboveTheFold.addressSectionInfo.sqFt.value;
    const pricePerSqft = Math.round(price / sqft);
    const sizeRatio = sqft / futureArea;
    const isInRange = sizeRatio >= 0.7 && sizeRatio <= 1.5;

    if (isInRange) {
      similarSizeComps.push({ price, sqft, pricePerSqft });
    } else {
      largeSizeComps.push({ price, sqft, pricePerSqft });
    }

    const filterStatus = isInRange ? "✅ INCLUDED" : "❌ FILTERED OUT";
    console.log(`   • Comp ${i+1}: $${price.toLocaleString()} / ${sqft.toLocaleString()} sqft = $${pricePerSqft}/sqft - ${filterStatus} (ratio: ${sizeRatio.toFixed(2)}x)`);
  });

  // Calculate averages
  const similarAvg = similarSizeComps.length > 0 ?
    Math.round(similarSizeComps.reduce((sum, comp) => sum + comp.pricePerSqft, 0) / similarSizeComps.length) : 0;

  const allAvg = Math.round(threeBedComps.reduce((sum, comp) => {
    const price = comp.data.aboveTheFold.addressSectionInfo.priceInfo.amount;
    const sqft = comp.data.aboveTheFold.addressSectionInfo.sqFt.value;
    return sum + (price / sqft);
  }, 0) / threeBedComps.length);

  console.log(`\n   📊 PRICE ANALYSIS:`);
  console.log(`   • Similar-sized comps (${similarSizeComps.length}): $${similarAvg}/sqft average`);
  console.log(`   • All 3BR comps (${threeBedComps.length}): $${allAvg}/sqft average`);
  console.log(`   • Difference: $${allAvg - similarAvg}/sqft (${Math.round((allAvg - similarAvg) / similarAvg * 100)}% higher without filtering)`);

  console.log(`\n   🎯 SIZE FILTERING RANGE:`);
  console.log(`   • Target future area: ${futureArea} sqft`);
  console.log(`   • Size filter range: ${Math.round(futureArea * 0.7)} - ${Math.round(futureArea * 1.5)} sqft (70%-150%)`);

  console.log("\n🔨 ADD-ON CALCULATION WITH SIZE LEVELING:");

  try {
    const result = calculateStrategy("Add-On", testProperty, testParams, 275, 0, []);

    console.log(`\n📐 LEVELING RESULTS:`);
    console.log(`   Future Value: $${result.futureValue?.toLocaleString()}`);
    console.log(`   Valuation Method: ${result.config?.valuationMethod}`);
    console.log(`   Net Return: $${result.netReturn?.toLocaleString()}`);

    // Calculate what the result would have been without filtering
    const unfiltered = futureArea * allAvg;
    const filtered = result.futureValue;
    const difference = unfiltered - filtered;

    console.log(`\n🔍 COMPARISON:`);
    console.log(`   Without size filtering: ${futureArea} × $${allAvg} = $${Math.round(unfiltered).toLocaleString()}`);
    console.log(`   With size filtering: $${filtered?.toLocaleString()}`);
    console.log(`   Difference: $${Math.round(difference).toLocaleString()} (${Math.round(difference / unfiltered * 100)}% reduction from filtering out large homes)`);

  } catch (error) {
    console.error(`❌ Error: ${error.message}`);
  }
}

console.log("🎯 TESTING SIZE LEVELING FEATURES:");
console.log("• Filters 3BR comps to 70%-150% of future area (1,520 sqft)");
console.log("• Applies 80%-130% cap/floor relative to market rate");
console.log("• Prevents skewing from large luxury homes");
console.log("• Falls back to all comps if insufficient size-similar comps");

testSizeLeveling().catch(console.error);
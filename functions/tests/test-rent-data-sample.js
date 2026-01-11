// Test to show rentZestimate data structure and availability
const { calculateStrategy } = require("./strategyCalculator");

console.log("=== RENT DATA SAMPLE TEST ===\n");

// Simulate property data with different rent scenarios
const testProperties = [
  {
    // Sacramento property with rent data
    zpid: "sacramento_with_rent",
    price: 450000,
    livingArea: 1800,
    bedrooms: 3,
    bathrooms: 2,
    rentZestimate: 2800  // $2,800/month rent
  },
  {
    // Sacramento property without rent data
    zpid: "sacramento_no_rent",
    price: 520000,
    livingArea: 2000,
    bedrooms: 4,
    bathrooms: 2
    // Missing rentZestimate
  },
  {
    // High-rent Sacramento property
    zpid: "sacramento_high_rent",
    price: 750000,
    livingArea: 2200,
    bedrooms: 4,
    bathrooms: 3,
    rentZestimate: 4200  // $4,200/month rent
  }
];

async function testRentDataSamples() {
  console.log("📊 RENT DATA AVAILABILITY TEST:");
  console.log("━".repeat(50));

  for (const prop of testProperties) {
    console.log(`\n🏠 Property: ${prop.zpid}`);
    console.log(`   Price: $${prop.price.toLocaleString()}`);
    console.log(`   Size: ${prop.livingArea} sqft`);
    console.log(`   Bedrooms: ${prop.bedrooms}`);

    if (prop.rentZestimate) {
      console.log(`   ✅ Rent Data: $${prop.rentZestimate}/month`);

      // Calculate rent metrics
      const rentPerSqft = (prop.rentZestimate / prop.livingArea).toFixed(2);
      const rentRatio = (prop.rentZestimate / prop.price * 100).toFixed(2);
      const annualYield = (prop.rentZestimate * 12 / prop.price * 100).toFixed(2);
      const grm = Math.round(prop.price / prop.rentZestimate);

      console.log(`   • Rent/SqFt: $${rentPerSqft}/sqft`);
      console.log(`   • Rent Ratio: ${rentRatio}% of property value`);
      console.log(`   • Annual Yield: ${annualYield}%`);
      console.log(`   • GRM: ${grm} (Price ÷ Monthly Rent)`);

      // Test ADU rent estimation
      const estimatedAduRent = Math.round(750 * parseFloat(rentPerSqft) * 0.85);
      console.log(`   • Est. ADU Rent: $${estimatedAduRent}/mo (750 sqft × $${rentPerSqft} × 85%)`);

    } else {
      console.log(`   ❌ No Rent Data Available`);
      console.log(`   • Will use regional fallback estimation`);
      console.log(`   • May impact ADU income approach accuracy`);
    }
  }

  console.log("\n💡 ADU INCOME APPROACH REQUIREMENTS:");
  console.log("━".repeat(50));
  console.log("✅ Primary: Uses rentZestimate if available");
  console.log("✅ Fallback: Regional estimates based on property value");
  console.log("✅ GRM Calculation: Price ÷ Monthly Rent");
  console.log("✅ ADU Rent: Main house rent/sqft × 750 sqft × 85% discount");

  console.log("\n🎯 SACRAMENTO RENT MARKET CONTEXT:");
  console.log("━".repeat(50));
  console.log("• Typical rent: $1.50-$2.50/sqft");
  console.log("• 750 sqft ADU: $1,125-$1,875/month estimated");
  console.log("• GRM range: 12-18 (typical for Sacramento area)");
  console.log("• ADU income value: $13,500-$33,750 (using GRM method)");

  console.log("\n⚠️  POTENTIAL ADU FILTERING ISSUES:");
  console.log("━".repeat(50));
  console.log("1. Missing rentZestimate data → Falls back to regional estimates");
  console.log("2. High ADU construction cost ($150K) vs income value");
  console.log("3. Minimum return filter ($20K) may exclude marginal deals");
  console.log("4. Competition with Fix & Flip returns");
}

testRentDataSamples().catch(console.error);
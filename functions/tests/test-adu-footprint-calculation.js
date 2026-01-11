// Test ADU footprint calculation for different story configurations
const { calculateStrategy } = require("./strategyCalculator");

console.log("=== ADU FOOTPRINT CALCULATION TEST ===\n");

// Test scenarios showing how footprint affects available space
const testScenarios = [
  {
    name: "Single Story House",
    property: {
      zpid: "single_story",
      price: 350000,
      livingArea: 1800, // 1,800 sqft single story
      bedrooms: 3,
      bathrooms: 2,
      lotAreaValue: 6000,
      rentZestimate: 2000
    },
    description: "1,800 sqft single story - footprint ≈ 1,200 sqft"
  },
  {
    name: "Two Story House (Same Living Area)",
    property: {
      zpid: "two_story",
      price: 350000,
      livingArea: 1800, // 1,800 sqft two story
      bedrooms: 3,
      bathrooms: 2,
      lotAreaValue: 6000, // Same lot size
      rentZestimate: 2000
    },
    description: "1,800 sqft two story - footprint ≈ 1,200 sqft (avg assumption)"
  },
  {
    name: "Large Single Story",
    property: {
      zpid: "large_single",
      price: 450000,
      livingArea: 2400, // Large single story
      bedrooms: 4,
      bathrooms: 3,
      lotAreaValue: 7000,
      rentZestimate: 2300
    },
    description: "2,400 sqft single story - footprint ≈ 1,600 sqft"
  },
  {
    name: "Large Two Story (Same Living Area)",
    property: {
      zpid: "large_two_story",
      price: 450000,
      livingArea: 2400, // Large two story
      bedrooms: 4,
      bathrooms: 3,
      lotAreaValue: 7000, // Same lot size
      rentZestimate: 2300
    },
    description: "2,400 sqft two story - footprint ≈ 1,600 sqft (avg assumption)"
  }
];

async function testFootprintCalculations() {
  console.log("🏠 FOOTPRINT CALCULATION COMPARISON:");
  console.log("Current method: footprint = livingArea ÷ 1.5 (assumes average 1.5 stories)");
  console.log("• Single story actual: footprint = livingArea");
  console.log("• Two story actual: footprint = livingArea ÷ 2");
  console.log("• Our assumption: footprint = livingArea ÷ 1.5 (compromise between 1 and 2 story)");
  console.log();

  for (let i = 0; i < testScenarios.length; i++) {
    const scenario = testScenarios[i];
    const { name, property, description } = scenario;

    console.log(`📊 SCENARIO ${i+1}: ${name}`);
    console.log(`   ${description}`);

    // Calculate footprints for comparison
    const livingArea = property.livingArea;
    const currentFootprint = Math.max(livingArea / 1.5, 800); // Our current method
    const singleStoryFootprint = livingArea; // If it were single story
    const twoStoryFootprint = livingArea / 2; // If it were two story

    console.log(`   Footprint comparisons:`);
    console.log(`   • If single story: ${singleStoryFootprint} sqft footprint`);
    console.log(`   • If two story: ${twoStoryFootprint} sqft footprint`);
    console.log(`   • Our estimate: ${Math.round(currentFootprint)} sqft footprint`);

    // Calculate available space
    const lotArea = property.lotAreaValue;
    const setbacks = lotArea * 0.25;
    const driveway = 600;
    const availableSpace = lotArea - currentFootprint - setbacks - driveway;
    const aduNeeded = 750 * 1.5; // 1,125 sqft

    console.log(`   Space analysis:`);
    console.log(`   • Lot area: ${lotArea} sqft`);
    console.log(`   • House footprint: ${Math.round(currentFootprint)} sqft`);
    console.log(`   • Setbacks (25%): ${Math.round(setbacks)} sqft`);
    console.log(`   • Driveway: ${driveway} sqft`);
    console.log(`   • Available: ${Math.round(availableSpace)} sqft`);
    console.log(`   • ADU needs: ${aduNeeded} sqft`);
    console.log(`   • Fit ADU: ${availableSpace >= aduNeeded ? '✅ YES' : '❌ NO'} (${(availableSpace / aduNeeded).toFixed(1)}x)`);

    console.log();
  }

  console.log("💡 FOOTPRINT ESTIMATION IMPACT:");
  console.log("• Better footprint estimation = more accurate available space calculation");
  console.log("• Single story homes have larger footprints = less available space for ADU");
  console.log("• Two story homes have smaller footprints = more available space for ADU");
  console.log("• Our 1.5x divisor provides reasonable middle-ground estimate");
  console.log("• Could be enhanced with actual story count data if available");
}

testFootprintCalculations().catch(console.error);
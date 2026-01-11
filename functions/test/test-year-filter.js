// Test the year built filter
const {processProperty} = require("./propertyProcessor");

console.log("=== TESTING YEAR BUILT FILTER ===\n");

// Mock property data to test different year scenarios
async function testYearFilter() {

  console.log("🏠 TEST 1: Property built in 2010 (should be INCLUDED)");
  const oldProperty = {
    zpid: "test_2010",
    price: 400000,
    livingArea: 1500,
    bedrooms: 3,
    bathrooms: 2,
    address: "123 Test St, Sacramento, CA 95820"
  };

  // Mock the property details response for 2010
  const originalFetchZillow = require("./zillowApi").fetchZillowDataWithCache;
  const originalFetchRedfin = require("./redfinApi").fetchRedfinDataWithCache;

  // Mock responses
  require("./zillowApi").fetchZillowDataWithCache = async (endpoint, params) => {
    if (endpoint === "propertyDetails") {
      return { data: { yearBuilt: 2010, description: "Great house" } };
    }
    return { data: { value: 450000 } };
  };

  require("./redfinApi").fetchRedfinDataWithCache = async (endpoint, params) => {
    return { data: { data: { homes: [] } } };
  };

  try {
    const result2010 = await processProperty(oldProperty, {}, 1, 1);
    console.log(`Result: ${result2010.length > 0 ? 'INCLUDED ✅' : 'FILTERED OUT ❌'}`);
    if (result2010.length > 0) {
      console.log(`Year Built: ${result2010[0].yearBuilt}`);
    }
  } catch (error) {
    console.log(`Error: ${error.message}`);
  }

  console.log("\n" + "=".repeat(50));

  console.log("\n🏠 TEST 2: Property built in 2015 (should be FILTERED OUT)");

  // Mock for 2015 property
  require("./zillowApi").fetchZillowDataWithCache = async (endpoint, params) => {
    if (endpoint === "propertyDetails") {
      return { data: { yearBuilt: 2015, description: "New construction" } };
    }
    return { data: { value: 500000 } };
  };

  const newProperty = {
    zpid: "test_2015",
    price: 500000,
    livingArea: 1800,
    bedrooms: 4,
    bathrooms: 3,
    address: "456 New St, Sacramento, CA 95820"
  };

  try {
    const result2015 = await processProperty(newProperty, {}, 1, 1);
    console.log(`Result: ${result2015.length > 0 ? 'INCLUDED ❌' : 'FILTERED OUT ✅'}`);
    if (result2015.length > 0) {
      console.log(`Year Built: ${result2015[0].yearBuilt}`);
    }
  } catch (error) {
    console.log(`Error: ${error.message}`);
  }

  console.log("\n" + "=".repeat(50));

  console.log("\n🏠 TEST 3: Property with no year data (should be INCLUDED)");

  // Mock for property with no year data
  require("./zillowApi").fetchZillowDataWithCache = async (endpoint, params) => {
    if (endpoint === "propertyDetails") {
      return { data: { description: "Unknown year" } }; // No yearBuilt field
    }
    return { data: { value: 350000 } };
  };

  const unknownYearProperty = {
    zpid: "test_unknown",
    price: 350000,
    livingArea: 1200,
    bedrooms: 2,
    bathrooms: 1,
    address: "789 Old St, Sacramento, CA 95820"
  };

  try {
    const resultUnknown = await processProperty(unknownYearProperty, {}, 1, 1);
    console.log(`Result: ${resultUnknown.length > 0 ? 'INCLUDED ✅' : 'FILTERED OUT ❌'}`);
    if (resultUnknown.length > 0) {
      console.log(`Year Built: ${resultUnknown[0].yearBuilt || 'Unknown'}`);
    }
  } catch (error) {
    console.log(`Error: ${error.message}`);
  }

  // Restore original functions
  require("./zillowApi").fetchZillowDataWithCache = originalFetchZillow;
  require("./redfinApi").fetchRedfinDataWithCache = originalFetchRedfin;

  console.log("\n📋 SUMMARY:");
  console.log("✅ Properties built in 2011 or earlier: INCLUDED");
  console.log("❌ Properties built after 2011: FILTERED OUT");
  console.log("✅ Properties with unknown year: INCLUDED (treated as 0)");
  console.log("\nFilter logic: if (yearBuilt > 2011) return []");
}

testYearFilter().catch(console.error);
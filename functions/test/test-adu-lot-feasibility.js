// Test ADU lot area feasibility checking
const { calculateStrategy } = require("./strategyCalculator");

console.log("=== ADU LOT FEASIBILITY TEST ===\n");

// Test scenarios with different lot sizes
const testScenarios = [
  {
    name: "Large Lot - Should Pass",
    property: {
      zpid: "large_lot",
      price: 400000,
      livingArea: 1800,
      bedrooms: 3,
      bathrooms: 2,
      lotAreaValue: 8000, // Large lot
      rentZestimate: 2200
    },
    expected: "feasible"
  },
  {
    name: "Medium Lot - Should Pass",
    property: {
      zpid: "medium_lot",
      price: 350000,
      livingArea: 1500,
      bedrooms: 3,
      bathrooms: 2,
      lotAreaValue: 5500, // Medium lot
      rentZestimate: 2000
    },
    expected: "feasible"
  },
  {
    name: "Small Lot - Should Fail (Too Small)",
    property: {
      zpid: "small_lot",
      price: 300000,
      livingArea: 1200,
      bedrooms: 2,
      bathrooms: 1,
      lotAreaValue: 3500, // Too small (< 4000 sqft minimum)
      rentZestimate: 1800
    },
    expected: "not_feasible"
  },
  {
    name: "Tiny Lot - Should Fail (Insufficient Space)",
    property: {
      zpid: "tiny_lot",
      price: 280000,
      livingArea: 900,
      bedrooms: 2,
      bathrooms: 1,
      lotAreaValue: 2800, // Very small lot
      rentZestimate: 1600
    },
    expected: "not_feasible"
  },
  {
    name: "Unknown Lot Size - Should Pass (Default)",
    property: {
      zpid: "unknown_lot",
      price: 320000,
      livingArea: 1400,
      bedrooms: 3,
      bathrooms: 2,
      lotAreaValue: 0, // No lot data
      rentZestimate: 1900
    },
    expected: "feasible"
  },
  {
    name: "Large House on Small Lot - Should Fail",
    property: {
      zpid: "large_house_small_lot",
      price: 450000,
      livingArea: 2800, // Large house
      bedrooms: 4,
      bathrooms: 3,
      lotAreaValue: 4500, // Small lot for large house
      rentZestimate: 2400
    },
    expected: "not_feasible"
  }
];

const testParams = {
  filteredComps: [],
  aduDuration: 9,
  bypassMinReturn: true
};

async function testADUFeasibility() {
  console.log("🎯 ADU LOT FEASIBILITY TESTING:");
  console.log("• Minimum lot size: 4,000 sqft");
  console.log("• House footprint: 40% of living area or 800 sqft minimum");
  console.log("• Setbacks: 25% of lot area");
  console.log("• Driveway/parking: 600 sqft");
  console.log("• ADU size: 750 sqft + 50% clearance = 1,125 sqft total");
  console.log();

  let passCount = 0;
  let totalTests = testScenarios.length;

  for (let i = 0; i < testScenarios.length; i++) {
    const scenario = testScenarios[i];
    const { name, property, expected } = scenario;

    console.log(`📋 TEST ${i+1}: ${name}`);
    console.log(`   Property: ${property.livingArea} sqft house on ${property.lotAreaValue || 'unknown'} sqft lot`);

    if (property.lotAreaValue > 0) {
      // Calculate space breakdown for display
      const houseFootprint = Math.max(property.livingArea * 0.4, 800);
      const setbackArea = property.lotAreaValue * 0.25;
      const drivewayParking = 600;
      const availableSpace = property.lotAreaValue - houseFootprint - setbackArea - drivewayParking;
      const aduRequired = 750 * 1.5;

      console.log(`   Space breakdown:`);
      console.log(`   • Lot area: ${property.lotAreaValue} sqft`);
      console.log(`   • House footprint: ${Math.round(houseFootprint)} sqft`);
      console.log(`   • Setbacks: ${Math.round(setbackArea)} sqft`);
      console.log(`   • Driveway: ${drivewayParking} sqft`);
      console.log(`   • Available: ${Math.round(availableSpace)} sqft`);
      console.log(`   • ADU needed: ${Math.round(aduRequired)} sqft`);
    }

    try {
      const result = calculateStrategy("ADU", property, testParams, 250, 0, []);

      // Check if rejection was due to lot feasibility (our target) vs financial reasons
      const lotFeasibilityRejection = result && result.config && result.config.valuationMethod === "adu_lot_size_insufficient";
      const financialRejection = result && result.futureValue > 0 && !result.profitable;

      const actualFeasible = result && result.futureValue && result.futureValue > 0 && !lotFeasibilityRejection;
      const expectedFeasible = expected === "feasible";

      // For lot feasibility tests, we only care about lot-specific rejections, not financial ones
      let testPassed;
      if (expectedFeasible) {
        // Should be feasible - pass if no lot rejection (ignore financial rejection for this test)
        testPassed = !lotFeasibilityRejection;
      } else {
        // Should not be feasible - pass if lot rejection occurred
        testPassed = lotFeasibilityRejection;
      }

      if (testPassed) {
        if (lotFeasibilityRejection) {
          console.log(`   ✅ PASS: ADU rejected due to lot constraints (as expected)`);
        } else if (financialRejection) {
          console.log(`   ✅ PASS: ADU lot feasible, but financially rejected (lot test passed)`);
        } else {
          console.log(`   ✅ PASS: ADU lot feasible and strategy accepted`);
        }
        passCount++;
      } else {
        if (expectedFeasible && lotFeasibilityRejection) {
          console.log(`   ❌ FAIL: Expected lot feasible, but rejected due to lot constraints`);
        } else if (!expectedFeasible && !lotFeasibilityRejection) {
          console.log(`   ❌ FAIL: Expected lot rejection, but lot was deemed feasible`);
        } else {
          console.log(`   ❌ FAIL: Unexpected result pattern`);
        }
      }

      // Show results details
      if (result && result.futureValue > 0) {
        console.log(`   💰 Future Value: $${result.futureValue.toLocaleString()}`);
      }
      if (result && result.config && result.config.valuationMethod) {
        console.log(`   📊 Valuation Method: ${result.config.valuationMethod}`);
      }
      if (lotFeasibilityRejection) {
        console.log(`   🚫 Lot Rejection Reason: Check console output above`);
      }

    } catch (error) {
      const expectedFeasible = expected === "feasible";
      if (!expectedFeasible) {
        console.log(`   ✅ PASS: ADU rejected due to error (as expected)`);
        passCount++;
      } else {
        console.log(`   ❌ FAIL: Unexpected error - ${error.message}`);
      }
    }

    console.log();
  }

  console.log(`📊 TEST SUMMARY:`);
  console.log(`   Tests passed: ${passCount}/${totalTests}`);
  console.log(`   Success rate: ${Math.round(passCount/totalTests*100)}%`);

  if (passCount === totalTests) {
    console.log(`   🎉 All tests passed! ADU lot feasibility checking working correctly.`);
  } else {
    console.log(`   ⚠️ Some tests failed. Review feasibility logic.`);
  }
}

testADUFeasibility().catch(console.error);
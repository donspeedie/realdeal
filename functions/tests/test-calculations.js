// Test script to verify calculation fixes
const {calculateStrategy} = require("./strategyCalculator");

// Test data matching your screenshot
const testProperty = {
  zpid: "test123",
  price: 375000,
  livingArea: 1500,
  bedrooms: 3,
  bathrooms: 2,
  latitude: 37.123,
  longitude: -122.456
};

const testParams = {
  interestRate: 0.06,
  salRate: 0.04,
  loanFeesRate: 0.01,
  permitsFees: 1000,
  fixFlipDuration: 3,
  futureValue: 509962  // Override to match your screenshot
};

// Test with manual overrides to match your screenshot
const testPropertyWithOverrides = {
  ...testProperty,
  impValue: 18000,
  loanPayments: 10614,
  loanFees: 10611,
  sellingCosts: 20398
};

console.log("Testing Fix & Flip calculation...");

try {
  const result = calculateStrategy("Fix & Flip", testPropertyWithOverrides, testParams, 250, 0, []);

  if (result) {
    console.log("\n=== CALCULATION RESULTS ===");
    console.log(`Future Value: $${result.futureValue?.toLocaleString() || 'N/A'}`);
    console.log(`Total Costs: $${result.totalCosts?.toLocaleString() || 'N/A'}`);
    console.log(`Net Return: $${result.netReturn?.toLocaleString() || 'N/A'}`);
    console.log(`Cash Needed: $${result.cashNeeded?.toLocaleString() || 'N/A'}`);

    console.log("\n=== RETURN CALCULATIONS ===");
    console.log(`Return on Investment (ROI): ${result.netROI?.toFixed(2) || 'N/A'}%`);
    console.log(`Cash-on-Cash Return: ${result.cashOnCashReturn?.toFixed(2) || 'N/A'}%`);

    // Manual verification
    const manualROI = result.totalCosts > 0 ? (result.netReturn / result.totalCosts) * 100 : 0;
    const manualCashOnCash = result.cashNeeded > 0 ? (result.netReturn / result.cashNeeded) * 100 : 0;

    console.log("\n=== MANUAL VERIFICATION ===");
    console.log(`Manual ROI: ${manualROI.toFixed(2)}% (Net Return / Total Costs)`);
    console.log(`Manual Cash-on-Cash: ${manualCashOnCash.toFixed(2)}% (Net Return / Cash Needed)`);

    // Test against your screenshot values
    console.log("\n=== COMPARISON TO SCREENSHOT ===");
    console.log(`Expected Net Return: $71,686`);
    console.log(`Expected ROI: 16.36% (corrected from 8.476%)`);
    console.log(`Actual ROI: ${result.netROI?.toFixed(2)}%`);

  } else {
    console.log("Strategy calculation returned null - property may not meet minimum criteria");
  }
} catch (error) {
  console.error("Error testing calculation:", error);
}
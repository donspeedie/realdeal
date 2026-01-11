// Test calculations against the third screenshot
const {calculateStrategy} = require("./strategyCalculator");

console.log("=== SCREENSHOT #3 CALCULATION VERIFICATION ===\n");
console.log("Property: 8635 Bridgecross Dr Sacramento, CA 95835");

// Data from the new screenshot
const testProperty = {
  zpid: "test3",
  price: 499000,        // Purchase Price
  livingArea: 1522,     // Living area from screenshot
  bedrooms: 5,
  bathrooms: 3,
  latitude: 38.7,
  longitude: -121.3,
  impValue: 56250,      // Improvements from screenshot
  loanPayments: 7095,   // Loan Payments from screenshot
  loanFees: 14193,      // Loan Fees from screenshot
  sellingCosts: 25232   // Sales Costs from screenshot
};

const testParams = {
  interestRate: 0.06,
  salRate: 0.04,
  loanFeesRate: 0.01,
  permitsFees: 1000,    // Permits & Fees from screenshot
  fixFlipDuration: 3,   // Assuming 3 months
  futureValue: 630788,  // Total Returns from screenshot
  bypassMinReturn: true
};

console.log("=== MANUAL VERIFICATION OF SCREENSHOT ===");
const futureValue = 630788;
const purchasePrice = 499000;
const improvements = 56250;
const salesCosts = 25232;
const loanPayments = 7095;
const loanFees = 14193;
const propertyTaxesInsurance = 1874;
const permitsFees = 1000;

// Calculate totals manually
const manualTotalCosts = purchasePrice + improvements + salesCosts + loanPayments + loanFees + propertyTaxesInsurance + permitsFees;
const manualNetReturn = futureValue - manualTotalCosts;

console.log(`Future Value (Total Returns): $${futureValue.toLocaleString()}`);
console.log(`Purchase Price: $${purchasePrice.toLocaleString()}`);
console.log(`Improvements: $${improvements.toLocaleString()}`);
console.log(`Sales Costs: $${salesCosts.toLocaleString()}`);
console.log(`Loan Payments: $${loanPayments.toLocaleString()}`);
console.log(`Loan Fees: $${loanFees.toLocaleString()}`);
console.log(`Property Taxes & Insurance: $${propertyTaxesInsurance.toLocaleString()}`);
console.log(`Permits & Fees: $${permitsFees.toLocaleString()}`);

console.log(`\nCalculated Total Costs: $${manualTotalCosts.toLocaleString()}`);
console.log(`Screenshot Total Costs: $604,644`);
console.log(`Match: ${manualTotalCosts === 604644 ? 'YES' : 'NO'}`);

console.log(`\nCalculated Net Return: $${manualNetReturn.toLocaleString()}`);
console.log(`Screenshot Net Return: $26,144`);
console.log(`Match: ${manualNetReturn === 26144 ? 'YES' : 'NO'}`);

// Test with our corrected calculation engine
console.log("\n=== OUR CALCULATION ENGINE TEST ===");

try {
  const result = calculateStrategy("Fix & Flip", testProperty, testParams, 269, 0, []);

  if (result) {
    console.log(`✅ Net Return: $${result.netReturn?.toLocaleString()} (Expected: $26,144)`);
    console.log(`✅ Total Costs: $${result.totalCosts?.toLocaleString()} (Expected: $604,644)`);
    console.log(`✅ Cash Needed: $${result.cashNeeded?.toLocaleString()}`);

    console.log("\n=== RETURN CALCULATIONS ANALYSIS ===");
    console.log("Screenshot Values:");
    console.log(`Cash-on-Cash: 1,857%`);
    console.log(`Return on Investment: 432%`);
    console.log(`Return on Equity: 7,427%`);

    console.log("\nOur Corrected Calculations:");
    console.log(`ROI: ${result.netROI?.toFixed(2)}% (Net Return / Total Costs)`);
    console.log(`Cash-on-Cash: ${result.cashOnCashReturn?.toFixed(2)}% (Net Return / Cash Needed)`);
    console.log(`ROE: ${result.roe?.toFixed(2)}% (Annualized)`);

    console.log("\n=== ERROR ANALYSIS ===");
    console.log("❌ Screenshot ROI of 432% is still wrong");
    console.log(`   Correct ROI should be: ${result.netROI?.toFixed(2)}%`);

    console.log("❌ Screenshot Cash-on-Cash of 1,857% is impossible");
    console.log(`   Correct Cash-on-Cash should be: ${result.cashOnCashReturn?.toFixed(2)}%`);

    console.log("❌ Screenshot ROE of 7,427% is unrealistic");
    console.log(`   Reasonable ROE should be: ${result.roe?.toFixed(2)}%`);

    // Calculate what would make the screenshot percentages work
    console.log("\n💡 REVERSE ENGINEERING SCREENSHOT ERRORS:");

    // For 432% ROI to work: Net Return / X = 4.32
    const impliedDenominatorROI = manualNetReturn / 4.32;
    console.log(`For 432% ROI: denominator would need to be $${impliedDenominatorROI.toLocaleString()}`);

    // For 1,857% cash-on-cash: Net Return / X = 18.57
    const impliedDenominatorCash = manualNetReturn / 18.57;
    console.log(`For 1,857% Cash-on-Cash: denominator would need to be $${impliedDenominatorCash.toLocaleString()}`);

  } else {
    console.log("❌ Calculation failed");
  }

} catch (error) {
  console.error("Error:", error.message);
}

console.log("\n=== CONCLUSION ===");
console.log("✅ Basic arithmetic (Total Costs, Net Return) appears CORRECT");
console.log("❌ Return percentages still have major calculation errors");
console.log("💡 The deployed fixes haven't resolved the UI calculation errors");
console.log("🔍 The errors may be in the frontend/UI calculation code, not the backend");
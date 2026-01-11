// Test calculations against the second screenshot
const {calculateStrategy} = require("./strategyCalculator");

// Data from the new screenshot
const testProperty = {
  zpid: "test456",
  price: 194000,        // Purchase Price
  livingArea: 912,      // Living area from screenshot
  bedrooms: 3,
  bathrooms: 2,
  latitude: 38.7,
  longitude: -121.3,
  impValue: 22800,      // Improvements from screenshot
  loanPayments: 2823,   // Loan Payments from screenshot
  loanFees: 5645,       // Loan Fees from screenshot
  sellingCosts: 10036   // Sales Costs from screenshot
};

const testParams = {
  interestRate: 0.06,
  salRate: 0.04,
  loanFeesRate: 0.01,
  permitsFees: 1000,    // Permits & Fees from screenshot
  fixFlipDuration: 3,   // 3 months from screenshot
  futureValue: 250891   // Total Returns from screenshot
};

console.log("=== SCREENSHOT 2 CALCULATION VERIFICATION ===\n");

try {
  const result = calculateStrategy("Fix & Flip", testProperty, testParams, 260, 0, []);

  if (result) {
    console.log("=== SCREENSHOT VALUES ===");
    console.log(`Total Returns: $250,891`);
    console.log(`Purchase Price: $194,000`);
    console.log(`Improvements: $22,800`);
    console.log(`Sales Costs: $10,036`);
    console.log(`Loan Payments: $2,823`);
    console.log(`Loan Fees: $5,645`);
    console.log(`Property Taxes & Insurance: $732`);
    console.log(`Permits & Fees: $1,000`);
    console.log(`Total Costs: $237,036`);
    console.log(`Net Return: $13,855`);

    console.log("\n=== OUR CALCULATED VALUES ===");
    console.log(`Future Value: $${result.futureValue?.toLocaleString()}`);
    console.log(`Total Costs: $${result.totalCosts?.toLocaleString()}`);
    console.log(`Net Return: $${result.netReturn?.toLocaleString()}`);
    console.log(`Cash Needed: $${result.cashNeeded?.toLocaleString()}`);

    console.log("\n=== MANUAL VERIFICATION OF SCREENSHOT ===");
    const manualTotalCosts = 194000 + 22800 + 10036 + 2823 + 5645 + 732 + 1000;
    const manualNetReturn = 250891 - manualTotalCosts;

    console.log(`Manual Total Costs: $${manualTotalCosts.toLocaleString()}`);
    console.log(`Manual Net Return: $${manualNetReturn.toLocaleString()}`);
    console.log(`Screenshot Total Costs: $237,036`);
    console.log(`Screenshot Net Return: $13,855`);
    console.log(`Costs Match: ${manualTotalCosts === 237036 ? 'YES' : 'NO'}`);
    console.log(`Net Return Match: ${manualNetReturn === 13855 ? 'YES' : 'NO'}`);

    console.log("\n=== RETURN CALCULATIONS FROM SCREENSHOT ===");

    // Cash-on-Cash Return calculation
    // Need to determine cash invested - likely down payment + improvements + fees
    const downPayment = result.downPayment || 0;
    const cashInvested = downPayment + 22800 + 1000 + 732; // Improvements + permits + taxes

    console.log(`Estimated Cash Invested: $${cashInvested.toLocaleString()}`);
    console.log(`Down Payment: $${downPayment.toLocaleString()}`);

    // Screenshot returns
    console.log("\nScreenshot Return Values:");
    console.log(`Cash-on-Cash: 28%`);
    console.log(`Return on Investment: 2,835%`);
    console.log(`Return on Equity: 2,615%`);

    // Our calculations
    const ourCashOnCash = cashInvested > 0 ? (13855 / cashInvested) * 100 : 0;
    const ourROI = (13855 / 237036) * 100;

    console.log("\nOur Calculated Returns:");
    console.log(`Our Cash-on-Cash: ${ourCashOnCash.toFixed(2)}%`);
    console.log(`Our ROI: ${ourROI.toFixed(2)}%`);
    console.log(`Our ROE: ${result.roe?.toFixed(2)}%`);

    console.log("\n=== ANALYSIS ===");
    console.log("⚠️  The screenshot shows ROI of 2,835% which seems unrealistic");
    console.log("⚠️  ROE of 2,615% also seems too high");
    console.log("💡 These may be calculation errors in the original system");
    console.log(`✅ Realistic ROI should be: ${ourROI.toFixed(2)}% (Net Return / Total Costs)`);

    // Check if cash-on-cash makes sense
    if (ourCashOnCash > 0 && ourCashOnCash < 100) {
      console.log(`✅ Cash-on-Cash of ${ourCashOnCash.toFixed(2)}% seems reasonable`);
    } else {
      console.log(`⚠️  Cash-on-Cash calculation may need review`);
    }

  } else {
    console.log("Strategy calculation returned null - property may not meet minimum criteria");
  }

} catch (error) {
  console.error("Error testing calculation:", error);
}
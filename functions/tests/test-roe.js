// Test ROE calculation specifically
const {calculateStrategy} = require("./strategyCalculator");

const testProperty = {
  zpid: "test123",
  price: 375000,
  livingArea: 1500,
  bedrooms: 3,
  bathrooms: 2,
  latitude: 37.123,
  longitude: -122.456,
  impValue: 18000,
  loanPayments: 10614,
  loanFees: 10611,
  sellingCosts: 20398
};

const testParams = {
  interestRate: 0.06,
  salRate: 0.04,
  loanFeesRate: 0.01,
  permitsFees: 1000,
  fixFlipDuration: 3,
  futureValue: 509962
};

console.log("=== ROE CALCULATION ANALYSIS ===\n");

const result = calculateStrategy("Fix & Flip", testProperty, testParams, 250, 0, []);

if (result) {
  console.log("INPUTS FOR ROE CALCULATION:");
  console.log(`Future Value: $${result.futureValue?.toLocaleString()}`);
  console.log(`Purchase Price: $${testProperty.price?.toLocaleString()}`);
  console.log(`Improvements: $${testProperty.impValue?.toLocaleString()}`);
  console.log(`Selling Costs: $${result.sellingCosts?.toLocaleString()}`);
  console.log(`Permits & Fees: $${testParams.permitsFees?.toLocaleString()}`);
  console.log(`Property Taxes: $${result.propertyTaxes?.toLocaleString()}`);
  console.log(`Property Insurance: $${result.propertyIns?.toLocaleString()}`);
  console.log(`Loan Payments: $${result.loanPayments?.toLocaleString()}`);
  console.log(`Loan Fees: $${result.loanFees?.toLocaleString()}`);
  console.log(`Down Payment: $${result.downPayment?.toLocaleString()}`);

  console.log("\n=== ROE FORMULA BREAKDOWN ===");

  // Manual ROE calculation following the code
  const netIncomeAfterFinancing = Number(result.futureValue) - Number(result.sellingCosts) - Number(testProperty.price) -
    Number(testProperty.impValue) - Number(testParams.permitsFees) - Number(result.propertyTaxes) -
    Number(result.propertyIns) - Number(result.loanPayments) - Number(result.loanFees);

  const totalEquityInvested = Number(result.downPayment) + Number(testProperty.impValue) +
    Number(testParams.permitsFees) + Number(result.propertyTaxes);

  const manualROE = totalEquityInvested > 0 ? (netIncomeAfterFinancing / totalEquityInvested) * 100 : 0;

  console.log("Net Income After Financing:");
  console.log(`  = Future Value - Selling Costs - Purchase Price - Improvements`);
  console.log(`    - Permits/Fees - Property Taxes - Property Insurance`);
  console.log(`    - Loan Payments - Loan Fees`);
  console.log(`  = $${result.futureValue?.toLocaleString()} - $${result.sellingCosts?.toLocaleString()} - $${testProperty.price?.toLocaleString()} - $${testProperty.impValue?.toLocaleString()}`);
  console.log(`    - $${testParams.permitsFees?.toLocaleString()} - $${result.propertyTaxes?.toLocaleString()} - $${result.propertyIns?.toLocaleString()}`);
  console.log(`    - $${result.loanPayments?.toLocaleString()} - $${result.loanFees?.toLocaleString()}`);
  console.log(`  = $${netIncomeAfterFinancing?.toLocaleString()}`);

  console.log("\nTotal Equity Invested:");
  console.log(`  = Down Payment + Improvements + Permits/Fees + Property Taxes`);
  console.log(`  = $${result.downPayment?.toLocaleString()} + $${testProperty.impValue?.toLocaleString()} + $${testParams.permitsFees?.toLocaleString()} + $${result.propertyTaxes?.toLocaleString()}`);
  console.log(`  = $${totalEquityInvested?.toLocaleString()}`);

  console.log("\nROE Calculation:");
  console.log(`  = (Net Income After Financing / Total Equity Invested) × 100`);
  console.log(`  = ($${netIncomeAfterFinancing?.toLocaleString()} ÷ $${totalEquityInvested?.toLocaleString()}) × 100`);
  console.log(`  = ${manualROE?.toFixed(2)}%`);

  console.log("\n=== COMPARISON ===");
  console.log(`Calculated ROE: ${result.roe?.toFixed(2)}%`);
  console.log(`Manual ROE: ${manualROE?.toFixed(2)}%`);
  console.log(`Match: ${Math.abs(result.roe - manualROE) < 0.01 ? 'YES' : 'NO'}`);

  // Check if ROE makes sense
  console.log("\n=== ROE ANALYSIS ===");
  if (result.roe > 100) {
    console.log("⚠️  ROE > 100% - Very high return, verify calculation");
  } else if (result.roe > 50) {
    console.log("✅ ROE > 50% - Excellent return");
  } else if (result.roe > 20) {
    console.log("✅ ROE > 20% - Good return");
  } else if (result.roe > 10) {
    console.log("✅ ROE > 10% - Moderate return");
  } else if (result.roe > 0) {
    console.log("⚠️  ROE < 10% - Low return");
  } else {
    console.log("❌ ROE ≤ 0% - Negative return");
  }

} else {
  console.log("Strategy calculation returned null");
}
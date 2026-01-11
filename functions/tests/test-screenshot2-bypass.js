// Test calculations with minimum return filter bypassed
const {calculateStrategy} = require("./strategyCalculator");

// Temporarily modify the minimum return requirement by overriding it
console.log("=== MANUAL CALCULATION VERIFICATION (Bypassing Filters) ===\n");

// Manual calculation based on screenshot values
const futureValue = 250891;
const purchasePrice = 194000;
const improvements = 22800;
const salesCosts = 10036;
const loanPayments = 2823;
const loanFees = 5645;
const propertyTaxesInsurance = 732;
const permitsFees = 1000;

// Calculate totals manually
const totalCosts = purchasePrice + improvements + salesCosts + loanPayments + loanFees + propertyTaxesInsurance + permitsFees;
const netReturn = futureValue - totalCosts;

console.log("=== MANUAL VERIFICATION OF SCREENSHOT ===");
console.log(`Future Value (Total Returns): $${futureValue.toLocaleString()}`);
console.log(`Purchase Price: $${purchasePrice.toLocaleString()}`);
console.log(`Improvements: $${improvements.toLocaleString()}`);
console.log(`Sales Costs: $${salesCosts.toLocaleString()}`);
console.log(`Loan Payments: $${loanPayments.toLocaleString()}`);
console.log(`Loan Fees: $${loanFees.toLocaleString()}`);
console.log(`Property Taxes & Insurance: $${propertyTaxesInsurance.toLocaleString()}`);
console.log(`Permits & Fees: $${permitsFees.toLocaleString()}`);

console.log(`\nCalculated Total Costs: $${totalCosts.toLocaleString()}`);
console.log(`Screenshot Total Costs: $237,036`);
console.log(`Match: ${totalCosts === 237036 ? 'YES' : 'NO'}`);

console.log(`\nCalculated Net Return: $${netReturn.toLocaleString()}`);
console.log(`Screenshot Net Return: $13,855`);
console.log(`Match: ${netReturn === 13855 ? 'YES' : 'NO'}`);

console.log("\n=== RETURN PERCENTAGE ANALYSIS ===");

// Estimate cash needed (down payment would be ~20% of purchase + improvements + fees)
const estimatedDownPayment = (purchasePrice + improvements) * 0.2; // 20% down
const cashNeeded = estimatedDownPayment + permitsFees + propertyTaxesInsurance;

console.log(`Estimated Down Payment (20%): $${estimatedDownPayment.toLocaleString()}`);
console.log(`Estimated Cash Needed: $${cashNeeded.toLocaleString()}`);

// Calculate realistic returns
const realisticROI = (netReturn / totalCosts) * 100;
const realisticCashOnCash = (netReturn / cashNeeded) * 100;

console.log("\n=== REALISTIC RETURN CALCULATIONS ===");
console.log(`ROI (Net Return / Total Costs): ${realisticROI.toFixed(2)}%`);
console.log(`Cash-on-Cash (Net Return / Cash Needed): ${realisticCashOnCash.toFixed(2)}%`);

console.log("\n=== SCREENSHOT RETURN ANALYSIS ===");
console.log(`Screenshot Cash-on-Cash: 28%`);
console.log(`Screenshot ROI: 2,835%`);
console.log(`Screenshot ROE: 2,615%`);

console.log("\n=== ISSUES IDENTIFIED ===");
console.log("❌ ROI of 2,835% is mathematically impossible");
console.log("   - This would mean 28x return on investment");
console.log("   - Realistic ROI should be ~5.84%");

console.log("❌ ROE of 2,615% is also unrealistic");
console.log("   - This would mean 26x return on equity");

console.log("⚠️  Cash-on-Cash of 28% might be plausible if cash invested is very low");

// Check what would make 28% cash-on-cash work
const requiredCashFor28Percent = netReturn / 0.28;
console.log(`\n💡 For 28% cash-on-cash to be correct:`);
console.log(`   Cash needed would be: $${requiredCashFor28Percent.toLocaleString()}`);
console.log(`   This seems high compared to typical down payments`);

// Check what cash amount would make sense
const notesValue = 188168; // From the "Notes" column for Loan Payments
console.log(`\n💡 If the Notes value (188,168) represents something else:`);
const cashOnCashWithNotes = (netReturn / notesValue) * 100;
console.log(`   Cash-on-Cash would be: ${cashOnCashWithNotes.toFixed(2)}%`);

console.log("\n=== CONCLUSION ===");
console.log("✅ Basic arithmetic (Total Costs, Net Return) is CORRECT");
console.log("❌ Return percentages (ROI, ROE) appear to have calculation errors");
console.log("⚠️  Cash-on-Cash may be correct depending on actual cash invested");
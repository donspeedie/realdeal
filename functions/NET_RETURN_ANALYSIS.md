# Net Return Calculation - Complete Breakdown

## Overview
This document provides a step-by-step breakdown of how `netReturn` is calculated for each strategy, with special attention to rates that may be California-specific.

---

## Base Configuration Rates (All Strategies)

### Located at: `strategyCalculator.js:414-421`

```javascript
const base = {
  mtgRate: Number(params.interestRate) || 0.06,      // 6% annual interest
  salRate: Number(params.salRate) || 0.04,           // 4% selling costs
  loanFeesRate: Number(params.loanFeesRate) || 0.01, // 1% loan fees
  permitsFees: Number(params.permitsFees) || 1000,   // $1,000 permits
  annualTaxRate: 0.01,                                // 1% annual property tax ⚠️ CALIFORNIA-SPECIFIC
  annualInsRate: 0.0035,                              // 0.35% annual insurance
};
```

### ⚠️ **California-Specific Rates Identified:**

1. **annualTaxRate: 0.01 (1%)** - This is California's Proposition 13 rate
   - **National Average**: 1.1% - 1.2%
   - **Other States**:
     - Texas: 1.8% - 2.0%
     - New Jersey: 2.4%
     - Florida: 0.9% - 1.0%
     - **Recommendation**: Make this configurable by state

2. **annualInsRate: 0.0035 (0.35%)** - Reasonable for California
   - **Varies by state**:
     - Florida (hurricane risk): 0.5% - 1.5%
     - Oklahoma/Kansas (tornado): 0.5% - 0.8%
     - **Recommendation**: Consider making configurable for disaster-prone areas

---

## Common Calculation Components

### 1. Loan Calculation (strategyCalculator.js:714-740)

All strategies use this loan calculation:

```javascript
// Loan to Cost (LTC): 90% of purchase + improvement costs
const totalProjectCost = purchasePrice + impValue;
const maxLtcLoan = totalProjectCost * 0.90;

// Loan to ARV: 75% of future value
const maxArvLoan = futureValue * 0.75;

// Take the lesser of the two
const loanAmount = Math.min(maxLtcLoan, maxArvLoan);
const downPayment = totalProjectCost - loanAmount;

// Interest-only payments (not amortizing)
const monthlyPayment = loanAmount * (mtgRate / 12);
const loanPayments = monthlyPayment * duration; // Duration in months

// Additional costs
const loanFees = Math.min(loanAmount * 0.01, 20000); // Capped at $20k
const propertyTaxes = totalProjectCost * 0.01 * (duration / 12);
const propertyIns = totalProjectCost * 0.0035 * (duration / 12);
```

### 2. Total Costs Formula (strategyCalculator.js:742-755)

```javascript
totalCosts = purchasePrice +
             impValue +
             loanPayments +
             loanFees +
             permitsFees +
             propertyTaxes +
             propertyIns +
             sellingCosts;
```

---

## Strategy-Specific Calculations

## 1. FIX & FLIP Strategy

### Configuration (strategyCalculator.js:424-431)
```javascript
"Fix & Flip": {
  duration: 3 months (default),
  impFactor: 1.08,        // 8% appreciation factor
  rate: 25,               // $25/sqft renovation cost ⚠️ CALIFORNIA-SPECIFIC
  areaMult: 1,            // No area change
  extraValue: 0,
}
```

### Improvement Cost Calculation
```javascript
impValue = futureArea * 25; // $25/sqft
```

### ⚠️ **California-Specific: Construction Rate**
- **$25/sqft** is LOW even for cosmetic flips
- **California Average**: $50-100/sqft for light renovation
- **National Average**: $20-50/sqft
- **Recommendation**: Increase to $40-50/sqft minimum for CA

### Net Return Calculation (strategyCalculator.js:304)
```javascript
netReturn = futureValue - totalCosts;

// Where totalCosts includes:
// - purchasePrice
// - impValue (futureArea * $25/sqft)
// - loanPayments (3 months interest-only)
// - loanFees (1% of loan, max $20k)
// - permitsFees ($1,000)
// - propertyTaxes (1% annual * 3/12 months)
// - propertyIns (0.35% annual * 3/12 months)
// - sellingCosts (4% of futureValue)
```

### Example Calculation:
```
Property Price: $500,000
Living Area: 1,500 sqft
Future Value: $600,000 (based on comps)

Improvement Cost: 1,500 × $25 = $37,500
Total Project Cost: $500,000 + $37,500 = $537,500

Loan Amount: min(90% LTC, 75% ARV) = min($483,750, $450,000) = $450,000
Down Payment: $537,500 - $450,000 = $87,500
Monthly Payment: $450,000 × (0.06/12) = $2,250
Loan Payments (3 mo): $2,250 × 3 = $6,750

Loan Fees: $450,000 × 0.01 = $4,500
Property Taxes: $537,500 × 0.01 × (3/12) = $1,344
Property Insurance: $537,500 × 0.0035 × (3/12) = $470
Permits: $1,000
Selling Costs: $600,000 × 0.04 = $24,000

Total Costs: $500,000 + $37,500 + $6,750 + $4,500 + $1,000 + $1,344 + $470 + $24,000 = $575,564

Net Return: $600,000 - $575,564 = $24,436
```

---

## 2. ADD-ON Strategy (Bedroom Addition)

### Configuration (strategyCalculator.js:433-440)
```javascript
"Add-On": {
  duration: 6 months (default),
  impFactor: 1.0,         // No appreciation factor
  rate: 150,              // $150/sqft construction cost ⚠️ CALIFORNIA-SPECIFIC
  addOnArea: 120,         // 120 sqft bedroom addition
  areaMult: 1.2,          // Not used directly
  extraValue: oneBdrmMarketValue,
}
```

### Improvement Cost Calculation
```javascript
impValue = addOnArea * 150; // 120 × $150 = $18,000
```

### ⚠️ **California-Specific: Construction Rate**
- **$150/sqft** is VERY LOW for California
- **California Average**: $200-350/sqft for room addition
- **National Average**: $150-250/sqft
- **Recommendation**: Increase to $250/sqft minimum for CA, $300+ for Bay Area/LA

### Net Return Calculation
```javascript
netReturn = futureValue - totalCosts;

// Where totalCosts includes:
// - purchasePrice
// - impValue (120 sqft × $150/sqft = $18,000)
// - loanPayments (6 months interest-only)
// - loanFees (1% of loan, max $20k)
// - permitsFees ($1,000) ⚠️ TOO LOW
// - propertyTaxes (1% annual × 6/12 months)
// - propertyIns (0.35% annual × 6/12 months)
// - sellingCosts (4% of futureValue)
```

### ⚠️ **Additional California Issues:**
- **Permits**: $1,000 is too low for CA bedroom addition
  - **California Reality**: $3,000-$10,000 for permits + inspections
  - **Recommendation**: $5,000 minimum for CA

### Example Calculation:
```
Property Price: $600,000
Current: 3BR, 1,500 sqft
After Addition: 4BR, 1,620 sqft
Future Value: $650,000 (based on 4BR comps)

Improvement Cost: 120 × $150 = $18,000 ⚠️ UNREALISTIC
Total Project Cost: $600,000 + $18,000 = $618,000

Loan Amount: min($556,200, $487,500) = $487,500
Down Payment: $618,000 - $487,500 = $130,500
Monthly Payment: $487,500 × 0.005 = $2,438
Loan Payments (6 mo): $2,438 × 6 = $14,625

Loan Fees: $4,875
Property Taxes: $3,090
Property Insurance: $1,082
Permits: $1,000 ⚠️ UNREALISTIC
Selling Costs: $26,000

Total Costs: $600,000 + $18,000 + $14,625 + $4,875 + $1,000 + $3,090 + $1,082 + $26,000 = $668,672

Net Return: $650,000 - $668,672 = -$18,672 ❌ LOSS!

REALISTIC CA COSTS:
Improvement: 120 × $250 = $30,000
Permits: $5,000
Revised Total: $700,672
Net Return: $650,000 - $700,672 = -$50,672 ❌ EVEN WORSE
```

---

## 3. ADU Strategy

### Configuration (strategyCalculator.js:442-450)
```javascript
"ADU": {
  duration: 9 months (default),
  rate: 200,              // Not used directly
  aduArea: 750,           // 750 sqft ADU
  aduImpRate: 300,        // $300/sqft construction cost ⚠️ CALIFORNIA-SPECIFIC
  impFactor: 1.0,         // No appreciation factor
  areaMult: 1.5,          // Not used directly
  extraValue: twoBedAvg,  // Average 2BR comp value
}
```

### Improvement Cost Calculation
```javascript
impValue = aduImpRate * 750; // $300 × 750 = $225,000
```

### ⚠️ **California-Specific: ADU Construction Rate**
- **$300/sqft** is REASONABLE for California ADU construction
- **California Average**: $300-450/sqft for ADU
- **National Average**: $200-350/sqft
- **Recommendation**: This rate is appropriate for CA, but consider regional adjustments:
  - Bay Area/LA: $350-450/sqft
  - Sacramento/Inland Empire: $300-350/sqft

### ADU-Specific Calculations

#### Main House Value (strategyCalculator.js:607-609)
```javascript
const redfinEstimate = subjectProperty.zestimate || subjectProperty.price;
const mainHouseValue = redfinEstimate * 0.95;
```

#### ADU Income Valuation (strategyCalculator.js:1370-1455)

**Rent Estimation Priority:**
1. Average rentZestimate from 2BR comps
2. Subject property rentZestimate (if 2BR)
3. **Fallback**: 0.6% rule (avgTwoBedPrice × 0.006) ⚠️ CALIFORNIA-SPECIFIC

**⚠️ California Rent Fallback:**
- **0.6% rule** is CONSERVATIVE for California
- **California Reality**: 0.4% - 0.6% (due to high prices)
- **National Average**: 0.8% - 1.0%
- **Recommendation**: 0.6% is appropriate for CA, too high for other states

#### ADU Value Calculation (strategyCalculator.js:1440-1454)
```javascript
const aduGrossScheduledIncomeAnnual = twoBedRentZestimate * 12;
const vacancyRate = 0.05;  // 5% vacancy
const expenseRatio = 0.25;  // 25% expenses ⚠️ CALIFORNIA-SPECIFIC

const aduVacancyAnnual = grossIncome * 0.05;
const aduEffectiveGrossIncome = grossIncome - vacancy;
const aduOperatingExpenses = effectiveGrossIncome * 0.25;
const aduNOIAnnual = effectiveGrossIncome - operatingExpenses;

const aduIncomeValue = aduNOIAnnual / capRate;
```

**⚠️ California-Specific: Expense Ratio**
- **25% expense ratio** is LOW for California
- **California Reality**: 30-40% (higher maintenance, utilities)
- **National Average**: 25-35%
- **Recommendation**: Increase to 35% for CA

#### Cap Rate Calculation (strategyCalculator.js:1485-1497)
```javascript
// Based on property value ⚠️ CALIFORNIA-SPECIFIC
if (propertyValue >= $1,500,000) capRate = 0.04;  // 4%
if (propertyValue >= $1,000,000) capRate = 0.045; // 4.5%
if (propertyValue >= $700,000) capRate = 0.05;     // 5%
if (propertyValue >= $500,000) capRate = 0.055;    // 5.5%
else capRate = 0.06;                               // 6%
```

**⚠️ California-Specific: Cap Rates**
- These cap rates are APPROPRIATE for California (compressed market)
- **Other States**: Typically 6-10% cap rates
- **Recommendation**:
  - California: 4-6% (current)
  - Texas/Midwest: 7-10%
  - Florida: 5-8%

### Net Return Calculation
```javascript
netReturn = futureValue - totalCosts;

// Where futureValue is:
futureValue = min(
  (mainHouseValue + aduIncomeValue) * 1.0,
  redfinEstimate * 0.95 + twoBedAvgValue
);

// And totalCosts includes:
// - purchasePrice
// - impValue ($300/sqft × 750 = $225,000)
// - loanPayments (9 months interest-only)
// - loanFees (1% of loan, max $20k)
// - permitsFees ($1,000) ⚠️ WAY TOO LOW
// - propertyTaxes (1% annual × 9/12 months)
// - propertyIns (0.35% annual × 9/12 months)
// - sellingCosts (4% of futureValue)
```

### ⚠️ **Critical California Issue: ADU Permits**
- **$1,000 is UNREALISTIC** for California ADU permits
- **California Reality**: $10,000-$30,000 for ADU permits, impact fees, utility connections
- **Recommendation**: $15,000 minimum, $25,000 for larger cities

### Example Calculation:
```
Property Price: $800,000
Main House: 1,800 sqft, 3BR
Redfin Estimate: $800,000

Main House Value: $800,000 × 0.95 = $760,000

2BR Rent from Comps: $2,500/mo
ADU Gross Income: $2,500 × 12 = $30,000
Vacancy (5%): $1,500
Effective Income: $28,500
Operating Expenses (25%): $7,125 ⚠️ LOW
ADU NOI: $21,375
Cap Rate: 5% (for $800k property)
ADU Income Value: $21,375 / 0.05 = $427,500

Future Value: min(
  ($760,000 + $427,500) × 1.0 = $1,187,500,
  $760,000 + $450,000 (2BR avg) = $1,210,000
) = $1,187,500

Improvement Cost: $300 × 750 = $225,000
Total Project Cost: $800,000 + $225,000 = $1,025,000

Loan Amount: min($922,500, $890,625) = $890,625
Down Payment: $134,375
Monthly Payment: $4,453
Loan Payments (9 mo): $40,078

Loan Fees: $8,906
Property Taxes: $7,688
Property Insurance: $2,690
Permits: $1,000 ⚠️ UNREALISTIC - should be $15,000+
Selling Costs: $47,500

Total Costs (with $1k permits): $1,133,862
Net Return: $1,187,500 - $1,133,862 = $53,638

REALISTIC CA COSTS:
Permits: $15,000 (instead of $1,000)
Expense Ratio: 35% (instead of 25%)
Revised ADU Value: $21,375 / 0.05 = $390,000 (lower NOI)
Revised Future Value: $1,150,000
Revised Total Costs: $1,147,862
Net Return: $1,150,000 - $1,147,862 = $2,138 (minimal profit)
```

---

## 4. NEW BUILD Strategy

### Configuration (strategyCalculator.js:452-458)
```javascript
"New Build": {
  duration: 12 months (default),
  rate: 180,              // $180/sqft construction cost ⚠️ CALIFORNIA-SPECIFIC
  impFactor: 1.25,        // 25% appreciation factor
  areaMult: 1.3,          // 30% larger than original
  extraValue: 0,
}
```

### Improvement Cost Calculation
```javascript
const futureLivingArea = baseArea * 1.3; // 30% larger
impValue = futureLivingArea * 180; // $180/sqft
```

### ⚠️ **California-Specific: New Construction Rate**
- **$180/sqft** is VERY LOW for California new construction
- **California Average**: $250-400/sqft for new construction
- **National Average**: $150-250/sqft
- **Recommendation**:
  - California: $300/sqft minimum
  - Bay Area/LA: $350-450/sqft
  - Inland areas: $250-300/sqft

### Net Return Calculation
```javascript
netReturn = futureValue - totalCosts;

// Where totalCosts includes:
// - purchasePrice (land/teardown)
// - impValue (futureArea × $180/sqft) ⚠️ TOO LOW
// - loanPayments (12 months interest-only)
// - loanFees (1% of loan, max $20k)
// - permitsFees ($1,000) ⚠️ WAY TOO LOW
// - propertyTaxes (1% annual × 12/12 months)
// - propertyIns (0.35% annual × 12/12 months)
// - sellingCosts (4% of futureValue)
```

### ⚠️ **Critical California Issues:**
1. **Construction Cost**: $180/sqft is 40-50% too low
2. **Permits**: $1,000 is absurdly low for new construction
   - **California Reality**: $50,000-$150,000 for permits, impact fees, school fees
   - **Recommendation**: $75,000 minimum

### Example Calculation:
```
Property Price: $500,000 (teardown on land)
Original: 1,200 sqft
Future: 1,560 sqft (30% larger)
Future Value: $950,000 (based on comps × 1.25 impFactor)

Improvement Cost: 1,560 × $180 = $280,800 ⚠️ TOO LOW
Total Project Cost: $500,000 + $280,800 = $780,800

Loan Amount: min($702,720, $712,500) = $702,720
Down Payment: $78,080
Monthly Payment: $3,514
Loan Payments (12 mo): $42,163

Loan Fees: $7,027
Property Taxes: $7,808
Property Insurance: $2,733
Permits: $1,000 ⚠️ UNREALISTIC
Selling Costs: $38,000

Total Costs: $879,531
Net Return: $950,000 - $879,531 = $70,469

REALISTIC CA COSTS:
Construction: 1,560 × $300 = $468,000
Permits: $75,000
Total Project: $500,000 + $468,000 = $968,000
Revised Loan: min($871,200, $712,500) = $712,500
Revised costs add ~$260,000
Total Costs: $1,139,531
Net Return: $950,000 - $1,139,531 = -$189,531 ❌ MAJOR LOSS!
```

---

## 5. RENTAL Strategy

### Configuration (strategyCalculator.js:460-473)
```javascript
"Rental": {
  duration: 12 months,
  impFactor: 1.0,
  rate: 0,                // No improvements
  areaMult: 1,
  extraValue: 0,

  // Rental-specific rates:
  maintenanceRate: 0.005,              // 0.5% of property value ⚠️ CALIFORNIA-SPECIFIC
  operatingExpenseRate: 0.0025,        // 0.25% of property value ⚠️ CALIFORNIA-SPECIFIC
  propertyManagementFeeRate: 0.0,      // 0% (self-managed)
  utilities: 150,                       // $150/month ⚠️ CALIFORNIA-SPECIFIC
  vacancyRate: 0.05,                   // 5% of rental income
}
```

### ⚠️ **California-Specific: Rental Operating Rates**

1. **Maintenance Rate: 0.5%** - LOW for California
   - **California Average**: 1.0-1.5% (older housing stock, higher labor costs)
   - **National Average**: 0.5-1.0%
   - **Recommendation**: 1.0% minimum for CA

2. **Operating Expense Rate: 0.25%** - VERY LOW for California
   - **California Average**: 0.5-1.0% (HOA, utilities, misc)
   - **National Average**: 0.25-0.5%
   - **Recommendation**: 0.5% for CA

3. **Utilities: $150/month** - REASONABLE for California
   - **Varies by region**: $100-250/month
   - **Recommendation**: Keep current, but consider regional adjustments

4. **Vacancy Rate: 5%** - OPTIMISTIC for California
   - **California Average**: 5-10% depending on market
   - **National Average**: 5-8%
   - **Recommendation**: Consider 7% for more conservative estimates

### Rental Net Return Calculation (strategyCalculator.js:166)

**5-Year Hold Period:**

```javascript
// Step 1: Calculate Annual Cash Flow
annualRent = monthlyRent * 12;
annualMaintenance = futureValue * 0.005;  // 0.5%
annualOperatingExpenses = futureValue * 0.0025;  // 0.25%
annualPropertyManagement = annualRent * 0.0;  // 0% (self-managed)
annualUtilities = 150 * 12 = $1,800;
annualVacancy = annualRent * 0.05;  // 5%

annualNOI = annualRent - (maintenance + operating + management + utilities + vacancy + taxes + insurance);

annualLoanPayments = monthlyPayment * 12;
annualCashFlow = annualNOI - annualLoanPayments;

// Step 2: Calculate 5-Year Returns
netRentalIncomeFiveYears = annualCashFlow * 5;
resaleValue = futureValue; // After Repair Value
netSaleProceeds = netRentalIncomeFiveYears + resaleValue;

// Step 3: Calculate Total Costs (includes future selling costs)
appreciationRate = 0.035;  // 3.5% annual ⚠️ CALIFORNIA-SPECIFIC
futureResaleValue = futureValue * (1.035 ^ 5);
sellingCostsAtResale = futureResaleValue * 0.04;

totalCosts = purchasePrice +
             impValue +
             loanPayments (12 months) +
             loanFees +
             permitsFees +
             propertyTaxes +
             propertyIns +
             sellingCostsAtResale;

// Step 4: Calculate Net Return
netReturn = netSaleProceeds - totalCosts;
```

### ⚠️ **California-Specific: Appreciation Rate**
- **3.5% annual appreciation** is OPTIMISTIC
- **California Historical**: 3-6% (highly variable)
- **National Average**: 3-4%
- **Recommendation**: Consider 3% for conservative estimates, or make it user-configurable

### Rent Estimation Fallback (strategyCalculator.js:478-481)
```javascript
// If no rentZestimate available, use 0.95% rule
estimateMonthlyRent = propertyValue * 0.0095;  // 0.95% ⚠️ CALIFORNIA-SPECIFIC
```

### ⚠️ **California-Specific: Rent Estimation**
- **0.95% rule** is TOO HIGH for California
- **California Reality**: 0.4-0.6% (due to high property values)
- **National Average**: 0.8-1.2%
- **Recommendation**: 0.5% for CA, keep 1.0% for other states

### Example Calculation:
```
Property Price: $600,000
Future Value: $600,000 (no improvements)
Monthly Rent: $2,850 (rentZestimate)

Annual Rent: $2,850 × 12 = $34,200
Annual Maintenance: $600,000 × 0.005 = $3,000 ⚠️ LOW
Annual Operating: $600,000 × 0.0025 = $1,500 ⚠️ LOW
Annual Management: $0 (self-managed)
Annual Utilities: $1,800
Annual Vacancy: $34,200 × 0.05 = $1,710
Property Taxes (annual): $6,000
Property Insurance (annual): $2,100

Annual NOI: $34,200 - $3,000 - $1,500 - $0 - $1,800 - $1,710 - $6,000 - $2,100 = $18,090

Loan Amount: min($540,000, $450,000) = $450,000
Monthly Payment: $2,250
Annual Loan Payments: $27,000

Annual Cash Flow: $18,090 - $27,000 = -$8,910 ❌ NEGATIVE!
5-Year Cash Flow: -$8,910 × 5 = -$44,550

Future Resale Value: $600,000 × (1.035^5) = $713,476
Selling Costs: $713,476 × 0.04 = $28,539

Net Sale Proceeds: -$44,550 + $600,000 = $555,450

Total Costs: $600,000 + $0 + $27,000 + $4,500 + $1,000 + $6,000 + $2,100 + $28,539 = $669,139

Net Return: $555,450 - $669,139 = -$113,689 ❌ MAJOR LOSS!

REALISTIC CA COSTS:
Maintenance: 1.0% → $6,000
Operating: 0.5% → $3,000
Vacancy: 7% → $2,394
Revised Annual NOI: $11,796
Revised Annual Cash Flow: -$15,204
5-Year Cash Flow: -$76,020
Net Return: -$189,709 ❌ EVEN WORSE!
```

---

## Summary of California-Specific Rates

### ✅ **Rates That Are Appropriate for California:**

1. **Property Tax Rate: 1.0%** - Correct for CA (Prop 13)
2. **ADU Construction: $300/sqft** - Reasonable for CA
3. **ADU Rent Fallback: 0.6% rule** - Appropriate for CA's high prices
4. **Cap Rates: 4-6%** - Correct for CA's compressed market
5. **Utilities: $150/month** - Reasonable

### ⚠️ **Rates That Need Adjustment for California:**

1. **Fix & Flip Construction: $25/sqft** → Should be $40-50/sqft
2. **Add-On Construction: $150/sqft** → Should be $250-300/sqft
3. **New Build Construction: $180/sqft** → Should be $300-350/sqft
4. **Add-On Permits: $1,000** → Should be $5,000-10,000
5. **ADU Permits: $1,000** → Should be $15,000-25,000
6. **New Build Permits: $1,000** → Should be $50,000-100,000
7. **Rental Maintenance: 0.5%** → Should be 1.0%
8. **Rental Operating: 0.25%** → Should be 0.5%
9. **Rental Vacancy: 5%** → Consider 7%
10. **Rental Rent Fallback: 0.95%** → Should be 0.5%
11. **Appreciation Rate: 3.5%** → Consider 3.0%
12. **ADU Expense Ratio: 25%** → Should be 30-35%

### ⚠️ **Rates That Need State/Region Configuration:**

1. **Property Tax Rate: 1.0%** - Varies 0.3% to 2.5% by state
2. **Insurance Rate: 0.35%** - Higher in disaster-prone areas
3. **Construction Costs** - All vary significantly by region
4. **Cap Rates** - Vary by market (4-10%)
5. **Rent-to-Price Ratios** - Vary by market (0.4%-1.2%)

---

## Recommendations

1. **Immediate Fixes for California:**
   - Increase all construction rates by 50-100%
   - Increase permit fees to realistic levels
   - Adjust rental operating expense rates upward

2. **Make Rates Configurable:**
   - Create regional rate profiles (CA, TX, FL, etc.)
   - Allow users to override default rates
   - Store rates in database by zip code or county

3. **Add Rate Validation:**
   - Warn users when rates seem unrealistic for their market
   - Provide rate guidance based on location
   - Show rate comparisons vs. market averages

4. **Documentation:**
   - Clearly label which rates are California-specific
   - Provide rate guidance for other markets
   - Create a rate configuration guide for users

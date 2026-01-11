const {round} = Math;

// Helper function to ensure integer return
function ensureInt(value) {
  return round(Number(value) || 0);
}

// Helper function to ensure double return
function ensureDouble(value) {
  return Number(value) || 0.0;
}

function calculateStrategy(method, prop, params, pricePerSqFt, twoBedAvg, bedroomAnalysis = []) {
  try {
    console.log(`\n🔨 === CALCULATING ${method} STRATEGY for ${prop.zpid} ===`);

    const purchasePrice = round(Number(prop?.price || 0));
    const livingArea = round(Number(prop?.livingArea || 0));
    const bedrooms = round(Number(prop?.bedrooms || 0));
    const safePricePerSqFt = Number(pricePerSqFt) || 250;
    const safeTwoBedAvg = Number(twoBedAvg) || 0;

    console.log(`📍 Property Details:`, {
      zpid: prop.zpid,
      price: purchasePrice,
      livingArea: livingArea,
      bedrooms: bedrooms,
      pricePerSqFt: safePricePerSqFt
    });

    const config = getConfig(method, params, safeTwoBedAvg);
    if (!config) throw new Error(`Invalid strategy method: ${method}`);

    console.log(`⚙️ Config for ${method}:`, {
      duration: config.duration,
      impFactor: config.impFactor,
      rate: config.rate,
      addOnArea: config.addOnArea,
      permitsFees: config.permitsFees,
      salRate: config.salRate
    });

    const futureLivingArea = calculateFutureLivingArea(method, livingArea, config);
    console.log(`📐 Future Living Area: ${livingArea} → ${futureLivingArea} sqft`);

    // Override support: Use prop.futureValue or params.futureValue if provided
    let futureValue;
    if (typeof prop.futureValue !== "undefined" && prop.futureValue !== null) {
      futureValue = Number(prop.futureValue);
      console.log(`🔧 Using OVERRIDE futureValue from prop: $${futureValue}`);
    } else if (typeof params.futureValue !== "undefined" && params.futureValue !== null) {
      futureValue = Number(params.futureValue);
      console.log(`🔧 Using OVERRIDE futureValue from params: $${futureValue}`);
    } else {
      console.log(`💰 Calculating futureValue for ${method}...`);
      futureValue = estimateFutureValue(
          method, futureLivingArea, safePricePerSqFt, config, bedrooms,
          bedroomAnalysis, params.filteredComps, prop,
      );
      console.log(`💰 Calculated futureValue: $${futureValue} (method: ${config.valuationMethod})`);
    }

    // console.log("[DEBUG] futureValue: ", futureValue); // Removed for cleaner logs

    // Override support: Use prop.impValue or params.impValue if provided
    let impValue;
    if (typeof prop.impValue !== "undefined" && prop.impValue !== null) {
      impValue = Number(prop.impValue);
      console.log(`🔧 Using OVERRIDE impValue from prop: $${impValue}`);
    } else if (typeof params.impValue !== "undefined" && params.impValue !== null) {
      impValue = Number(params.impValue);
      console.log(`🔧 Using OVERRIDE impValue from params: $${impValue}`);
    } else {
      impValue = calculateImprovementCost(method, futureLivingArea, config);
      console.log(`🔨 Calculated impValue: $${impValue}`);
    }

    let loanDetails = calculateLoan(futureValue, purchasePrice, impValue, config);
    console.log(`💸 Loan Details:`, {
      loanAmount: loanDetails.loanAmount,
      downPayment: loanDetails.downPayment,
      monthlyPayment: loanDetails.monthlyPayment,
      loanPayments: loanDetails.loanPayments,
      loanFees: loanDetails.loanFees
    });

    // Override support: Use prop.loanPayments or params.loanPayments if provided
    if (typeof prop.loanPayments !== "undefined" && prop.loanPayments !== null) {
      loanDetails.loanPayments = Number(prop.loanPayments);
      console.log(`🔧 OVERRIDE loanPayments from prop: $${loanDetails.loanPayments}`);
    } else if (typeof params.loanPayments !== "undefined" && params.loanPayments !== null) {
      loanDetails.loanPayments = Number(params.loanPayments);
      console.log(`🔧 OVERRIDE loanPayments from params: $${loanDetails.loanPayments}`);
    } else {}

    // Override support: Use prop.loanFees or params.loanFees if provided
    if (typeof prop.loanFees !== "undefined" && prop.loanFees !== null) {
      loanDetails.loanFees = Number(prop.loanFees);
      console.log(`🔧 OVERRIDE loanFees from prop: $${loanDetails.loanFees}`);
    } else if (typeof params.loanFees !== "undefined" && params.loanFees !== null) {
      loanDetails.loanFees = Number(params.loanFees);
      console.log(`🔧 OVERRIDE loanFees from params: $${loanDetails.loanFees}`);
    } else {}

    const closingDates = calculateClosingDates(config.duration);

    if (method === "Rental") {
      const propertyState = String(prop.state || 'CA');
      const monthlyRent = Number(params.monthlyRent) ||
        Number(prop.rentZestimate) ||
        estimateMonthlyRent(futureValue, propertyState);

      const rentRatePercent = (propertyState === 'CA' || propertyState === 'California') ? '0.5%' : '1%';
      console.log(`🏠 RENTAL RENT SOURCE for ${prop.zpid}:`, {
        paramsMonthlyRent: params.monthlyRent,
        propRentZestimate: prop.rentZestimate,
        fallbackEstimate: estimateMonthlyRent(futureValue, propertyState),
        selectedMonthlyRent: monthlyRent,
        state: propertyState,
        rentSource: params.monthlyRent ? 'params.monthlyRent' : (prop.rentZestimate ? 'prop.rentZestimate' : `${rentRatePercent} fallback`)
      });

      const annualRent = Number(monthlyRent) * 12;
      // Calculate operating expenses using database-provided rates
      const annualMaintenance = round(Number(futureValue) * Number(config.maintenanceRate));
      const annualOperatingExpenses = round(Number(futureValue) * Number(config.operatingExpenseRate));
      const annualPropertyManagement = round(Number(annualRent) * Number(config.propertyManagementFeeRate));
      const annualUtilities = Number(config.utilities) * 12;
      const annualVacancy = round(Number(annualRent) * Number(config.vacancyRate));

      // Calculate Net Operating Income (NOI) and cash flow
      const annualNOI = annualRent - (annualMaintenance + annualOperatingExpenses +
        annualPropertyManagement + annualUtilities + annualVacancy +
        config.propertyTaxes + config.propertyIns);

      const annualCashFlow = annualNOI - loanDetails.loanPayments;
      const monthlyCashFlow = annualCashFlow / 12;

      // Calculate selling costs based on appreciated resale value after 5 years
      const holdingPeriodYears = 5;
      const appreciationRate = 0.035; // 3.5% annual appreciation
      const futureResaleValue = round(Number(futureValue) * Math.pow(1 + appreciationRate, holdingPeriodYears));
      const sellingCostsAtResale = round(Number(futureResaleValue) * Number(config.salRate));
      const resaleValue = Number(futureValue); // Use After Repair Value as requested

      // For rental properties, netSaleProceeds includes 5 years of net cash flow plus resale value
      const netRentalIncomeFiveYears = round(Number(annualCashFlow) * holdingPeriodYears);
      const netSaleProceeds = round(netRentalIncomeFiveYears + resaleValue);

      // Calculate total costs (for initial purchase & 5 years of ownership)
      // Override support: Use prop.impValue or params.impValue if provided
      let sellingCosts;
      if (typeof prop.sellingCosts !== "undefined" && prop.sellingCosts !== null) {
        sellingCosts = Number(prop.sellingCosts);
      } else if (typeof params.sellingCosts !== "undefined" && params.sellingCosts !== null) {
        sellingCosts = Number(params.sellingCosts);
      } else {
        sellingCosts = round(futureResaleValue * config.salRate);
      }
      const totalCosts = calculateTotalCosts({
        purchasePrice,
        impValue,
        loanPayments: loanDetails.loanPayments,
        loanFees: loanDetails.loanFees,
        permitsFees: config.permitsFees,
        propertyTaxes: config.propertyTaxes,
        propertyIns: config.propertyIns,
        sellingCosts: sellingCosts, // Include selling costs for 5-year sale
      });

      const netReturn = round(netSaleProceeds - totalCosts);

      console.log(`📊 RENTAL FINAL CALCULATION:`, {
        netRentalIncomeFiveYears: netRentalIncomeFiveYears,
        resaleValue: resaleValue,
        netSaleProceeds: netSaleProceeds,
        totalCosts: totalCosts,
        netReturn: netReturn,
        annualCashFlow: annualCashFlow,
        profitable: netReturn > 0
      });

      // Allow bypassing minimum return filter via params
      const minReturn = params.bypassMinReturn ? 0 : (params.minReturn || 10000);
      if (netReturn <= minReturn && !params.bypassMinReturn) {
        console.log(`❌ Low net return (${netReturn}) for ${prop?.zpid} ${method} - minimum $${minReturn.toLocaleString()} required - REJECTED`);
        return null;
      }

      console.log(`✅ ${method} strategy ACCEPTED: Net Return = $${netReturn}`);

      // ROE and GROC for rental
      const cashNeeded = Number(loanDetails.downPayment || 0) + Number(impValue || 0) + Number(config.permitsFees || 0) + Number(config.propertyTaxes || 0);
      const netIncomeAfterFinancing = Number(annualRent) - (annualMaintenance + annualOperatingExpenses +
        annualPropertyManagement + annualUtilities + annualVacancy + config.propertyTaxes + config.propertyIns + loanDetails.loanPayments);
      const totalEquityInvested = Number(loanDetails.downPayment) + Number(impValue) + Number(config.permitsFees) + Number(config.propertyTaxes);

      const roe = totalEquityInvested > 0 ? (netIncomeAfterFinancing / totalEquityInvested) * 100 : 0;
      const grocTotalReturn = Number(resaleValue) + Number(netRentalIncomeFiveYears) - Number(purchasePrice) - Number(impValue) - Number(config.permitsFees);
      const totalCapitalInvested = Number(loanDetails.downPayment) + Number(impValue) + Number(config.permitsFees);
      const groc = totalCapitalInvested > 0 ? grocTotalReturn / totalCapitalInvested : 0;

      // DSCR: NOI / Total Debt Service
      const dscr = Number(loanDetails.loanPayments) > 0 ? Number(annualNOI) / Number(loanDetails.loanPayments) : 0;

      // For rental: totalReturn = futureValue + net rental income over 5 years
      const totalReturn = round(Number(futureValue) + Number(netRentalIncomeFiveYears));

      return enhanceStrategyWithIRR({
        method,
        futureValue: ensureInt(futureValue),
        totalReturn: ensureInt(totalReturn),
        futureLivingArea: ensureInt(futureLivingArea),
        impValue: ensureInt(impValue),
        loanAmount: ensureInt(loanDetails.loanAmount),
        downPayment: ensureInt(loanDetails.downPayment),
        monthlyPayment: ensureInt(loanDetails.monthlyPayment),
        loanPayments: ensureInt(loanDetails.loanPayments),
        loanFees: ensureInt(loanDetails.loanFees),
        permitsFees: ensureInt(prop?.permitsFees || config.permitsFees),
        propertyTaxes: ensureInt(config.propertyTaxes),
        propertyIns: ensureInt(config.propertyIns),
        propTaxIns: ensureInt(prop?.propTaxIns || (Number(config.propertyTaxes || 0) + Number(config.propertyIns || 0))),
        sellingCosts: ensureInt(sellingCosts),
        totalCosts: ensureInt(totalCosts),
        netSaleProceeds: ensureInt(netSaleProceeds),
        netReturn: ensureInt(netReturn),
        holdingPeriodYears: ensureInt(holdingPeriodYears),
        appreciationRate: ensureDouble(appreciationRate),
        futureResaleValue: ensureInt(futureResaleValue),
        sellingCostsAtResale: ensureInt(sellingCostsAtResale),
        resaleValue: ensureInt(resaleValue),
        netRentalIncomeFiveYears: ensureInt(netRentalIncomeFiveYears),
        netRentalIncome5yrs: ensureInt(netRentalIncomeFiveYears),
        monthlyRent: ensureInt(monthlyRent),
        annualRent: ensureInt(annualRent),
        annualNOI: ensureInt(annualNOI),
        annualCashFlow: ensureInt(annualCashFlow),
        monthlyCashFlow: ensureInt(monthlyCashFlow),
        expenses: {
          annualMaintenance: ensureInt(annualMaintenance),
          annualOperatingExpenses: ensureInt(annualOperatingExpenses),
          annualPropertyManagement: ensureInt(annualPropertyManagement),
          annualUtilities: ensureInt(annualUtilities),
          annualVacancy: ensureInt(annualVacancy),
          totalAnnualExpenses: ensureInt(annualMaintenance + annualOperatingExpenses +
            annualPropertyManagement + annualUtilities + annualVacancy +
            config.propertyTaxes + config.propertyIns + loanDetails.loanPayments),
        },
        rates: {
          maintenanceRate: ensureDouble(config.maintenanceRate),
          operatingExpenseRate: ensureDouble(config.operatingExpenseRate),
          propertyManagementFeeRate: ensureDouble(config.propertyManagementFeeRate),
          vacancyRate: ensureDouble(config.vacancyRate),
        },
        cashNeeded: ensureInt(cashNeeded),
        roe: ensureDouble(roe),
        groc: ensureDouble(groc),
        dscr: ensureDouble(dscr),
        purchCloseDate: closingDates.purchase,
        valuationMethod: config.valuationMethod || "rental_income_approach",
        extraValue: ensureInt(config.extraValue),
        mtgRate: ensureDouble(config.mtgRate),
      }, params, config.duration);
    }

    // For all non-rental strategies...
    const sellingCosts = round(Number(futureValue) * Number(config.salRate));
    console.log(`💲 Selling Costs: $${sellingCosts} (${config.salRate * 100}% of $${futureValue})`);

    const totalCosts = calculateTotalCosts({
      purchasePrice,
      impValue,
      loanPayments: loanDetails.loanPayments,
      loanFees: loanDetails.loanFees,
      permitsFees: Number(prop?.permitsFees || config.permitsFees) || 0,
      propertyTaxes: config.propertyTaxes,
      propertyIns: config.propertyIns,
      sellingCosts: sellingCosts,
    });

    console.log(`💰 Total Costs Breakdown:`, {
      purchasePrice: purchasePrice,
      impValue: impValue,
      loanPayments: loanDetails.loanPayments,
      loanFees: loanDetails.loanFees,
      permitsFees: Number(prop?.permitsFees || config.permitsFees) || 0,
      propertyTaxes: config.propertyTaxes,
      propertyIns: config.propertyIns,
      sellingCosts: sellingCosts,
      TOTAL: totalCosts
    });

    const netSaleProceeds = Number(futureValue) - Number(sellingCosts);
    const cashNeeded = Number(loanDetails.downPayment) + Number(impValue) + Number(config.permitsFees) + Number(config.propertyTaxes);
    const netReturn = Number(futureValue) - Number(totalCosts);

    console.log(`📊 FINAL CALCULATION:`, {
      futureValue: futureValue,
      totalCosts: totalCosts,
      netReturn: netReturn,
      cashNeeded: cashNeeded,
      profitable: netReturn > 0
    });

    // Allow bypassing minimum return filter via params
    const minReturn = params.bypassMinReturn ? 0 : (params.minReturn || 10000);
    if (netReturn <= minReturn && !params.bypassMinReturn) {
      console.log(`❌ Low net return (${netReturn}) for ${prop?.zpid} ${method} - minimum $${minReturn.toLocaleString()} required - REJECTED`);
      return null;
    }

    console.log(`✅ ${method} strategy ACCEPTED: Net Return = $${netReturn}`);

    const netROI = totalCosts > 0 ? (Number(netReturn) / Number(totalCosts)) : 0; // Return as decimal for frontend percentage conversion
    const optimalOffer = Number(futureValue) - Number(sellingCosts) - Number(impValue) -
      Number(loanDetails.loanPayments) - Number(loanDetails.loanFees) -
      Number(config.permitsFees) - Number(config.propertyIns) - Number(netReturn);
    const cashOnCashReturn = cashNeeded > 0 ? (Number(netReturn) / Number(cashNeeded)) : 0; // Return as decimal for frontend percentage conversion

    // ROE Calculation for Fix & Flip/Development:
    // ROE should be annual return, so for short-term flips we annualize the return
    const totalEquityInvested = Number(loanDetails.downPayment) + Number(impValue) +
      Number(config.permitsFees) + Number(config.propertyTaxes);

    // Use net return and annualize based on project duration
    const projectDurationYears = (Number(config.duration) || 12) / 12;
    const annualizedReturn = projectDurationYears > 0 ? Number(netReturn) / projectDurationYears : Number(netReturn);
    const roe = totalEquityInvested > 0 ? (annualizedReturn / totalEquityInvested) : 0; // Return as decimal for frontend percentage conversion

    // GROC Calculation:
    const grocTotalReturn = Number(futureValue) - Number(purchasePrice) - Number(impValue) - Number(config.permitsFees);
    const totalCapitalInvested = Number(loanDetails.downPayment) + Number(impValue) + Number(config.permitsFees);
    const groc = totalCapitalInvested > 0 ? grocTotalReturn / totalCapitalInvested : 0;

    // For non-rental strategies: totalReturn = futureValue
    const totalReturn = Number(futureValue);

    return enhanceStrategyWithIRR({
      method,
      futureValue: ensureInt(futureValue),
      totalReturn: ensureInt(totalReturn),
      futureLivingArea: ensureInt(futureLivingArea),
      impValue: ensureInt(impValue),
      loanAmount: ensureInt(loanDetails.loanAmount),
      downPayment: ensureInt(loanDetails.downPayment),
      monthlyPayment: ensureInt(loanDetails.monthlyPayment),
      loanPayments: ensureInt(loanDetails.loanPayments),
      loanFees: ensureInt(loanDetails.loanFees),
      permitsFees: ensureInt(prop?.permitsFees || config.permitsFees),
      propertyTaxes: ensureInt(config.propertyTaxes),
      propertyIns: ensureInt(config.propertyIns),
      propTaxIns: ensureInt(prop?.propTaxIns || (Number(config.propertyTaxes || 0) + Number(config.propertyIns || 0))),
      sellingCosts: ensureInt(sellingCosts),
      totalCosts: ensureInt(totalCosts),
      netSaleProceeds: ensureInt(netSaleProceeds),
      netReturn: ensureInt(netReturn),
      netROI: ensureDouble(netROI),
      cashNeeded: ensureInt(cashNeeded),
      cashOnCashReturn: ensureDouble(cashOnCashReturn),
      roe: ensureDouble(roe),
      groc: ensureDouble(groc),
      dscr: ensureDouble(0),
      purchCloseDate: closingDates.purchase,
      saleCloseDate: closingDates.sale,
      valuationMethod: config.valuationMethod || "sqft_calculation",
      extraValue: ensureInt(config.extraValue),
      mtgRate: ensureDouble(config.mtgRate),
      duration: ensureInt(config.duration),
      totalValue: ensureInt(loanDetails.totalProjectCost),
      mortgage: ensureInt(loanDetails.mortgage),
      optimalOffer: ensureInt(optimalOffer),
      avgDollarPerSqft: ensureInt(futureLivingArea > 0 ? Number(futureValue) / Number(futureLivingArea) : 0),
      avgDollarPerBdrm: ensureInt(bedrooms > 0 ? Number(futureValue) / Number(bedrooms) : 0),
      avgRentPerSqft: ensureInt((prop.rentZestimate && futureLivingArea > 0) ? Number(prop.rentZestimate) / Number(futureLivingArea) : 0),
    }, params, config.duration);
  } catch (error) {
    console.error(`Error in calculateStrategy for ${method}:`, error);
    console.error("Error stack:", error.stack);
    console.error("Input values:", {prop, params, pricePerSqFt, twoBedAvg});

    // Return a safe error object instead of crashing
    return {
      method,
      error: `Calculation failed: ${error.message}`,
      futureValue: ensureInt(0),
      impValue: ensureInt(0),
      totalCosts: ensureInt(0),
      netSaleProceeds: ensureInt(0),
      netReturn: ensureInt(0),
      netROI: ensureDouble(0),
      cashNeeded: ensureInt(0),
      sellingCosts: ensureInt(0),
      roe: ensureDouble(0),
      groc: ensureDouble(0),
      dscr: ensureDouble(0),
    };
  }
}

// ----------------- Helper Functions --------------------

function getConfig(method, params = {}, twoBedAvg) {
  const base = {
    mtgRate: Number(params.interestRate) || 0.06,
    salRate: Number(params.salRate) || 0.04,
    loanFeesRate: Number(params.loanFeesRate) || 0.01,
    permitsFees: Number(params.permitsFees) || 1000,
    annualTaxRate: 0.01,
    annualInsRate: 0.0035,
  };

  const strategyConfigs = {
    "Fix & Flip": {
      ...base,
      duration: Number(params.fixFlipDuration) || 3,
      impFactor: 1.08,
      rate: 25,
      areaMult: 1,
      extraValue: 0,
    },
    "Add-On": {
      ...base,
      duration: Number(params.addOnDuration) || 6,
      impFactor: 1.0,
      rate: 150,
      addOnArea: 120,
      areaMult: 1.2,
      extraValue: Number(params.oneBdrmMarketValue) || 0,
    },
    "ADU": {
      ...base,
      duration: Number(params.aduDuration) || 9,
      rate: 200,
      aduArea: 750,
      aduImpRate: Number(params.aduImpRate) || 300,
      impFactor: 0.95,
      areaMult: 1.5,
      extraValue: Number(twoBedAvg) || 0,
    },
    "New Build": {
      ...base,
      duration: Number(params.newBuildDuration) || 12,
      rate: 180, // Reduced from 200 to 180 (lower construction cost)
      impFactor: 1.25, // Increased from 1.15 to 1.25 (25% improvement factor)
      areaMult: 1.3, // Increased from 1.2 to 1.3 (30% area multiplier)
      extraValue: 0,
    },
    "Rental": {
      ...base,
      duration: 12,
      impFactor: 1.0,
      rate: 0,
      areaMult: 1,
      extraValue: 0,
      maintenanceRate: Number(params.maintenanceRate) || 0.005, // 0.5% of property value annually,
      operatingExpenseRate: Number(params.operatingExpenseRate) || 0.0025, // 0.25% of property value annually,
      propertyManagementFeeRate: Number(params.propertyManagementFeeRate) || 0.0, // 0% of rental income (self-managed),
      utilities: Number(params.utilities) || 150, // Monthly utilities cost
      vacancyRate: Number(params.vacancyRate) || 0.05, // 5% of rental income for vacancy
      valuationMethod: "rental_income_approach",
    },
  };

  return strategyConfigs[method] || null;
}

function estimateMonthlyRent(propertyValue, state = 'CA') {
  const safeValue = Number(propertyValue) || 0;
  // California uses 0.5% rule, all other states use 1% rule for rent estimation
  const rentRate = (state === 'CA' || state === 'California') ? 0.005 : 0.01;
  return round(safeValue * rentRate);
}

function calculateFutureLivingArea(method, baseArea, config) {
  if (method === "Add-On") return baseArea + config.addOnArea;
  if (method === "ADU") return baseArea + config.aduArea;
  if (method === "New Build") return round(baseArea * config.areaMult);
  return baseArea;
}

function estimateFutureValue(method, futureArea, pricePerSqFt, config, bedrooms, bedroomAnalysis, filteredComps, subjectProperty) {
  if (method === "Add-On") {
    // Check if Add-On will physically fit on the lot before valuation
    const addOnFeasibility = checkAddOnFeasibility(subjectProperty, config);
    if (!addOnFeasibility.feasible) {
      console.log(`❌ Add-On not feasible: ${addOnFeasibility.reason}`);
      config.valuationMethod = "addon_lot_size_insufficient";
      return -1; // Signal Add-On strategy rejection
    }

    console.log(`✅ Add-On lot feasibility: ${addOnFeasibility.reason} (${subjectProperty.lotAreaValue || 'unknown'} sqft lot)`);

    // Add-On calculation: Use target bedroom comps for total futureValue
    const targetBedrooms = Math.min(5, bedrooms + 1);

    // Apply bedroom ceiling cap for 4+ bedroom properties (diminishing returns)
    const maxIncrementalValue = {
      4: 50000,  // Adding 4th bedroom: up to $50k value
      5: 40000,  // Adding 5th bedroom: up to $40k value
      6: 25000,  // Adding 6th bedroom: up to $25k value (limited market)
      7: 15000,  // Adding 7th+ bedroom: up to $15k value
    };

    if (targetBedrooms >= 4 && maxIncrementalValue[targetBedrooms]) {
      const baseValue = subjectProperty.price || round(subjectProperty.livingArea * pricePerSqFt);
      const cappedIncrement = maxIncrementalValue[targetBedrooms];
      const futureValueCapped = round(baseValue + cappedIncrement);

      config.valuationMethod = `bedroom_ceiling_cap_${targetBedrooms}BR`;
      console.log(`🏠 Bedroom ceiling cap applied: ${bedrooms}BR→${targetBedrooms}BR limited to +$${cappedIncrement.toLocaleString()} increment`);
      console.log(`   Base value: $${baseValue.toLocaleString()} + Increment: $${cappedIncrement.toLocaleString()} = ARV: $${futureValueCapped.toLocaleString()}`);
      return futureValueCapped;
    }

    // Filter comps to target bedroom count
    const targetBedroomComps = (filteredComps || []).filter((comp) => {
      const compBeds = comp.beds || 0;
      return compBeds === targetBedrooms;
    });

    if (targetBedroomComps.length >= 2) {
      // Step 1: Filter target bedroom comps by size similarity AND price range to prevent skewing from large/expensive homes
      const subjectPropertyPrice = subjectProperty.price || 0;
      const sizeAndPriceFilteredComps = targetBedroomComps.filter(comp => {
        const compSqft = extractCompSqftStrategy(comp);
        const compPrice = extractCompPriceStrategy(comp);
        if (compSqft <= 0) return false;

        // Size filter: 75%-125% of future area (tightened from 70%-150%)
        const sizeRatio = compSqft / futureArea;
        const passesSizeFilter = sizeRatio >= 0.75 && sizeRatio <= 1.25;

        // Price filter: ±40% of subject price for bedroom comps (looser than ±30% for general comps)
        const passesPriceFilter = subjectPropertyPrice > 0
          ? (compPrice >= subjectPropertyPrice * 0.6 && compPrice <= subjectPropertyPrice * 1.4)
          : true; // Skip price filter if no subject price available

        return passesSizeFilter && passesPriceFilter;
      });

      console.log(`🔍 Size+Price filtering: ${targetBedroomComps.length} ${targetBedrooms}BR comps → ${sizeAndPriceFilteredComps.length} filtered comps (75%-125% size, ±40% price of subject)`);

      // Use filtered comps if we have enough, otherwise fall back to all target bedroom comps
      const compsToUse = sizeAndPriceFilteredComps.length >= 2 ? sizeAndPriceFilteredComps : targetBedroomComps;

      // Step 2: Calculate average price per sqft from filtered comps
      const targetCompPricesPerSqFt = compsToUse.map(comp => {
        const price = extractCompPriceStrategy(comp);
        const sqft = extractCompSqftStrategy(comp);
        return sqft > 0 ? price / sqft : 0;
      }).filter(price => price > 0);

      if (targetCompPricesPerSqFt.length > 0) {
        const avgTargetPricePerSqFt = targetCompPricesPerSqFt.reduce((sum, price) => sum + price, 0) / targetCompPricesPerSqFt.length;

        // Step 3: Apply cap/floor to prevent extreme deviations from market rate
        const cappedTargetPrice = Math.min(
          Math.max(avgTargetPricePerSqFt, pricePerSqFt * 0.8), // Floor: 80% of market rate
          pricePerSqFt * 1.3  // Cap: 130% of market rate
        );
        const roundedTargetPrice = Math.round(cappedTargetPrice);

        // Calculate futureValue using capped target bedroom comp price per sqft
        const futureValue = round(futureArea * roundedTargetPrice * config.impFactor) + config.extraValue;

        const filterType = sizeAndPriceFilteredComps.length >= 2 ? "size+price-filtered" : "all";
        config.valuationMethod = `target_bedroom_comps_${filterType}_capped`;

        // Show adjustment details
        const wasAdjusted = Math.abs(avgTargetPricePerSqFt - cappedTargetPrice) > 1;
        const adjustmentNote = wasAdjusted ? ` (adjusted from $${Math.round(avgTargetPricePerSqFt)})` : "";

        console.log(`✅ Add-On Bedroom: ${futureArea} sqft × $${roundedTargetPrice}/sqft (${targetBedrooms}BR ${filterType} avg${adjustmentNote}) × ${config.impFactor} + extra ($${config.extraValue}) = $${futureValue} [${compsToUse.length} comps used]`);
        return futureValue;
      }
    }

    // Fallback: Use standard market rate calculation if insufficient target bedroom comps
    console.log(`⚠️ Insufficient ${targetBedrooms}BR comps (${targetBedroomComps.length} found), using fallback calculation`);
    const futureValue = round(futureArea * pricePerSqFt * config.impFactor) + config.extraValue;
    config.valuationMethod = "fallback_market_rate";
    console.log(`✅ Add-On Bedroom (fallback): ${futureArea} sqft × $${pricePerSqFt}/sqft × ${config.impFactor} + extra ($${config.extraValue}) = $${futureValue}`);
    return futureValue;
  } else if (method === "ADU") {
    // Check if ADU will physically fit on the lot before valuation
    const aduFeasibility = checkADULotFeasibility(subjectProperty, config);
    if (!aduFeasibility.feasible) {
      console.log(`❌ ADU not feasible: ${aduFeasibility.reason}`);
      config.valuationMethod = "adu_lot_size_insufficient";
      return -1; // Signal ADU strategy rejection
    }

    console.log(`✅ ADU lot feasibility: ${aduFeasibility.reason} (${subjectProperty.lotAreaValue || 'unknown'} sqft lot)`);

    // Income Approach for ADU valuation using rental income potential
    const mainHouseValue = round(subjectProperty.livingArea * Math.min(pricePerSqFt, 500)); // Increased cap

    // Calculate ADU value using Income Approach
    const propertyState = String(subjectProperty.state || 'CA');
    const aduIncomeValue = calculateADUIncomeValue(subjectProperty, filteredComps, config, propertyState);

    if (aduIncomeValue > 0) {
      const totalValue = round((mainHouseValue + aduIncomeValue) * config.impFactor);

      // Cap ADU future value to list price + two bed average
      const maxAduValue = (subjectProperty.price || 0) + (config.extraValue || 0);
      const cappedValue = Math.min(totalValue, maxAduValue);

      if (cappedValue < totalValue) {
        config.valuationMethod = "main_house_plus_adu_income_approach_capped";
        console.log(`✅ ADU Income Approach (CAPPED): calculated $${totalValue} → capped to $${cappedValue} (list price $${subjectProperty.price || 0} + 2BR avg $${config.extraValue || 0})`);
      } else {
        config.valuationMethod = "main_house_plus_adu_income_approach";
        console.log(`✅ ADU Income Approach: (main house ($${mainHouseValue}) + ADU income value ($${aduIncomeValue})) × ${config.impFactor} = $${totalValue}`);
      }
      return cappedValue;
    }

    // Always use ADU premium approach as fallback (loosened filter)
    const aduPremium = calculateADUPremium(subjectProperty.livingArea);
    const adjustedValue = round(mainHouseValue * (1 + aduPremium) * config.impFactor);

    // Cap ADU future value to list price + two bed average
    const maxAduValue = (subjectProperty.price || 0) + (config.extraValue || 0);
    const cappedValue = Math.min(adjustedValue, maxAduValue);

    if (cappedValue < adjustedValue) {
      config.valuationMethod = "main_house_plus_adu_premium_capped";
      console.log(`✅ ADU premium fallback (CAPPED): calculated $${adjustedValue} → capped to $${cappedValue} (list price $${subjectProperty.price || 0} + 2BR avg $${config.extraValue || 0})`);
    } else {
      config.valuationMethod = "main_house_plus_adu_premium";
      console.log(`✅ ADU premium fallback: main house ($${mainHouseValue}) × (1 + ${Math.round(aduPremium*100)}%) × ${config.impFactor} = $${adjustedValue}`);
    }
    return cappedValue;
  } else if (method === "Rental") {
    config.valuationMethod = "current_market_value";
  } else {
    config.valuationMethod = "sqft_calculation";
  }

  // Cap price per sq ft to prevent unrealistic valuations (loosened for New Build)
  const cappedPricePerSqFt = Math.min(pricePerSqFt, 500); // Increased from $400 to $500/sq ft

  // Apply size adjustment based on comparable properties
  const adjustedPricePerSqFt = calculateSizeAdjustedPrice(
    futureArea,
    cappedPricePerSqFt,
    filteredComps,
    config
  );

  console.log(`📐 Price adjustment: $${pricePerSqFt}/sqft → $${cappedPricePerSqFt}/sqft (capped) → $${adjustedPricePerSqFt}/sqft (size-adjusted)`);

  const calculatedValue = round(futureArea * adjustedPricePerSqFt * config.impFactor);

  return calculatedValue;
}

function calculateSizeAdjustedPrice(futureArea, basePricePerSqFt, filteredComps, config) {
  // Calculate average comp size for comparison
  if (!filteredComps || filteredComps.length === 0) {
    console.log(`⚠️ No comps available for size adjustment - using base price $${basePricePerSqFt}/sqft`);
    return basePricePerSqFt; // No adjustment if no comps available
  }

  const avgCompSize = filteredComps.reduce((sum, comp) => {
    const sqft = extractCompSqftStrategy(comp);
    return sum + (sqft || 0);
  }, 0) / filteredComps.length;

  if (avgCompSize <= 0) {
    return basePricePerSqFt; // No adjustment if invalid comp sizes
  }

  // Size-based price adjustment: larger homes get slight discount
  const sizeDeviation = (futureArea - avgCompSize) / avgCompSize;

  // Market research shows: every 25% size increase = 5% price/sqft decrease
  // This reflects economies of scale in larger homes
  const priceAdjustment = -sizeDeviation * 0.20; // 20% adjustment per 100% size change

  // Cap adjustment to prevent extreme values
  const cappedAdjustment = Math.max(-0.15, Math.min(0.15, priceAdjustment)); // ±15% max

  const adjustedPrice = Math.round(basePricePerSqFt * (1 + cappedAdjustment));

  console.log(`📐 Size Adjustment: ${futureArea} sqft vs ${Math.round(avgCompSize)} sqft avg (${(sizeDeviation*100).toFixed(1)}% diff) → $${basePricePerSqFt}/sqft → $${adjustedPrice}/sqft (${(cappedAdjustment*100).toFixed(1)}%)`);

  return adjustedPrice;
}

function calculateImprovementCost(method, futureArea, config) {
  if (method === "ADU") return config.aduImpRate * 750;
  if (method === "Add-On") {
    return round(config.addOnArea * config.rate);  // Only bedroom addition cost
  }
  if (method === "Rental") return 0;
  return round(futureArea * config.rate);
}

function calculateLoan(futureValue, purchasePrice, impValue, config) {
  const safeFutureValue = Number(futureValue) || 0;
  const safePurchasePrice = Number(purchasePrice) || 0;
  const safeImpValue = Number(impValue) || 0;
  const safeMtgRate = Number(config.mtgRate) || 0.06;
  const safeDuration = Number(config.duration) || 12;
  const safeLoanFeesRate = Number(config.loanFeesRate) || 0.01;
  const safeAnnualTaxRate = Number(config.annualTaxRate) || 0.01;
  const safeAnnualInsRate = Number(config.annualInsRate) || 0.005;

  const totalProjectCost = safePurchasePrice + safeImpValue;
  const maxLtcLoan = totalProjectCost * 0.90;
  const maxArvLoan = safeFutureValue * 0.75;
  const loanAmount = round(Math.min(maxLtcLoan, maxArvLoan));
  const downPayment = round(totalProjectCost - loanAmount);
  const mortgage = totalProjectCost - downPayment;
  const monthlyPayment = round(loanAmount * (safeMtgRate / 12));
  const loanPayments = round(monthlyPayment * safeDuration);

  const loanFees = Math.min(round(loanAmount * safeLoanFeesRate), 20000);
  const propertyTaxes = round(totalProjectCost * safeAnnualTaxRate * (safeDuration / 12));
  const propertyIns = round(totalProjectCost * safeAnnualInsRate * (safeDuration / 12));

  Object.assign(config, {loanAmount, downPayment, loanPayments, monthlyPayment, loanFees, propertyTaxes, propertyIns});

  return {loanAmount, downPayment, monthlyPayment, loanPayments, loanFees, mortgage, totalProjectCost};
}

function calculateTotalCosts({
  purchasePrice,
  impValue,
  loanPayments,
  loanFees,
  permitsFees,
  propertyTaxes,
  propertyIns,
  sellingCosts,
}) {
  return Number(purchasePrice || 0) + Number(impValue || 0) + Number(loanPayments || 0) +
         Number(loanFees || 0) + Number(permitsFees || 0) + Number(propertyTaxes || 0) +
         Number(propertyIns || 0) + Number(sellingCosts || 0);
}

function calculateClosingDates(durationMonths) {
  const safeDuration = Number(durationMonths) || 12;

  const purchaseDate = new Date();
  purchaseDate.setDate(purchaseDate.getDate() + 21);

  const saleDate = new Date(purchaseDate);
  saleDate.setMonth(saleDate.getMonth() + safeDuration);

  return {
    purchase: purchaseDate.toISOString().split("T")[0],
    sale: saleDate.toISOString().split("T")[0],
  };
}

// Internal Rate of Return (IRR) calculation function for real estate investments
// Works with the existing real estate strategy calculation system

/**
 * Calculates Internal Rate of Return (IRR) for a real estate investment strategy
 * @param {Object} strategyResult - Result object from calculateStrategy or calculateRentalStrategy
 * @param {Object} params - Investment parameters
 * @param {number} holdingPeriod - Holding period in years (optional, defaults to strategy duration)
 * @return {Object} IRR analysis with percentage and cash flow breakdown
 */
function calculateIRR(strategyResult, params = {}, holdingPeriod = null) {
  const {method} = strategyResult;

  // Determine holding period (convert months to years)
  const duration = holdingPeriod || (getDurationMonths(method, params) / 12);

  if (method === "Rental") {
    return calculateRentalIRR(strategyResult, duration);
  } else {
    return calculateDevelopmentIRR(strategyResult, duration);
  }
}

/**
 * Calculates IRR for rental properties with ongoing cash flows
 * @param {Object} strategyResult - Result object from calculateStrategy or calculateRentalStrategy
 * @param {number} holdingPeriodYears - Holding period in years (optional, defaults to strategy duration)
 * @return {Object} Rental IRR analysis with percentage and cash flow breakdown
 */
function calculateRentalIRR(strategyResult, holdingPeriodYears) {
  const {
    downPayment,
    permitsFees,
    propertyTaxes,
    annualCashFlow,
    futureValue,
    loanAmount,
  } = strategyResult;

  // Initial investment (negative cash flow)
  const initialInvestment = -(downPayment + permitsFees + propertyTaxes);

  // Annual cash flows during holding period
  const annualCashFlows = Array(Math.floor(holdingPeriodYears)).fill(annualCashFlow);

  // Final year: annual cash flow + sale proceeds - remaining loan balance
  const loanBalance = calculateRemainingLoanBalance(loanAmount, strategyResult.mtgRate, holdingPeriodYears);
  const saleProceeds = futureValue * (1 + 0.035) ** holdingPeriodYears; // 3.5% annual appreciation
  const sellingCosts = saleProceeds * 0.06; // 6% selling costs
  const finalCashFlow = annualCashFlow + (saleProceeds - sellingCosts - loanBalance);

  // Construct complete cash flow array
  const cashFlows = [initialInvestment, ...annualCashFlows.slice(0, -1), finalCashFlow];

  const irr = calculateIRRFromCashFlows(cashFlows);

  return {
    irr: Math.round(irr * 10000) / 100, // Convert to percentage with 2 decimals
    cashFlows,
    initialInvestment: Math.abs(initialInvestment),
    totalCashFlowReceived: annualCashFlows.reduce((sum, cf) => sum + cf, 0) + finalCashFlow,
    holdingPeriodYears,
    saleProceeds: Math.round(saleProceeds),
    finalCashFlow: Math.round(finalCashFlow),
    method: "Rental IRR Analysis",
  };
}

/**
 * Calculates IRR for development strategies (Fix & Flip, Add-On, ADU, New Build)
 * @param {Object} strategyResult - Result object from calculateStrategy or calculateRentalStrategy
 * @param {number} holdingPeriodYears - Holding period in years (optional, defaults to strategy duration)
 * @return {Object} Development IRR analysis with percentage and cash flow breakdown
 */
function calculateDevelopmentIRR(strategyResult, holdingPeriodYears) {
  const {
    downPayment,
    permitsFees,
    propertyTaxes,
    monthlyPayment,
    futureValue,
    sellingCosts,
    loanFees,
    propertyIns,
  } = strategyResult;

  // Initial investment
  const initialInvestment = -(downPayment + permitsFees + propertyTaxes + loanFees);

  // Monthly carrying costs during development/holding period
  const monthlyCarryingCosts = -(monthlyPayment + (propertyIns / 12));
  const totalMonths = Math.floor(holdingPeriodYears * 12);

  // Final cash flow: sale proceeds minus selling costs
  const finalCashFlow = futureValue - sellingCosts;

  // Construct monthly cash flow array
  const cashFlows = [
    initialInvestment,
    ...Array(totalMonths - 1).fill(monthlyCarryingCosts),
    finalCashFlow + monthlyCarryingCosts, // Last month includes sale
  ];

  // Calculate IRR on monthly basis, then annualize
  const monthlyIRR = calculateIRRFromCashFlows(cashFlows);
  const annualIRR = Math.pow(1 + monthlyIRR, 12) - 1;

  return {
    irr: Math.round(annualIRR * 10000) / 100, // Convert to percentage with 2 decimals
    cashFlows,
    initialInvestment: Math.abs(initialInvestment),
    totalCarryingCosts: monthlyCarryingCosts * (totalMonths - 1),
    finalCashFlow: Math.round(finalCashFlow),
    holdingPeriodYears,
    totalMonths,
    method: `${strategyResult.method} IRR Analysis`,
  };
}

/**
 * Calculates IRR from an array of cash flows using Newton-Raphson method
 * @param {Array} cashFlows - Array of cash flows (negative for outflows, positive for inflows)
 * @return {number} IRR as decimal (e.g., 0.15 for 15%)
 */
function calculateIRRFromCashFlows(cashFlows) {
  const maxIterations = 1000;
  const tolerance = 1e-10;
  let rate = 0.1; // Initial guess: 10%

  for (let i = 0; i < maxIterations; i++) {
    const npv = calculateNPV(cashFlows, rate);
    const npvDerivative = calculateNPVDerivative(cashFlows, rate);

    if (Math.abs(npv) < tolerance) {
      return rate;
    }

    if (Math.abs(npvDerivative) < tolerance) {
      // Derivative too small, try different starting point
      rate = Math.random() * 0.5;
      continue;
    }

    const newRate = rate - (npv / npvDerivative);

    // Prevent negative or extremely high rates
    if (newRate < -0.99) {
      rate = -0.95;
    } else if (newRate > 10) {
      rate = 1.0;
    } else {
      rate = newRate;
    }
  }

  // If Newton-Raphson fails, try bisection method
  return calculateIRRBisection(cashFlows);
}

/**
 * Calculates Net Present Value for given cash flows and discount rate
 * @param {Array} cashFlows - Array of cash flows (negative for outflows, positive for inflows)
 * @param {double} rate - Double number denoting discount rate
 * @return {number} Net Present Value for given cash flow and discount rate
 */
function calculateNPV(cashFlows, rate) {
  return cashFlows.reduce((npv, cashFlow, period) => {
    return npv + (cashFlow / Math.pow(1 + rate, period));
  }, 0);
}

/**
 * Calculates the derivative of NPV with respect to the discount rate
 * @param {Array} cashFlows - Array of cash flows (negative for outflows, positive for inflows)
 * @param {double} rate - Double number denoting discount rate
 * @return {number} Net Present Value derivative for given cash flow and discount rate
 */
function calculateNPVDerivative(cashFlows, rate) {
  return cashFlows.reduce((derivative, cashFlow, period) => {
    if (period === 0) return derivative;
    return derivative - (period * cashFlow / Math.pow(1 + rate, period + 1));
  }, 0);
}

/**
 * Fallback IRR calculation using bisection method
 * @param {Array} cashFlows - Array of cash flows (negative for outflows, positive for inflows)
 * @param {double} lowRate - default value set to -0.99
 * @param {double} highRate - default value set to -10
 * @return {number} Net Present Value derivative for given cash flow and discount rate
 */
function calculateIRRBisection(cashFlows, lowRate = -0.99, highRate = 10) {
  const tolerance = 1e-10;
  const maxIterations = 1000;

  for (let i = 0; i < maxIterations; i++) {
    const midRate = (lowRate + highRate) / 2;
    const npv = calculateNPV(cashFlows, midRate);

    if (Math.abs(npv) < tolerance) {
      return midRate;
    }

    if (calculateNPV(cashFlows, lowRate) * npv < 0) {
      highRate = midRate;
    } else {
      lowRate = midRate;
    }

    if (Math.abs(highRate - lowRate) < tolerance) {
      return (lowRate + highRate) / 2;
    }
  }

  return NaN; // IRR not found
}

/**
 * Calculates remaining loan balance using amortization formula
 * @param {Number} loanAmount
 * @param {double} annualRate
 * @param {double} yearsElapsed
 * @return {number} remaining loan balance
 */
function calculateRemainingLoanBalance(loanAmount, annualRate, yearsElapsed) {
  const monthlyRate = annualRate / 12;
  const totalPayments = 30 * 12; // Assume 30-year amortization
  const paymentsElapsed = yearsElapsed * 12;

  if (paymentsElapsed >= totalPayments) {
    return 0; // Loan fully paid off
  }

  // const monthlyPayment = loanAmount * (monthlyRate * Math.pow(1 + monthlyRate, totalPayments)) /
  //                       (Math.pow(1 + monthlyRate, totalPayments) - 1);

  const remainingBalance = loanAmount *
    (Math.pow(1 + monthlyRate, totalPayments) - Math.pow(1 + monthlyRate, paymentsElapsed)) /
    (Math.pow(1 + monthlyRate, totalPayments) - 1);

  return Math.max(0, remainingBalance);
}

/**
 * Gets strategy duration in months from parameters
 * @param {Number} method - current method
 * @param {double} params - User given parameters
 * @return {number} duration in number of months
 */
function getDurationMonths(method, params) {
  const durations = {
    "Fix & Flip": params.fixFlipDuration || 3,
    "Add-On": params.addOnDuration || 6,
    "ADU": params.aduDuration || 9,
    "New Build": params.newBuildDuration || 12,
    "Rental": 12, // Default to 1 year for analysis
  };

  return durations[method] || 12;
}

/**
 * Enhanced wrapper function that adds IRR to existing strategy results
 * @param {Object} strategyResult - Result from calculateStrategy or calculateRentalStrategy
 * @param {Object} params - Investment parameters
 * @param {number} holdingPeriod - Optional holding period in years
 * @return {Object} Enhanced strategy result with IRR analysis
 */
function enhanceStrategyWithIRR(strategyResult, params = {}, holdingPeriod = null) {
  const irrAnalysis = calculateIRR(strategyResult, params, holdingPeriod);

  return {
    ...strategyResult,
    irrAnalysis,
    irr: irrAnalysis.irr,
  };
}


// Helper functions for enhanced Add-On valuation

function calculateIncrementalBedroomValue(currentBeds, targetBeds, filteredComps, subjectProperty, futureArea) {
  // Calculate the incremental value difference between current and target bedroom tiers

  // Step 1: Get current bedroom tier value from filtered comps
  const currentBedroomValue = calculateBedroomTierValue(currentBeds, filteredComps, subjectProperty.livingArea);

  // Step 2: Get target bedroom tier value from filtered comps
  const targetBedroomValue = calculateBedroomTierValue(targetBeds, filteredComps, futureArea);

  console.log(`🔍 Add-On bedroom analysis: ${currentBeds}BR value=$${currentBedroomValue}, ${targetBeds}BR value=$${targetBedroomValue}`);

  // Step 3: Calculate incremental difference with multiple restrictions
  if (currentBedroomValue > 0 && targetBedroomValue > 0) {
    const rawIncrementalValue = targetBedroomValue - currentBedroomValue;

    // Apply multiple caps to prevent excessive increments
    const subjectPrice = subjectProperty.price || 500000;

    // Cap 1: Absolute dollar caps based on property tier
    let maxAbsoluteIncrement;
    if (subjectPrice >= 1500000) maxAbsoluteIncrement = 75000; // $75k max for luxury
    else if (subjectPrice >= 1000000) maxAbsoluteIncrement = 60000; // $60k max for upper-mid
    else if (subjectPrice >= 700000) maxAbsoluteIncrement = 45000; // $45k max for mid-range
    else if (subjectPrice >= 500000) maxAbsoluteIncrement = 35000; // $35k max for lower-mid
    else maxAbsoluteIncrement = 25000; // $25k max for budget

    // Cap 2: Percentage-based cap (max 10% of subject property value)
    const maxPercentageIncrement = Math.round(subjectPrice * 0.10);

    // Cap 3: Construction cost reality check (240 sqft * $125/sqft = $30k + 50% margin = $45k max)
    const maxConstructionIncrement = 45000;

    // Apply the most restrictive cap
    const finalMaxIncrement = Math.min(maxAbsoluteIncrement, maxPercentageIncrement, maxConstructionIncrement);

    if (rawIncrementalValue > 0 && rawIncrementalValue <= finalMaxIncrement) {
      console.log(`✅ Incremental bedroom value: $${rawIncrementalValue} (capped at $${finalMaxIncrement})`);
      return Math.round(rawIncrementalValue);
    } else if (rawIncrementalValue > finalMaxIncrement) {
      console.log(`⚠️ Incremental value capped: $${rawIncrementalValue} → $${finalMaxIncrement}`);
      return finalMaxIncrement;
    }
  }

  // Fallback: Use conservative fixed bedroom value increment
  const fallbackIncrement = calculateFallbackBedroomIncrement(subjectProperty);
  console.log(`⚠️ Using fallback bedroom increment: $${fallbackIncrement}`);
  return fallbackIncrement;
}

function calculateBedroomTierValue(bedrooms, filteredComps, referenceArea) {
  // Get comps matching the specified bedroom count
  const bedroomComps = (filteredComps || []).filter((comp) => {
    const compBeds = comp.beds || 0;
    return compBeds === bedrooms;
  });

  if (bedroomComps.length < 2) {
    console.log(`⚠️ Insufficient ${bedrooms}BR comps: ${bedroomComps.length} found`);
    return 0;
  }

  // Weight comps by size similarity to reference area
  const weightedComps = bedroomComps.map((comp) => {
    const compPrice = extractCompPriceStrategy(comp);
    const compSqft = extractCompSqftStrategy(comp);

    if (!compPrice || !compSqft || compPrice <= 0 || compSqft <= 0) {
      return null;
    }

    // Size similarity to reference area
    const sizeSimilarity = referenceArea > 0 ?
      1 - Math.abs(compSqft - referenceArea) / Math.max(compSqft, referenceArea) : 0.5;

    // Additional market reasonableness check
    const pricePerSqft = compPrice / compSqft;
    if (pricePerSqft < 50 || pricePerSqft > 800) {
      return null;
    }

    const weight = Math.max(0.3, sizeSimilarity);

    return {
      price: compPrice,
      weight: weight,
      sqft: compSqft,
    };
  }).filter(Boolean);

  if (weightedComps.length === 0) return 0;

  // Calculate weighted average price
  const totalWeight = weightedComps.reduce((sum, comp) => sum + comp.weight, 0);
  const weightedAvgPrice = totalWeight > 0 ?
    weightedComps.reduce((sum, comp) => sum + (comp.price * comp.weight), 0) / totalWeight : 0;

  console.log(`📊 ${bedrooms}BR tier: $${Math.round(weightedAvgPrice)} from ${weightedComps.length} comps`);
  return Math.round(weightedAvgPrice);
}

function calculateFallbackBedroomIncrement(subjectProperty) {
  // Very conservative fixed increments - based on realistic bedroom value premiums
  const propertyValue = subjectProperty.price || 500000;

  // Reduced increments to be more realistic (roughly 3-8% of property value)
  if (propertyValue >= 1500000) return 45000; // $45k increment for high-end (3%)
  if (propertyValue >= 1000000) return 40000; // $40k increment for upper-mid (4%)
  if (propertyValue >= 700000) return 35000; // $35k increment for mid-range (5%)
  if (propertyValue >= 500000) return 30000; // $30k increment for lower-mid (6%)
  return 25000; // $25k increment for budget (5-8%)
}

function calculateBedroomPremium(currentBeds, targetBeds) {
  // Conservative bedroom premium calculation
  const bedroomDiff = targetBeds - currentBeds;
  if (bedroomDiff <= 0) return 0;

  // Diminishing returns: first bedroom adds more value
  const basePremiums = [0.15, 0.10, 0.08, 0.05]; // 15%, 10%, 8%, 5%
  let totalPremium = 0;

  for (let i = 0; i < Math.min(bedroomDiff, basePremiums.length); i++) {
    totalPremium += basePremiums[i];
  }

  return Math.min(totalPremium, 0.25); // Cap at 25% premium
}

function calculateADUPremium(mainHouseSqft) {
  // More attractive ADU premiums to show more opportunities
  // Larger houses get smaller relative premium from ADU
  if (mainHouseSqft >= 3000) return 0.20; // 20% for large houses (was 15%)
  if (mainHouseSqft >= 2000) return 0.25; // 25% for medium houses (was 20%)
  if (mainHouseSqft >= 1500) return 0.30; // 30% for typical houses (was 25%)
  return 0.35; // 35% for smaller houses (was 30%)
}

function checkADULotFeasibility(subjectProperty, config) {
  const lotAreaSqft = subjectProperty.lotAreaValue || 0;
  const mainHouseSqft = subjectProperty.livingArea || 0;
  const aduSqft = config.aduArea || 750;

  // Basic lot area check - no lot area data
  if (!lotAreaSqft || lotAreaSqft <= 0) {
    return {
      feasible: true, // Default to feasible if no lot data (to avoid blocking all ADUs)
      reason: "Lot size unknown - assuming feasible",
      details: {
        lotArea: lotAreaSqft,
        mainHouse: mainHouseSqft,
        aduSize: aduSqft,
        availableSpace: "unknown"
      }
    };
  }

  // Minimum lot size requirements for ADU
  const minLotSizeForADU = 5000; // 5,000 sqft minimum lot
  if (lotAreaSqft < minLotSizeForADU) {
    return {
      feasible: false,
      reason: `Lot too small: ${lotAreaSqft} sqft < ${minLotSizeForADU} sqft minimum`,
      details: {
        lotArea: lotAreaSqft,
        minRequired: minLotSizeForADU,
        shortage: minLotSizeForADU - lotAreaSqft
      }
    };
  }

  // Calculate available space considering setbacks and main house footprint
  // Use actual levels data if available, otherwise estimate
  // Extract levels from property data
  const levels = subjectProperty.levels || null;
  let estimatedFootprint;

  // Validate levels data is reasonable (1-4 stories for residential)
  if (levels && levels >= 1 && levels <= 4) {
    // Use actual levels data from Redfin API
    estimatedFootprint = mainHouseSqft / levels;
    console.log(`🏠 Using actual levels data for ADU: ${levels} stories, footprint = ${Math.round(estimatedFootprint)} sqft`);
  } else {
    // Fallback: Estimate actual ground footprint - assume average 1.5 stories (between 1 and 2 story homes)
    // For single story: footprint = living area
    // For two story: footprint = living area / 2
    // Average assumption: footprint = living area / 1.5
    estimatedFootprint = mainHouseSqft / 1.5;
    if (levels && (levels < 1 || levels > 4)) {
      console.log(`⚠️ Invalid levels data (${levels}), using fallback: 1.5 stories, footprint = ${Math.round(estimatedFootprint)} sqft`);
    } else {
      console.log(`🏠 Using estimated levels for ADU: 1.5 stories (fallback), footprint = ${Math.round(estimatedFootprint)} sqft`);
    }
  }

  const houseFootprint = Math.max(estimatedFootprint, 800); // Minimum 800 sqft footprint
  const setbackArea = lotAreaSqft * 0.25; // 25% of lot for setbacks (front, back, side yards)
  const drivewayParking = 600; // Typical driveway/parking area
  const availableSpace = lotAreaSqft - houseFootprint - setbackArea - drivewayParking;

  // Check if ADU plus required clearances will fit
  const aduWithClearance = aduSqft * 1.5; // ADU + 50% for clearances/access
  if (availableSpace < aduWithClearance) {
    return {
      feasible: false,
      reason: `Insufficient available space: ${Math.round(availableSpace)} sqft available < ${Math.round(aduWithClearance)} sqft needed`,
      details: {
        lotArea: lotAreaSqft,
        houseFootprint: Math.round(houseFootprint),
        setbacks: Math.round(setbackArea),
        driveway: drivewayParking,
        availableSpace: Math.round(availableSpace),
        aduRequired: Math.round(aduWithClearance)
      }
    };
  }

  // Additional check: Large houses need proportionally larger lots
  const lotToHouseRatio = lotAreaSqft / mainHouseSqft;
  const minRatioForADU = 2.25; // Lot should be at least 2.25x house size for ADU
  if (lotToHouseRatio < minRatioForADU) {
    return {
      feasible: false,
      reason: `Lot too small for house size: ${lotToHouseRatio.toFixed(1)}x ratio < ${minRatioForADU}x minimum (${Math.round(mainHouseSqft * minRatioForADU)} sqft lot needed for ${mainHouseSqft} sqft house)`,
      details: {
        lotArea: lotAreaSqft,
        houseSize: mainHouseSqft,
        lotToHouseRatio: lotToHouseRatio.toFixed(1),
        minRatioRequired: minRatioForADU,
        minimumLotNeeded: Math.round(mainHouseSqft * minRatioForADU)
      }
    };
  }

  // ADU is feasible
  const spaceRatio = availableSpace / aduWithClearance;
  return {
    feasible: true,
    reason: `Adequate space available: ${Math.round(availableSpace)} sqft available for ${aduSqft} sqft ADU (${spaceRatio.toFixed(1)}x)`,
    details: {
      lotArea: lotAreaSqft,
      availableSpace: Math.round(availableSpace),
      aduSize: aduSqft,
      spaceRatio: spaceRatio.toFixed(1)
    }
  };
}

function checkAddOnFeasibility(subjectProperty, config) {
  const lotAreaSqft = subjectProperty.lotAreaValue || 0;
  const mainHouseSqft = subjectProperty.livingArea || 0;
  const addOnArea = config.addOnArea || 120;

  // Basic lot area check - no lot area data
  if (!lotAreaSqft || lotAreaSqft <= 0) {
    return {
      feasible: true, // Default to feasible if no lot data
      reason: "Lot size unknown - assuming feasible",
      details: {
        lotArea: lotAreaSqft,
        mainHouse: mainHouseSqft,
        addOnSize: addOnArea,
        availableSpace: "unknown"
      }
    };
  }

  // Calculate available space considering setbacks and main house footprint
  const setbackArea = lotAreaSqft * 0.45; // 45% of lot for setbacks

  // Use actual levels data if available, otherwise estimate
  const levels = subjectProperty.levels || null;
  let houseFootprint;

  // Validate levels data is reasonable (1-4 stories for residential)
  if (levels && levels >= 1 && levels <= 4) {
    // Use actual levels data from Redfin API
    houseFootprint = mainHouseSqft / levels;
    console.log(`🏠 Using actual levels data for Add-On: ${levels} stories, footprint = ${Math.round(houseFootprint)} sqft`);
  } else {
    // Fallback: Assume 1.25 stories average
    houseFootprint = mainHouseSqft / 1.25;
    if (levels && (levels < 1 || levels > 4)) {
      console.log(`⚠️ Invalid levels data (${levels}), using fallback: 1.25 stories, footprint = ${Math.round(houseFootprint)} sqft`);
    } else {
      console.log(`🏠 Using estimated levels for Add-On: 1.25 stories (fallback), footprint = ${Math.round(houseFootprint)} sqft`);
    }
  }

  const availableSpace = lotAreaSqft - setbackArea - houseFootprint;

  // Minimum 125 sqft needed for bedroom addition
  const minSpaceRequired = 125;
  if (availableSpace < minSpaceRequired) {
    return {
      feasible: false,
      reason: `Insufficient available space: ${Math.round(availableSpace)} sqft available < ${minSpaceRequired} sqft minimum`,
      details: {
        lotArea: lotAreaSqft,
        setbacks: Math.round(setbackArea),
        houseFootprint: Math.round(houseFootprint),
        availableSpace: Math.round(availableSpace),
        minRequired: minSpaceRequired,
        shortage: Math.round(minSpaceRequired - availableSpace)
      }
    };
  }

  // Add-On is feasible
  return {
    feasible: true,
    reason: `Adequate space available: ${Math.round(availableSpace)} sqft available for ${addOnArea} sqft addition`,
    details: {
      lotArea: lotAreaSqft,
      availableSpace: Math.round(availableSpace),
      addOnSize: addOnArea
    }
  };
}

function calculateADUIncomeValue(subjectProperty, filteredComps, config, state = 'CA') {
  // Get 2BR rent from filtered comps or subject property
  let twoBedRentZestimate = 0;
  const propertyState = String(state);

  console.log(`🔍 ADU Rent Calculation: Starting (state: ${propertyState})`);

  // Try to find 2BR rent from subject property
  if (subjectProperty.rentZestimate && subjectProperty.bedrooms === 2) {
    twoBedRentZestimate = subjectProperty.rentZestimate;
    console.log(`✅ Using subject property 2BR rentZestimate: $${twoBedRentZestimate}/mo`);
  } else {
    // Find 2BR rent from comps
    const twoBedComps = (filteredComps || []).filter(comp => comp.beds === 2);
    if (twoBedComps.length > 0) {
      const avgTwoBedPrice = twoBedComps.reduce((sum, comp) => {
        const price = extractCompPriceStrategy(comp);
        return sum + (price || 0);
      }, 0) / twoBedComps.length;

      // Estimate rent using state-based rule: CA = 0.5%, Other = 1%
      const rentRate = (propertyState === 'CA' || propertyState === 'California') ? 0.005 : 0.01;
      const rentRatePercent = (propertyState === 'CA' || propertyState === 'California') ? '0.5%' : '1%';
      twoBedRentZestimate = round(avgTwoBedPrice * rentRate);
      console.log(`✅ Using ${rentRatePercent} rule fallback for ${propertyState}: $${twoBedRentZestimate}/mo (from avg price $${round(avgTwoBedPrice)})`);
    }
  }

  if (twoBedRentZestimate <= 0) {
    console.log(`⚠️ Could not find 2BR rent data for ADU calculation`);
    return -1; // Signal to use fallback premium
  }

  // Use our ADU valuation function
  const currentMarketValue = Math.round(subjectProperty.livingArea * Math.min(300, 500)); // Use reasonable base value
  const capRate = estimateCapRate(subjectProperty);

  const result = valueHousePlusADU_MarketHouse_IncomeADU({
    currentMarketValue: 0, // We only want the ADU value portion
    twoBedRentZestimate,
    capRate,
    options: {
      aduBedrooms: 1, // Standard 1BR ADU
      vacancyRate: 0.05,
      expenseRatio: 0.25 // Lower than typical rental (ADU maintenance)
    }
  });

  console.log(`✅ ADU Income Value: 2BR rent $${twoBedRentZestimate}/mo → ADU $${result.aduMonthlyRent}/mo → NOI $${result.aduNOIAnnual}/yr → Value $${result.aduIncomeValue}`);

  return result.aduIncomeValue;
}

function valueHousePlusADU_MarketHouse_IncomeADU({
  currentMarketValue,
  twoBedRentZestimate,
  capRate,
  options = {}
}) {
  if (!Number.isFinite(twoBedRentZestimate) || twoBedRentZestimate <= 0) {
    throw new Error("twoBedRentZestimate must be a positive monthly rent.");
  }
  if (!Number.isFinite(capRate) || capRate <= 0) {
    throw new Error("capRate must be a positive decimal (e.g., 0.055 for 5.5%).");
  }

  const {
    aduBedrooms = 1,
    aduRentFactorMap = {
      0: 0.55, // studio ~55% of 2BR
      1: 0.65, // 1BR   ~65% of 2BR
      2: 0.80, // 2BR   ~80% of 2BR
      3: 0.95, // 3BR   ~95% of 2BR
    },
    aduOverrideMonthlyRent,
    vacancyRate = 0.05,
    expenseRatio = 0.30,
    otherMonthlyIncome = 0,
    otherMonthlyOpEx = 0,
  } = options;

  const derivedADURent = (() => {
    if (aduOverrideMonthlyRent != null && Number.isFinite(aduOverrideMonthlyRent)) {
      return aduOverrideMonthlyRent;
    }
    const factor = aduRentFactorMap[aduBedrooms] ?? aduRentFactorMap[1];
    return twoBedRentZestimate * factor;
  })();

  const aduMonthlyRent = Math.max(0, Math.round(derivedADURent));

  // ADU income/expense only
  const aduGrossScheduledIncomeAnnual = (aduMonthlyRent + otherMonthlyIncome) * 12;
  const aduVacancyAnnual = aduGrossScheduledIncomeAnnual * vacancyRate;
  const aduEffectiveGrossIncomeAnnual = aduGrossScheduledIncomeAnnual - aduVacancyAnnual;
  const aduOperatingExpensesAnnual =
    aduEffectiveGrossIncomeAnnual * expenseRatio + otherMonthlyOpEx * 12;
  const aduNOIAnnual = aduEffectiveGrossIncomeAnnual - aduOperatingExpensesAnnual;

  const aduIncomeValue = aduNOIAnnual > 0 ? Math.round(aduNOIAnnual / capRate) : 0;

  const totalIndicatedValue = currentMarketValue + aduIncomeValue;

  return {
    currentMarketValue: Math.round(currentMarketValue),
    aduMonthlyRent,
    aduGrossScheduledIncomeAnnual: Math.round(aduGrossScheduledIncomeAnnual),
    aduVacancyAnnual: Math.round(aduVacancyAnnual),
    aduEffectiveGrossIncomeAnnual: Math.round(aduEffectiveGrossIncomeAnnual),
    aduOperatingExpensesAnnual: Math.round(aduOperatingExpensesAnnual),
    aduNOIAnnual: Math.round(aduNOIAnnual),
    capRate,
    aduIncomeValue,
    totalIndicatedValue: Math.round(totalIndicatedValue),
  };
}

function estimateADUMarketRent(subjectProperty, filteredComps) {
  // Method 1: Use subject property rent-to-price ratio if available
  if (subjectProperty.rentZestimate && subjectProperty.price) {
    const subjectRentRatio = subjectProperty.rentZestimate / subjectProperty.price;

    // Apply ratio to 2BR comp prices to estimate their rents
    const twoBedComps = (filteredComps || []).filter((comp) => {
      const compBeds = comp.beds || 0;
      return compBeds === 2;
    });

    if (twoBedComps.length >= 2) {
      let totalEstimatedRent = 0;
      let validRentEstimates = 0;

      twoBedComps.forEach((comp) => {
        const compPrice = extractCompPriceStrategy(comp);
        if (compPrice > 0) {
          const estimatedRent = compPrice * subjectRentRatio;
          if (estimatedRent >= 500 && estimatedRent <= 10000) { // Loosened rent range
            totalEstimatedRent += estimatedRent;
            validRentEstimates++;
          }
        }
      });

      if (validRentEstimates >= 1) { // Loosened from requiring 2 comps to 1
        const avgEstimatedRent = round(totalEstimatedRent / validRentEstimates);
        console.log(`✅ ADU rent from subject ratio: $${avgEstimatedRent}/mo from ${validRentEstimates} 2BR comps`);
        return avgEstimatedRent;
      }
    }
  }

  // Method 2: Use subject property rent adjusted for ADU size (750 sqft)
  if (subjectProperty.rentZestimate && subjectProperty.livingArea) {
    const subjectRentPerSqft = subjectProperty.rentZestimate / subjectProperty.livingArea;
    const aduRent = round(750 * subjectRentPerSqft * 0.85); // 15% discount for ADU vs main house

    if (aduRent >= 500 && aduRent <= 10000) { // Loosened range
      console.log(`✅ ADU rent from subject sqft ratio: $${aduRent}/mo (750 sqft @ $${subjectRentPerSqft.toFixed(2)}/sqft × 85%)`);
      return aduRent;
    }
  }

  // Method 3: Regional ADU rent estimates based on property value
  if (subjectProperty.price) {
    const propertyValue = subjectProperty.price;
    let estimatedAduRent = 0;

    if (propertyValue >= 1500000) estimatedAduRent = 3200; // High-value areas
    else if (propertyValue >= 1000000) estimatedAduRent = 2600; // Upper-mid areas
    else if (propertyValue >= 700000) estimatedAduRent = 2200; // Mid-range areas
    else if (propertyValue >= 500000) estimatedAduRent = 1800; // Lower-mid areas
    else estimatedAduRent = 1400; // Budget areas

    console.log(`⚠️ ADU rent from regional estimate: $${estimatedAduRent}/mo based on $${propertyValue} property value`);
    return estimatedAduRent;
  }

  return 0;
}

function calculateMarketGRM(subjectProperty, filteredComps) {
  // Calculate Gross Rent Multiplier from subject property if rent data available
  if (subjectProperty.rentZestimate && subjectProperty.price) {
    const monthlyRent = subjectProperty.rentZestimate;
    const propertyPrice = subjectProperty.price;
    const subjectGRM = round(propertyPrice / monthlyRent);

    // Validate GRM is reasonable (expanded range for current market conditions)
    if (subjectGRM >= 5 && subjectGRM <= 300) { // Expanded range to accommodate varying rent data quality
      console.log(`✅ Using subject property GRM: ${subjectGRM} (price: $${propertyPrice}, rent: $${monthlyRent})`);
      return subjectGRM;
    }
  }

  // Fallback: Use market-typical GRM based on property characteristics
  const propertyValue = subjectProperty.price || 500000;
  let marketGRM = 12; // Default

  if (propertyValue >= 1500000) marketGRM = 15; // High-value areas (lower yields)
  else if (propertyValue >= 1000000) marketGRM = 13;
  else if (propertyValue >= 700000) marketGRM = 12;
  else if (propertyValue >= 500000) marketGRM = 11;
  else marketGRM = 10; // Lower-value areas (higher yields)

  console.log(`⚠️ Using market GRM estimate: ${marketGRM} based on property value`);
  return marketGRM;
}

function estimateCapRate(subjectProperty) {
  // Estimate capitalization rate based on property value and location characteristics
  const propertyValue = subjectProperty.price || 500000;
  let capRate = 0.05; // Default 5%

  if (propertyValue >= 1500000) capRate = 0.04; // 4% for high-value areas
  else if (propertyValue >= 1000000) capRate = 0.045; // 4.5%
  else if (propertyValue >= 700000) capRate = 0.05; // 5%
  else if (propertyValue >= 500000) capRate = 0.055; // 5.5%
  else capRate = 0.06; // 6% for lower-value areas

  return capRate;
}

function extractCompPriceStrategy(comp) {
  return comp.data?.aboveTheFold?.addressSectionInfo?.priceInfo?.amount ||
         (typeof comp.price === "object" ? comp.price?.value : comp.price) || 0;
}

function extractCompSqftStrategy(comp) {
  return comp.data?.aboveTheFold?.addressSectionInfo?.sqFt?.value ||
         (typeof comp.sqFt === "object" ? comp.sqFt?.value : comp.sqFt) || 0;
}

module.exports = {
  calculateStrategy,
};

/**
 * Deal Scoring Engine — Port of Operation Alpha's Python deal_scorer.py
 *
 * Scores deals on a 0-100 scale based on 6 weighted components:
 *   1. Acquisition Cost (25%) — lower is better
 *   2. Construction Spread (20%) — higher construction-to-acquisition ratio is better
 *   3. Projected ROI (20%) — higher is better
 *   4. Cash Required (15%) — lower is better
 *   5. Duration (10%) — shorter is better
 *   6. Market Signal (10%) — green > yellow > red
 *
 * Thresholds: GO >= 70, CAUTION >= 50, PASS < 50
 */

// ---------------------------------------------------------------------------
// Tier breakpoints (from thresholds.py)
// ---------------------------------------------------------------------------

const ACQUISITION_TIERS = [
  [150000, 10.0],
  [250000, 8.0],
  [350000, 6.0],
  [500000, 3.0],
  [Infinity, 1.0],
];

const CONSTRUCTION_RATIO_TIERS = [
  [1.0, 10.0],
  [0.50, 8.0],
  [0.25, 5.0],
  [0.0, 2.0],
];

const ROI_TIERS = [
  [0.25, 10.0],
  [0.15, 8.0],
  [0.08, 6.0],
  [0.03, 4.0],
  [0.0, 2.0],
  [-1.0, 0.0],
];

const CASH_REQUIRED_TIERS = [
  [50000, 10.0],
  [80000, 8.0],
  [120000, 5.0],
  [150000, 3.0],
  [Infinity, 1.0],
];

const DURATION_TIERS = [
  [4.0, 10.0],
  [6.0, 8.0],
  [9.0, 5.0],
  [12.0, 3.0],
  [Infinity, 1.0],
];

const MARKET_SIGNAL_SCORES = {
  green: 10.0,
  yellow: 5.0,
  red: 1.0,
};

const COMPONENT_WEIGHTS = {
  acquisition: 0.25,
  construction_spread: 0.20,
  projected_roi: 0.20,
  cash_required: 0.15,
  duration: 0.10,
  market_signal: 0.10,
};

const GO_THRESHOLD = 70.0;
const CAUTION_THRESHOLD = 50.0;

// Bias adjustments (conservative estimates)
const DEFAULT_BIAS = {
  constructionContingency: 0.15,
  arvHaircutGreen: 0.05,
  arvHaircutYellow: 0.10,
  arvHaircutRed: 0.15,
  timelineBuffer: 0.25,
  holdingCostExtraMonths: 2.0,
};

// ---------------------------------------------------------------------------
// Scoring functions
// ---------------------------------------------------------------------------

/**
 * Score a value against tier breakpoints.
 * @param {number} value
 * @param {Array<[number, number]>} tiers
 * @param {boolean} lowerIsBetter
 * @returns {number} Score 0-10
 */
function tierScore(value, tiers, lowerIsBetter = true) {
  if (lowerIsBetter) {
    for (const [threshold, score] of tiers) {
      if (value < threshold) return score;
    }
    return tiers[tiers.length - 1][1];
  } else {
    for (const [threshold, score] of tiers) {
      if (value >= threshold) return score;
    }
    return tiers[tiers.length - 1][1];
  }
}

/**
 * Classify deal against historical winner/loser patterns.
 * @param {object} deal
 * @returns {string} WINNER_PATTERN | LOSER_PATTERN | MIXED
 */
function classifyPattern(deal) {
  const constructionRatio = deal.acquisitionCost > 0
    ? deal.constructionCost / deal.acquisitionCost
    : 0;

  let winnerSignals = 0;
  let loserSignals = 0;

  if (deal.acquisitionCost < 300000) winnerSignals++;
  else if (deal.acquisitionCost > 380000) loserSignals++;

  if (constructionRatio > 0.50) winnerSignals++;
  else if (constructionRatio < 0.25) loserSignals++;

  if (deal.constructionCost > 100000) winnerSignals++;
  else if (deal.constructionCost < 75000) loserSignals++;

  if (winnerSignals >= 2 && loserSignals === 0) return "WINNER_PATTERN";
  if (loserSignals >= 2 && winnerSignals === 0) return "LOSER_PATTERN";
  return "MIXED";
}

/**
 * Score a deal on a 0-100 scale.
 *
 * @param {object} deal - Deal inputs
 * @param {string} deal.name - Property identifier
 * @param {number} deal.acquisitionCost - Purchase price
 * @param {number} deal.constructionCost - Improvement/rehab cost
 * @param {number} deal.arv - After Repair Value
 * @param {number} deal.cashRequired - Cash out of pocket
 * @param {number} [deal.durationMonths=6] - Project duration
 * @param {string} [deal.marketSignal="yellow"] - green/yellow/red
 * @param {number} [deal.monthlyHoldingCost=2500] - Monthly carrying cost
 * @param {number} [deal.sellingCostsPct=0.08] - Selling costs as % of ARV
 * @param {object} [bias] - Bias adjustments (defaults to DEFAULT_BIAS)
 * @returns {object} Score result
 */
function scoreDeal(deal, bias = null) {
  const b = bias || DEFAULT_BIAS;
  const durationMonths = deal.durationMonths || 6;
  const marketSignal = deal.marketSignal || "yellow";
  const monthlyHoldingCost = deal.monthlyHoldingCost || 2500;
  const sellingCostsPct = deal.sellingCostsPct || 0.08;

  // Bias-adjusted values
  const adjConstruction = deal.constructionCost * (1 + b.constructionContingency);
  const arvHaircut = {
    green: b.arvHaircutGreen,
    yellow: b.arvHaircutYellow,
    red: b.arvHaircutRed,
  }[marketSignal] || b.arvHaircutYellow;
  const adjArv = deal.arv * (1 - arvHaircut);
  const adjDuration = durationMonths * (1 + b.timelineBuffer);
  const adjHolding = monthlyHoldingCost * (adjDuration + b.holdingCostExtraMonths);

  // Conservative (bias-adjusted) financials
  const sellingCostsAdj = adjArv * sellingCostsPct;
  const totalCostAdj = deal.acquisitionCost + adjConstruction + adjHolding + sellingCostsAdj;
  const projectedProfitAdj = adjArv - totalCostAdj;
  const projectedRoiAdj = totalCostAdj > 0 ? projectedProfitAdj / totalCostAdj : 0;

  // Raw (base-case) ROI — used for scoring
  const rawHolding = monthlyHoldingCost * durationMonths;
  const rawSellingCosts = deal.arv * sellingCostsPct;
  const rawTotalCost = deal.acquisitionCost + deal.constructionCost + rawHolding + rawSellingCosts;
  const rawProfit = deal.arv - rawTotalCost;
  const rawRoi = rawTotalCost > 0 ? rawProfit / rawTotalCost : 0;

  // Construction-to-acquisition ratio
  const constructionRatio = deal.acquisitionCost > 0
    ? deal.constructionCost / deal.acquisitionCost
    : 0;

  // Score each component
  const components = [];

  // 1. Acquisition Cost (25%)
  const acqScore = tierScore(deal.acquisitionCost, ACQUISITION_TIERS, true);
  components.push({
    name: "Acquisition Cost",
    rawValue: deal.acquisitionCost,
    score: acqScore,
    weight: COMPONENT_WEIGHTS.acquisition,
    weightedScore: acqScore * COMPONENT_WEIGHTS.acquisition,
  });

  // 2. Construction Spread (20%)
  const spreadScore = tierScore(constructionRatio, CONSTRUCTION_RATIO_TIERS, false);
  components.push({
    name: "Construction Spread",
    rawValue: constructionRatio,
    score: spreadScore,
    weight: COMPONENT_WEIGHTS.construction_spread,
    weightedScore: spreadScore * COMPONENT_WEIGHTS.construction_spread,
  });

  // 3. Projected ROI (20%)
  const roiScore = tierScore(rawRoi, ROI_TIERS, false);
  components.push({
    name: "Projected ROI",
    rawValue: rawRoi,
    score: roiScore,
    weight: COMPONENT_WEIGHTS.projected_roi,
    weightedScore: roiScore * COMPONENT_WEIGHTS.projected_roi,
  });

  // 4. Cash Required (15%)
  const cashScore = tierScore(deal.cashRequired, CASH_REQUIRED_TIERS, true);
  components.push({
    name: "Cash Required",
    rawValue: deal.cashRequired,
    score: cashScore,
    weight: COMPONENT_WEIGHTS.cash_required,
    weightedScore: cashScore * COMPONENT_WEIGHTS.cash_required,
  });

  // 5. Duration (10%)
  const durScore = tierScore(durationMonths, DURATION_TIERS, true);
  components.push({
    name: "Duration",
    rawValue: durationMonths,
    score: durScore,
    weight: COMPONENT_WEIGHTS.duration,
    weightedScore: durScore * COMPONENT_WEIGHTS.duration,
  });

  // 6. Market Signal (10%)
  const mktScore = MARKET_SIGNAL_SCORES[marketSignal] || 5.0;
  components.push({
    name: "Market Signal",
    rawValue: mktScore,
    score: mktScore,
    weight: COMPONENT_WEIGHTS.market_signal,
    weightedScore: mktScore * COMPONENT_WEIGHTS.market_signal,
  });

  // Total score (0-100)
  const totalWeighted = components.reduce((sum, c) => sum + c.weightedScore, 0);
  const totalScore = Math.round(totalWeighted * 10);

  // Recommendation
  let recommendation;
  if (totalScore >= GO_THRESHOLD) recommendation = "GO";
  else if (totalScore >= CAUTION_THRESHOLD) recommendation = "CAUTION";
  else recommendation = "PASS";

  // Pattern classification
  const pattern = classifyPattern(deal);

  return {
    dealName: deal.name,
    totalScore,
    recommendation,
    pattern,
    components,
    // Conservative financials
    adjustedArv: Math.round(adjArv),
    adjustedConstruction: Math.round(adjConstruction),
    projectedProfit: Math.round(projectedProfitAdj),
    projectedRoi: projectedRoiAdj,
    // Raw financials
    rawRoi,
    rawProfit: Math.round(rawProfit),
  };
}

/**
 * Map RealDeal strategy calculator output to deal scoring input.
 *
 * @param {object} prop - Property data from propertyProcessor
 * @param {object} result - Strategy calculator result for one method
 * @param {string} [marketSignal="yellow"] - Market signal override
 * @returns {object} Deal object ready for scoreDeal()
 */
function mapStrategyResultToDeal(prop, result, marketSignal = "yellow") {
  return {
    name: prop.address || prop.zpid || "Unknown",
    acquisitionCost: prop.price || 0,
    constructionCost: result.impValue || 0,
    arv: result.futureValue || 0,
    cashRequired: result.cashNeeded || 0,
    durationMonths: result.duration || 6,
    marketSignal: marketSignal,
    monthlyHoldingCost: result.monthlyPayment || 2500,
    sellingCostsPct: result.futureValue > 0
      ? (result.sellingCosts || 0) / result.futureValue
      : 0.08,
  };
}

module.exports = {
  scoreDeal,
  mapStrategyResultToDeal,
  GO_THRESHOLD,
  CAUTION_THRESHOLD,
};

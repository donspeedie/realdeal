import { Property, Comparable, InvestmentStrategy, StrategyCalculationInput, ADUFeasibilityResult } from '@/shared/types';
import { STRATEGY_TYPES, ADU_CONSTRAINTS, CALCULATION_DEFAULTS } from '@/shared/constants';

export class StrategyCalculatorService {
  calculateStrategies(input: StrategyCalculationInput): InvestmentStrategy[] {
    const strategies: InvestmentStrategy[] = [];

    // Calculate Fix & Flip strategy
    const fixFlipStrategy = this.calculateFixFlipStrategy(input);
    if (fixFlipStrategy) strategies.push(fixFlipStrategy);

    // Calculate Add-On strategy
    const addOnStrategy = this.calculateAddOnStrategy(input);
    if (addOnStrategy) strategies.push(addOnStrategy);

    // Calculate ADU strategy
    const aduStrategy = this.calculateADUStrategy(input);
    if (aduStrategy) strategies.push(aduStrategy);

    // Calculate New Build strategy
    const newBuildStrategy = this.calculateNewBuildStrategy(input);
    if (newBuildStrategy) strategies.push(newBuildStrategy);

    // Calculate Rental strategy
    const rentalStrategy = this.calculateRentalStrategy(input);
    if (rentalStrategy) strategies.push(rentalStrategy);

    return strategies;
  }

  private calculateFixFlipStrategy(input: StrategyCalculationInput): InvestmentStrategy | null {
    const { property, comps } = input;

    if (!comps || comps.length === 0) return null;

    // Calculate future value based on comparable sales
    const futureValue = this.calculateCompBasedValue(property, comps);
    const improvementCost = this.estimateImprovementCost(property);
    const totalCost = (property.zestimate || 0) + improvementCost;
    const profit = futureValue - totalCost;
    const roi = totalCost > 0 ? (profit / totalCost) * 100 : 0;

    return {
      type: STRATEGY_TYPES.FIX_AND_FLIP,
      futureValue,
      totalCost,
      profit,
      roi,
      feasible: profit > 0 && roi >= 15, // Minimum 15% ROI for feasibility
      details: {
        improvementCost,
        currentValue: property.zestimate || 0
      }
    };
  }

  private calculateAddOnStrategy(input: StrategyCalculationInput): InvestmentStrategy | null {
    const { property, comps } = input;

    if (!comps || comps.length === 0) return null;

    // Determine target bedroom count (current + 1)
    const currentBedrooms = property.beds || 0;
    const targetBedrooms = currentBedrooms + 1;

    // Filter comps to target bedroom count
    const targetBedroomComps = comps.filter(comp => comp.beds === targetBedrooms);

    if (targetBedroomComps.length === 0) return null;

    // Calculate future area (current + addition)
    const additionSqft = 300; // Standard bedroom addition
    const futureArea = (property.sqft || 0) + additionSqft;

    // Size filtering for similar properties
    const sizeFilteredComps = targetBedroomComps.filter(comp => {
      const sizeRatio = comp.sqft / futureArea;
      return sizeRatio >= CALCULATION_DEFAULTS.SIZE_FILTER_MIN_RATIO &&
             sizeRatio <= CALCULATION_DEFAULTS.SIZE_FILTER_MAX_RATIO;
    });

    if (sizeFilteredComps.length === 0) return null;

    // Calculate average price per sqft from filtered comps
    const avgPricePerSqft = this.calculateAveragePricePerSqft(sizeFilteredComps);

    // Apply cap and floor protection
    const currentPricePerSqft = (property.zestimate || 0) / (property.sqft || 1);
    const cappedPricePerSqft = Math.min(avgPricePerSqft, currentPricePerSqft * 1.5); // 50% cap
    const flooredPricePerSqft = Math.max(cappedPricePerSqft, currentPricePerSqft * 1.1); // 10% floor

    const futureValue = futureArea * flooredPricePerSqft * CALCULATION_DEFAULTS.IMPROVEMENT_FACTOR;
    const additionCost = additionSqft * CALCULATION_DEFAULTS.CONSTRUCTION_COST_PER_SQFT;
    const totalCost = (property.zestimate || 0) + additionCost + CALCULATION_DEFAULTS.PERMIT_COSTS;
    const profit = futureValue - totalCost;
    const roi = totalCost > 0 ? (profit / totalCost) * 100 : 0;

    return {
      type: STRATEGY_TYPES.ADD_ON,
      futureValue,
      totalCost,
      profit,
      roi,
      feasible: profit > 0 && roi >= 20, // Minimum 20% ROI for Add-On
      details: {
        currentBedrooms,
        targetBedrooms,
        additionSqft,
        additionCost,
        avgPricePerSqft,
        usedComps: sizeFilteredComps.length
      }
    };
  }

  private calculateADUStrategy(input: StrategyCalculationInput): InvestmentStrategy | null {
    const { property, comps } = input;

    // Check ADU lot feasibility
    const feasibility = this.checkADULotFeasibility(property);
    if (!feasibility.feasible) {
      return {
        type: STRATEGY_TYPES.ADU,
        futureValue: 0,
        totalCost: 0,
        profit: 0,
        roi: 0,
        feasible: false,
        details: {
          feasibilityReason: feasibility.reason,
          feasibilityDetails: feasibility.details
        }
      };
    }

    // Calculate future value based on comparable properties + ADU rent
    const futureValue = this.calculateADUFutureValue(property, comps, input.rentData);
    const aduConstructionCost = 120000; // Standard ADU construction cost
    const totalCost = (property.zestimate || 0) + aduConstructionCost;
    const profit = futureValue - totalCost;
    const roi = totalCost > 0 ? (profit / totalCost) * 100 : 0;

    return {
      type: STRATEGY_TYPES.ADU,
      futureValue,
      totalCost,
      profit,
      roi,
      feasible: profit > 0 && roi >= 25, // Minimum 25% ROI for ADU
      details: {
        aduConstructionCost,
        feasibilityDetails: feasibility.details
      }
    };
  }

  private calculateNewBuildStrategy(input: StrategyCalculationInput): InvestmentStrategy | null {
    const { property, comps } = input;

    if (!comps || comps.length === 0) return null;

    // Estimate demolition + new construction
    const newHomeSqft = Math.max(2000, (property.sqft || 0) * 1.2); // Larger new home
    const avgPricePerSqft = this.calculateAveragePricePerSqft(comps);
    const futureValue = newHomeSqft * avgPricePerSqft;

    const demolitionCost = 15000;
    const constructionCost = newHomeSqft * CALCULATION_DEFAULTS.CONSTRUCTION_COST_PER_SQFT;
    const totalCost = (property.zestimate || 0) + demolitionCost + constructionCost;
    const profit = futureValue - totalCost;
    const roi = totalCost > 0 ? (profit / totalCost) * 100 : 0;

    return {
      type: STRATEGY_TYPES.NEW_BUILD,
      futureValue,
      totalCost,
      profit,
      roi,
      feasible: profit > 0 && roi >= 20,
      details: {
        newHomeSqft,
        demolitionCost,
        constructionCost
      }
    };
  }

  private calculateRentalStrategy(input: StrategyCalculationInput): InvestmentStrategy | null {
    const { property, rentData } = input;

    if (!rentData?.rentZestimate) return null;

    const monthlyRent = rentData.rentZestimate;
    const annualRent = monthlyRent * 12;
    const propertyValue = property.zestimate || 0;

    // Calculate rental yield
    const rentalYield = propertyValue > 0 ? (annualRent / propertyValue) * 100 : 0;

    // Estimate property value in 5 years with appreciation
    const futureValue = propertyValue * Math.pow(1 + CALCULATION_DEFAULTS.DEFAULT_APPRECIATION_RATE, 5);
    const totalRentOver5Years = annualRent * 5;
    const totalReturn = (futureValue - propertyValue) + totalRentOver5Years;
    const roi = propertyValue > 0 ? (totalReturn / propertyValue) * 100 : 0;

    return {
      type: STRATEGY_TYPES.RENTAL,
      futureValue: futureValue + totalRentOver5Years,
      totalCost: propertyValue,
      profit: totalReturn,
      roi,
      feasible: rentalYield >= 1, // Minimum 1% monthly yield
      details: {
        monthlyRent,
        annualRent,
        rentalYield,
        totalRentOver5Years
      }
    };
  }

  private checkADULotFeasibility(property: Property): ADUFeasibilityResult {
    const lotAreaSqft = property.lotAreaSqft || 0;
    const houseSqft = property.sqft || 0;

    // Check minimum lot size
    if (lotAreaSqft < ADU_CONSTRAINTS.MIN_LOT_SIZE_SQFT) {
      return {
        feasible: false,
        reason: `Lot too small: ${lotAreaSqft} sqft < ${ADU_CONSTRAINTS.MIN_LOT_SIZE_SQFT} sqft minimum`,
        details: {
          lotAreaSqft,
          minLotSizeForADU: ADU_CONSTRAINTS.MIN_LOT_SIZE_SQFT,
          houseSqft,
          houseFootprint: 0,
          availableSpace: 0,
          requiredSpace: ADU_CONSTRAINTS.REQUIRED_ADU_SPACE_SQFT,
          houseToLotRatio: 0,
          maxAllowedRatio: ADU_CONSTRAINTS.MAX_HOUSE_TO_LOT_RATIO
        }
      };
    }

    // Calculate house footprint (accounting for multi-story)
    const houseFootprint = houseSqft / ADU_CONSTRAINTS.MULTI_STORY_FOOTPRINT_DIVISOR;

    // Check house-to-lot ratio
    const houseToLotRatio = houseFootprint / lotAreaSqft;
    if (houseToLotRatio > ADU_CONSTRAINTS.MAX_HOUSE_TO_LOT_RATIO) {
      return {
        feasible: false,
        reason: `House-to-lot ratio too high: ${(houseToLotRatio * 100).toFixed(1)}% > ${(ADU_CONSTRAINTS.MAX_HOUSE_TO_LOT_RATIO * 100).toFixed(1)}%`,
        details: {
          lotAreaSqft,
          minLotSizeForADU: ADU_CONSTRAINTS.MIN_LOT_SIZE_SQFT,
          houseSqft,
          houseFootprint,
          availableSpace: 0,
          requiredSpace: ADU_CONSTRAINTS.REQUIRED_ADU_SPACE_SQFT,
          houseToLotRatio,
          maxAllowedRatio: ADU_CONSTRAINTS.MAX_HOUSE_TO_LOT_RATIO
        }
      };
    }

    // Calculate available space after setbacks
    const availableSpace = lotAreaSqft * (1 - ADU_CONSTRAINTS.SETBACK_PERCENTAGE) - houseFootprint;

    if (availableSpace < ADU_CONSTRAINTS.REQUIRED_ADU_SPACE_SQFT) {
      return {
        feasible: false,
        reason: `Insufficient space: ${availableSpace.toFixed(0)} sqft available < ${ADU_CONSTRAINTS.REQUIRED_ADU_SPACE_SQFT} sqft required`,
        details: {
          lotAreaSqft,
          minLotSizeForADU: ADU_CONSTRAINTS.MIN_LOT_SIZE_SQFT,
          houseSqft,
          houseFootprint,
          availableSpace,
          requiredSpace: ADU_CONSTRAINTS.REQUIRED_ADU_SPACE_SQFT,
          houseToLotRatio,
          maxAllowedRatio: ADU_CONSTRAINTS.MAX_HOUSE_TO_LOT_RATIO
        }
      };
    }

    return {
      feasible: true,
      details: {
        lotAreaSqft,
        minLotSizeForADU: ADU_CONSTRAINTS.MIN_LOT_SIZE_SQFT,
        houseSqft,
        houseFootprint,
        availableSpace,
        requiredSpace: ADU_CONSTRAINTS.REQUIRED_ADU_SPACE_SQFT,
        houseToLotRatio,
        maxAllowedRatio: ADU_CONSTRAINTS.MAX_HOUSE_TO_LOT_RATIO
      }
    };
  }

  private calculateCompBasedValue(property: Property, comps: Comparable[]): number {
    const avgPricePerSqft = this.calculateAveragePricePerSqft(comps);
    return (property.sqft || 0) * avgPricePerSqft;
  }

  private calculateAveragePricePerSqft(comps: Comparable[]): number {
    if (comps.length === 0) return 0;
    const total = comps.reduce((sum, comp) => sum + comp.pricePerSqft, 0);
    return total / comps.length;
  }

  private calculateADUFutureValue(property: Property, comps: Comparable[], rentData?: any): number {
    const mainHouseValue = this.calculateCompBasedValue(property, comps);
    const aduRentValue = rentData?.rentZestimate ? rentData.rentZestimate * 12 * 10 : 100000; // 10x annual rent or default
    return mainHouseValue + aduRentValue;
  }

  private estimateImprovementCost(property: Property): number {
    const sqft = property.sqft || 0;
    const age = property.yearBuilt ? new Date().getFullYear() - property.yearBuilt : 50;

    // Base improvement cost per sqft based on age
    let costPerSqft = 50; // Base cost
    if (age > 50) costPerSqft = 100;
    else if (age > 30) costPerSqft = 75;

    return sqft * costPerSqft;
  }
}
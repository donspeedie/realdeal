export interface Property {
  address: string;
  city: string;
  state: string;
  zipcode: string;
  beds: number;
  baths: number;
  sqft: number;
  lotAreaSqft?: number;
  yearBuilt?: number;
  propertyType?: string;
  zestimate?: number;
  rentZestimate?: number;
  stories?: number;
}

export interface Comparable {
  address: string;
  city: string;
  state: string;
  zipcode: string;
  beds: number;
  baths: number;
  sqft: number;
  salePrice: number;
  saleDate: string;
  daysSold: number;
  pricePerSqft: number;
  yearBuilt?: number;
  lotAreaSqft?: number;
}

export interface InvestmentStrategy {
  type: 'Fix & Flip' | 'Add-On' | 'ADU' | 'New Build' | 'Rental';
  futureValue: number;
  totalCost: number;
  profit: number;
  roi: number;
  feasible: boolean;
  details?: Record<string, any>;
}

export interface StrategyCalculationInput {
  property: Property;
  comps: Comparable[];
  rentData?: RentData;
  marketConditions?: MarketConditions;
}

export interface RentData {
  rentZestimate: number;
  rentLow?: number;
  rentHigh?: number;
}

export interface MarketConditions {
  appreciationRate?: number;
  constructionCostPerSqft?: number;
  permitCosts?: number;
}

export interface ADUFeasibilityResult {
  feasible: boolean;
  reason?: string;
  details: {
    lotAreaSqft: number;
    minLotSizeForADU: number;
    houseSqft: number;
    houseFootprint: number;
    availableSpace: number;
    requiredSpace: number;
    houseToLotRatio: number;
    maxAllowedRatio: number;
  };
}

export interface CalculationResult {
  strategies: InvestmentStrategy[];
  property: Property;
  comps: Comparable[];
  timestamp: string;
}
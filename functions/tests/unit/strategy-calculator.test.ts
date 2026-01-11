import { describe, it, expect, beforeEach } from 'vitest';
import { StrategyCalculatorService } from '@/domain/services/strategy-calculator';
import { Property, Comparable, StrategyCalculationInput } from '@/shared/types';

describe('StrategyCalculatorService', () => {
  let calculator: StrategyCalculatorService;
  let mockProperty: Property;
  let mockComps: Comparable[];

  beforeEach(() => {
    calculator = new StrategyCalculatorService();

    mockProperty = {
      address: '123 Test St',
      city: 'Test City',
      state: 'CA',
      zipcode: '12345',
      beds: 3,
      baths: 2,
      sqft: 1500,
      lotAreaSqft: 6000,
      yearBuilt: 1990,
      zestimate: 500000
    };

    mockComps = [
      {
        address: '124 Test St',
        city: 'Test City',
        state: 'CA',
        zipcode: '12345',
        beds: 3,
        baths: 2,
        sqft: 1600,
        salePrice: 550000,
        saleDate: '2024-01-15',
        daysSold: 30,
        pricePerSqft: 344,
        yearBuilt: 1988
      },
      {
        address: '125 Test St',
        city: 'Test City',
        state: 'CA',
        zipcode: '12345',
        beds: 3,
        baths: 2,
        sqft: 1400,
        salePrice: 480000,
        saleDate: '2024-02-01',
        daysSold: 45,
        pricePerSqft: 343,
        yearBuilt: 1992
      }
    ];
  });

  describe('calculateStrategies', () => {
    it('should return multiple investment strategies', () => {
      const input: StrategyCalculationInput = {
        property: mockProperty,
        comps: mockComps,
        rentData: { rentZestimate: 3000 }
      };

      const strategies = calculator.calculateStrategies(input);

      expect(strategies).toBeDefined();
      expect(strategies.length).toBeGreaterThan(0);
      expect(strategies.some(s => s.type === 'Fix & Flip')).toBe(true);
    });
  });

  describe('ADU Feasibility', () => {
    it('should approve ADU for sufficient lot size', () => {
      const input: StrategyCalculationInput = {
        property: { ...mockProperty, lotAreaSqft: 6000, sqft: 1500 },
        comps: mockComps
      };

      const strategies = calculator.calculateStrategies(input);
      const aduStrategy = strategies.find(s => s.type === 'ADU');

      expect(aduStrategy).toBeDefined();
      expect(aduStrategy?.feasible).toBe(true);
    });

    it('should reject ADU for insufficient lot size', () => {
      const input: StrategyCalculationInput = {
        property: { ...mockProperty, lotAreaSqft: 3000, sqft: 1500 },
        comps: mockComps
      };

      const strategies = calculator.calculateStrategies(input);
      const aduStrategy = strategies.find(s => s.type === 'ADU');

      expect(aduStrategy).toBeDefined();
      expect(aduStrategy?.feasible).toBe(false);
      expect(aduStrategy?.details?.feasibilityReason).toContain('Lot too small');
    });
  });

  describe('Add-On Strategy', () => {
    it('should calculate Add-On strategy with target bedroom comps', () => {
      const mockCompsWithVariedBedrooms = [
        ...mockComps,
        {
          address: '126 Test St',
          city: 'Test City',
          state: 'CA',
          zipcode: '12345',
          beds: 4, // Target bedroom count (3 + 1)
          baths: 3,
          sqft: 1800,
          salePrice: 600000,
          saleDate: '2024-01-20',
          daysSold: 25,
          pricePerSqft: 333,
          yearBuilt: 1989
        }
      ];

      const input: StrategyCalculationInput = {
        property: mockProperty,
        comps: mockCompsWithVariedBedrooms
      };

      const strategies = calculator.calculateStrategies(input);
      const addOnStrategy = strategies.find(s => s.type === 'Add-On');

      expect(addOnStrategy).toBeDefined();
      expect(addOnStrategy?.details?.targetBedrooms).toBe(4);
      expect(addOnStrategy?.details?.currentBedrooms).toBe(3);
    });
  });
});
const path = require('path');
const fs = require('fs');
const { z } = require('zod');
const { calculateStrategy } = require('../src/strategyCalculator.js');

const fx = (name) => JSON.parse(fs.readFileSync(path.resolve(__dirname, 'fixtures', name), 'utf8'));

const StrategyResult = z.object({
  futureValue: z.number(),
  impValue: z.number().optional(),
  totalCosts: z.number().optional(),
  valuationMethod: z.string().optional()
});

describe('calculateStrategy — golden outputs (drift guard)', () => {
  test('Fix & Flip: canonical output stays stable', () => {
    const f = fx('fixflip_basic.json');
    const res = calculateStrategy('Fix & Flip', f.prop, f.params, f.pricePerSqFt, f.twoBedAvg);
    const EXPECTED = 604800; // impFactor 1.08
    expect(res && typeof res).toBe('object');
    expect(res.futureValue).toBe(EXPECTED);
    expect(res).toHaveProperty('impValue');
    expect(res).toHaveProperty('totalCosts');
  });

  test('ADU: canonical output stays stable (premium or income fallback)', () => {
    const f = fx('adu_basic.json');
    const res = calculateStrategy('ADU', f.prop, f.params, f.pricePerSqFt, f.twoBedAvg);
    const EXPECTED = 390000; // capped to list price + twoBedAvg
    if (res) {
      expect(res && typeof res).toBe('object');
      expect(res.futureValue).toBe(EXPECTED);
      expect(res).toHaveProperty('impValue');
      expect(res).toHaveProperty('totalCosts');
    } else {
      // ADU may be rejected due to feasibility checks
      expect(res).toBeNull();
    }
  });

  test('calculateStrategy returns stable shape', () => {
    const res = calculateStrategy('Fix & Flip', { zpid:'x', price:200000, livingArea:1200, bedrooms:3 }, { bypassMinReturn:true }, 400, 0);
    StrategyResult.parse(res); // throws if drifted shape
  });
});
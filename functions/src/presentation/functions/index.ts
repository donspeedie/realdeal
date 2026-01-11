import { https } from 'firebase-functions';
import { StrategyCalculatorService } from '@/domain/services/strategy-calculator';
import { Property, Comparable, StrategyCalculationInput } from '@/shared/types';

const strategyCalculator = new StrategyCalculatorService();

export const cloudCalcs = https.onRequest(async (req, res) => {
  try {
    // Set CORS headers
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.status(204).send('');
      return;
    }

    if (req.method !== 'POST') {
      res.status(405).json({ error: 'Method not allowed' });
      return;
    }

    const { property, comps, rentData, marketConditions } = req.body;

    if (!property || !comps) {
      res.status(400).json({ error: 'Property and comps are required' });
      return;
    }

    const input: StrategyCalculationInput = {
      property: property as Property,
      comps: comps as Comparable[],
      rentData,
      marketConditions
    };

    const strategies = strategyCalculator.calculateStrategies(input);

    res.json({
      strategies,
      property,
      timestamp: new Date().toISOString()
    });

  } catch (error) {
    console.error('Error in cloudCalcs function:', error);
    res.status(500).json({
      error: 'Internal server error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});
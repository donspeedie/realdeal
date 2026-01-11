import { beforeEach, vi } from 'vitest';

// Mock Firebase Admin
vi.mock('firebase-admin', () => ({
  apps: [],
  initializeApp: vi.fn(),
  firestore: vi.fn(() => ({
    collection: vi.fn(() => ({
      doc: vi.fn(() => ({
        get: vi.fn(),
        set: vi.fn(),
        update: vi.fn(),
        delete: vi.fn()
      }))
    }))
  })),
  FieldValue: {
    serverTimestamp: vi.fn()
  }
}));

// Mock Firebase Functions
vi.mock('firebase-functions', () => ({
  https: {
    onRequest: vi.fn()
  },
  config: vi.fn(() => ({}))
}));

// Setup environment variables
beforeEach(() => {
  process.env.RAPID_API_KEY = 'test-key';
});
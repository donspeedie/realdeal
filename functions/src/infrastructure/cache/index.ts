import * as admin from 'firebase-admin';

if (admin.apps.length === 0) {
  admin.initializeApp();
}

const db = admin.firestore();

// Expiry time in milliseconds (e.g., 1 hour = 3600000 ms)
const CACHE_EXPIRY_MS = 3600000 * 24; // 24 hours

export interface CacheDocument {
  cacheData: any;
  createdAt: admin.firestore.Timestamp;
}

export async function getCachedOrFetch<T>(
  collection: string,
  docId: string,
  fetchFunc: () => Promise<T>
): Promise<T> {
  const docRef = db.collection(collection).doc(docId);
  const docSnap = await docRef.get();

  if (docSnap.exists) {
    const data = docSnap.data() as CacheDocument;
    const { cacheData, createdAt } = data;

    if (createdAt && createdAt.toMillis && (Date.now() - createdAt.toMillis() < CACHE_EXPIRY_MS)) {
      // Cache is still fresh
      return cacheData as T;
    }
    // Cache expired, fall through to fetch new data
  }

  // Fetch from API if not cached or expired
  const result = await fetchFunc();

  // Firestore cannot store undefined, functions, non-plain objects, etc.
  const cacheData = typeof result === "object" && result !== null && !Array.isArray(result) ?
    JSON.parse(JSON.stringify(result)) : // removes non-serializable values
    result;

  // Cache result with a new timestamp
  await docRef.set({
    cacheData,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return result;
}
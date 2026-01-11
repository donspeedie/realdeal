const admin = require("firebase-admin");
if (admin.apps.length === 0) admin.initializeApp();
const db = admin.firestore();

// Expiry time in milliseconds (e.g., 1 hour = 3600000 ms)
const CACHE_EXPIRY_MS = 3600000 * 24; // Set as you prefer

async function getCachedOrFetch(collection, docId, fetchFunc) {
  const docRef = db.collection(collection).doc(docId);
  const docSnap = await docRef.get();

  if (docSnap.exists) {
    const {cacheData, createdAt} = docSnap.data();
    if (createdAt && createdAt.toMillis && (Date.now() - createdAt.toMillis() < CACHE_EXPIRY_MS)) {
      // Cache is still fresh
      return cacheData;
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

module.exports = {getCachedOrFetch};

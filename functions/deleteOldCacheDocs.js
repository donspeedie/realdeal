const functions = require("firebase-functions");
const admin = require("firebase-admin");
if (admin.apps.length === 0) admin.initializeApp();
const db = admin.firestore();

const CACHE_COLLECTIONS = [
  "zillow_propertyExtendedSearch",
  "zillow_zestimate",
  "zillow_propertyDetails",
  "redfin_propertySearch",
  // add any other cache collection names here
];

// Batch limit (Firestore max is 500)
const BATCH_SIZE = 500;

// Runs every hour or set your own cron schedule ("every 2 hours", "every day", etc)
exports.deleteOldCacheDocs = functions.pubsub
    .schedule("every 1 hours") // or "every day 00:00"
    .onRun(async (context) => {
      const now = Date.now();
      const cutoff = now - 24 * 60 * 60 * 1000; // 24 hours in ms
      let totalDeleted = 0;

      for (const collectionName of CACHE_COLLECTIONS) {
        const snapshot = await db
            .collection(collectionName)
            .where("createdAt", "<", admin.firestore.Timestamp.fromMillis(cutoff))
            .limit(BATCH_SIZE)
            .get();

        if (snapshot.size === 0) continue;

        const batch = db.batch();
        snapshot.docs.forEach((doc) => {
          batch.delete(doc.ref);
        });
        await batch.commit();
        totalDeleted += snapshot.size;
      }

      console.log(`Deleted ${totalDeleted} old cache docs`);
      return null;
    });

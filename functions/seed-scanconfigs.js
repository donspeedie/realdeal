/**
 * Seed/update scanConfigs for all 11 target markets
 * Run: cd functions && node seed-scanconfigs.js
 *
 * This will:
 * 1. Delete all existing scanConfigs
 * 2. Create 11 new scanConfigs (7 Central Valley + 4 Sacramento Metro)
 */
const admin = require("firebase-admin");
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  projectId: "habu-1gxak2",
});
const db = admin.firestore();

const SHARED_CONFIG = {
  active: true,
  propertyType: "SINGLE_FAMILY",
  status_Type: "FOR_SALE",
  minPrice: 150000,
  maxPrice: 500000,
  maxPages: 5,
  minReturn: 25000,
  minROI: 0.15,
  notifyEmail: "donspeedie@gmail.com",
};

const MARKETS = [
  // Central Valley (7)
  {name: "Patterson $150K-$500K", location: "Patterson, CA"},
  {name: "Modesto $150K-$500K", location: "Modesto, CA"},
  {name: "Turlock $150K-$500K", location: "Turlock, CA"},
  {name: "Stockton $150K-$500K", location: "Stockton, CA"},
  {name: "Tracy $150K-$500K", location: "Tracy, CA"},
  {name: "Manteca $150K-$500K", location: "Manteca, CA"},
  {name: "Ripon $150K-$500K", location: "Ripon, CA"},
  // Sacramento Metro (4)
  {name: "Sacramento $150K-$500K", location: "Sacramento, CA"},
  {name: "Elk Grove $150K-$500K", location: "Elk Grove, CA"},
  {name: "Roseville $150K-$500K", location: "Roseville, CA"},
  {name: "Folsom $150K-$500K", location: "Folsom, CA"},
];

async function seed() {
  console.log("=== Seeding scanConfigs ===\n");

  // 1. Delete existing scanConfigs
  const existing = await db.collection("scanConfigs").get();
  if (!existing.empty) {
    console.log(`Deleting ${existing.size} existing scanConfigs...`);
    const batch = db.batch();
    existing.forEach((doc) => batch.delete(doc.ref));
    await batch.commit();
    console.log("  Deleted.\n");
  }

  // 2. Create new scanConfigs
  console.log(`Creating ${MARKETS.length} scanConfigs...`);
  const batch = db.batch();
  for (const market of MARKETS) {
    const docRef = db.collection("scanConfigs").doc();
    batch.set(docRef, {
      ...SHARED_CONFIG,
      ...market,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log(`  + ${market.name} (${market.location})`);
  }
  await batch.commit();

  console.log(`\nDone! ${MARKETS.length} scanConfigs created.`);

  // 3. Verify
  const verify = await db.collection("scanConfigs").where("active", "==", true).get();
  console.log(`\nVerification: ${verify.size} active scanConfigs`);
  verify.forEach((doc) => {
    const d = doc.data();
    console.log(`  [${doc.id}] ${d.name} | ${d.location} | $${d.minPrice}-$${d.maxPrice} | notify=${d.notifyEmail}`);
  });

  process.exit(0);
}

seed().catch((err) => {
  console.error("Seed failed:", err.message);
  process.exit(1);
});

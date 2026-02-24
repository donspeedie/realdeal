/**
 * Trigger the deal scanner manually by calling the scanDealsDaily logic directly.
 * Writes deals incrementally to Firestore so partial runs still produce results.
 */
const admin = require("firebase-admin");
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  projectId: "habu-1gxak2",
});
const db = admin.firestore();

if (!process.env.RAPID_API_KEY) {
  console.error("RAPID_API_KEY env var required. Run with:");
  console.error("  RAPID_API_KEY=<key> node trigger-scan.js");
  process.exit(1);
}

const {fetchZillowDataWithCache} = require("./zillowApi");
const {processProperty} = require("./propertyProcessor");
const {scoreDeal, mapStrategyResultToDeal} = require("./dealScoringEngine");

// Timeout wrapper - skip property if it takes too long (Redfin hangs)
function withTimeout(promise, ms, label) {
  return Promise.race([
    promise,
    new Promise((_, reject) =>
      setTimeout(() => reject(new Error(`Timeout after ${ms}ms: ${label}`)), ms),
    ),
  ]);
}

async function loadUserCalcParams(db, email) {
  const snap = await db.collection("UserData")
    .where("email", "==", email).limit(1).get();
  if (snap.empty) return {};
  const u = snap.docs[0].data();
  const params = {};
  if (u.interestRate) params.interestRate = u.interestRate;
  if (u.closingCostRate) params.closingCostRate = u.closingCostRate;
  if (u.improvementRate) params.improvementRate = u.improvementRate;
  if (u.salRate) params.salRate = u.salRate;
  if (u.loanFeesRate) params.loanFeesRate = u.loanFeesRate;
  if (u.permitsFees) params.permitsFees = u.permitsFees;
  if (u.minimumReturn) params.minReturn = u.minimumReturn;
  return params;
}

async function runScan() {
  console.log("[Scan] Starting manual scan...\n");
  const startTime = Date.now();

  const configsSnap = await db.collection("scanConfigs")
    .where("active", "==", true).get();

  if (configsSnap.empty) {
    console.log("[Scan] No active scan configs!");
    return;
  }

  console.log(`[Scan] Found ${configsSnap.size} active configs\n`);

  // Dedup against recent alerts
  const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
  const existingSnap = await db.collection("dealAlerts")
    .where("scannedAt", ">=", weekAgo).get();
  const existingKeys = new Set();
  existingSnap.docs.forEach((d) => {
    const data = d.data();
    existingKeys.add(`${data.zpid}_${data.method}`);
  });
  console.log(`[Scan] ${existingKeys.size} existing alerts (dedup)\n`);

  const notifyEmails = new Set();
  for (const doc of configsSnap.docs) {
    const cfg = doc.data();
    if (cfg.notifyEmail) notifyEmails.add(cfg.notifyEmail);
  }
  const primaryEmail = [...notifyEmails][0];
  const userCalcParams = primaryEmail ? await loadUserCalcParams(db, primaryEmail) : {};

  let totalDeals = 0;
  let totalScanned = 0;
  const allDeals = [];

  for (const doc of configsSnap.docs) {
    const cfg = doc.data();
    const label = cfg.name || cfg.location;
    console.log(`[Scan] === ${label} ===`);

    try {
      const maxPages = cfg.maxPages || 5;
      let marketScanned = 0;
      let marketDeals = 0;

      for (let page = 1; page <= maxPages; page++) {
        let response;
        try {
          response = await fetchZillowDataWithCache("propertyExtendedSearch", {
            location: cfg.location,
            page,
            status_Type: cfg.status_Type || "FOR_SALE",
            propertyType: cfg.propertyType || "SINGLE_FAMILY",
            minPrice: cfg.minPrice,
            maxPrice: cfg.maxPrice,
          });
        } catch (fetchErr) {
          console.error(`  API fetch failed page ${page}: ${fetchErr.message}`);
          break;
        }

        const props = response?.data?.props || [];
        console.log(`  Page ${page}: ${props.length} properties`);
        if (props.length === 0) break;

        marketScanned += props.length;

        for (let i = 0; i < props.length; i++) {
          try {
            // Skip Redfin API calls (pass empty comps) — use zestimate for ARV
            // Redfin rate limits make full scans impossibly slow
            const results = await withTimeout(
              processProperty(props[i], {
                ...userCalcParams,
                minReturn: cfg.minReturn || 25000,
                redfinSoldComps: [],
                redfinForSaleComps: [],
              }, marketScanned - props.length + i + 1, marketScanned),
              20000,
              props[i].address || `zpid:${props[i].zpid}`,
            );

            for (const r of results) {
              if (!r) continue;
              const key = `${r.zpid}_${r.method}`;
              if (existingKeys.has(key)) continue;

              const meetsReturn = r.netReturn >= (cfg.minReturn || 25000);
              const meetsROI = r.netROI >= (cfg.minROI || 0.15);

              if (meetsReturn && meetsROI) {
                existingKeys.add(key);
                let dealScore = null;
                try {
                  const dealInput = mapStrategyResultToDeal(props[i], r);
                  dealScore = scoreDeal(dealInput);
                } catch (e) {}

                const deal = {
                  ...r,
                  scanConfig: label,
                  score: dealScore ? dealScore.totalScore : null,
                  recommendation: dealScore ? dealScore.recommendation : null,
                  scannedAt: admin.firestore.FieldValue.serverTimestamp(),
                };

                // Write immediately to Firestore
                await db.collection("dealAlerts").add(deal);
                totalDeals++;
                marketDeals++;
                allDeals.push(deal);
                console.log(`  ** DEAL: ${r.address} | ${r.method} | $${r.netReturn?.toLocaleString()} | ROI=${((r.netROI||0)*100).toFixed(1)}% | Score=${dealScore?.totalScore || "N/A"}`);
              }
            }
          } catch (err) {
            if (err.message?.includes("Timeout")) {
              console.log(`  [skip] ${props[i].address || props[i].zpid} - timeout`);
            }
            // Skip property errors silently
          }
        }

        if (props.length < 35) break;
      }

      totalScanned += marketScanned;
      console.log(`  Scanned: ${marketScanned} | Deals: ${marketDeals}\n`);
    } catch (err) {
      console.error(`  Error: ${err.message}\n`);
    }
  }

  const elapsed = ((Date.now() - startTime) / 1000 / 60).toFixed(1);
  console.log(`\n[Scan] COMPLETE in ${elapsed} min`);
  console.log(`[Scan] ${totalScanned} properties scanned | ${totalDeals} qualifying deals`);

  if (allDeals.length > 0) {
    console.log("\nTop deals by score:");
    allDeals.sort((a, b) => (b.score || 0) - (a.score || 0));
    allDeals.slice(0, 15).forEach((d, i) => {
      console.log(`  ${i + 1}. ${d.address} | ${d.method} | $${d.netReturn?.toLocaleString()} | ROI=${((d.netROI || 0) * 100).toFixed(1)}% | Score=${d.score || "N/A"} | ${d.scanConfig}`);
    });
  }

  process.exit(0);
}

runScan().catch((err) => {
  console.error("Scan failed:", err.message);
  process.exit(1);
});

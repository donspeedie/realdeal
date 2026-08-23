require("dotenv").config();

const {onRequest, onCall, HttpsError} = require("firebase-functions/v2/https");
const {onDocumentUpdated, onDocumentCreated} = require("firebase-functions/v2/firestore");
const {setGlobalOptions} = require("firebase-functions/v2/options");
const {defineSecret} = require("firebase-functions/params");
const admin = require("firebase-admin");

// Secrets managed via Firebase Secret Manager (not functions.config)
// Set with: firebase functions:secrets:set OA_DATA_API_URL
const oaDataApiUrl = defineSecret("OA_DATA_API_URL");
const hubspotApiKey = defineSecret("HUBSPOT_API_KEY");
const sendgridApiKey = defineSecret("SENDGRID_API_KEY");
const {initSSE} = require("./sseWriter");
const {requireFirebaseAuth} = require("./authGuard");
const {fetchZillowDataWithCache} = require("./oaDataApi");
const {processProperty} = require("./propertyProcessor");
const {trackPropertyCalculation, createOrUpdateContact, findContactByEmail} = require("./hubspotIntegration");
const {scoreDeal, mapStrategyResultToDeal} = require("./dealScoringEngine");
const {createFluidCMProject} = require("./fluidcmHandoff");

if (admin.apps.length === 0) admin.initializeApp();

exports.autoRecalculateSavedPropertyV2 = onDocumentUpdated({
  document: "savedProperties/{docId}",
  region: "us-west1",
  memory: "512MiB",
  timeoutSeconds: 540,
  concurrency: 10,
  secrets: [oaDataApiUrl],
}, async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  console.log(before);
  console.log(after);
  const BASE_FIELDS = [
    "price", "impValue", "loanPayments", "loanFees", "sellingCosts",
    "permitsFees", "propertyTaxes", "propertyIns", "livingArea", "method",
    "futureValue","redfinSoldComps","redfinForSaleComps"
    // Add more override-allowed fields here if desired
  ];
  const changedFields = BASE_FIELDS.filter((key) => before?.[key] !== after?.[key]);
  console.log("Changed fields:", changedFields);
  if (changedFields.length === 0) return;
  const overrideFields = {};
  BASE_FIELDS.forEach((key) => {
    if (changedFields.includes(key) && typeof after[key] !== "undefined" && after[key] !== null) {
      overrideFields[key] = after[key];
    }
  });
  const prop = {...after};
  if (!prop.zpid && prop.id) prop.zpid = prop.id;
  Object.assign(prop, overrideFields); // Apply overrides
  try {
    const calculationParams = {...overrideFields, bypassMinReturn: true};
    const resultsArr = await processProperty(prop, calculationParams, 1, 1);
    const result = resultsArr.find((r) => r.method === prop.method) || resultsArr[0];
    if (!result) {
      console.warn(`No calculation result for property ${event.params.docId}`);
      return;
    }
    const FIELDS_TO_UPDATE = [
      "totalCosts", "netReturn", "roe", "groc", "sellingCosts",
      "loanPayments", "loanFees", "propertyTaxes", "propertyIns", "impValue",
      "zestimate", "cashNeeded", "irr", "dscr", "avgPricePerSqFt", "grossReturn",
      "futureValue",
    ];
    const updateObj = {};
    FIELDS_TO_UPDATE.forEach((key) => {
      if (Object.hasOwn(overrideFields, key)) {
        // Skip user-edited fields - they're already in the database
        // Only update with calculated values
        return;
      } else if (typeof result[key] !== "undefined") {
        updateObj[key] = result[key];
      }
    });
    if (Object.keys(updateObj).length > 0) {
      await event.data.after.ref.update(updateObj);
      console.log(`Recalculated savedProperties/${event.params.docId}:`, updateObj);
    }
  } catch (error) {
    console.error("Error in auto recalculation (v2 override-aware):", error);
  }
});

// Final safety function to ensure FlutterFlow compatibility
function ensureFlutterFlowCompatibility(obj) {
  if (obj === null || obj === undefined) {
    return {error: "Null object"};
  }
  // Convert to JSON and back to remove any problematic values
  try {
    const jsonString = JSON.stringify(obj, (key, value) => {
      if (value === null || value === undefined) return "";
      if (typeof value === "number" && (isNaN(value) || !isFinite(value))) return 0;
      return value;
    });
    return JSON.parse(jsonString);
  } catch (error) {
    return {error: "JSON serialization failed", originalError: error.message};
  }
}

if (admin.apps.length === 0) admin.initializeApp();

// Batch processing function
async function processBatch(batch, params, writeEvent, batchStartCount, totalProcessed, maxProperties) {
  console.log(`🚀 Processing batch of ${batch.length} properties (total processed: ${totalProcessed}/${maxProperties})`);

  writeEvent("status", {
    message: `Processing batch of ${batch.length} properties...`,
    totalProcessed: totalProcessed,
    maxProperties: maxProperties,
    timestamp: new Date().toISOString()
  });

  // Process all properties in the batch in parallel
  const batchPromises = batch.map(async (item, index) => {
    try {
      console.log(`🏠 Processing property ${item.property.zpid} (${item.sequence}/${item.totalEstimated})`);
      const results = await processProperty(item.property, params, item.sequence, item.totalEstimated);
      console.log(`✅ Property ${item.property.zpid} completed, got ${results.length} results`);
      return results;
    } catch (error) {
      console.error(`❌ Error processing property ${item.property.zpid}:`, {
        error: error.message,
        stack: error.stack,
        zpid: item.property.zpid,
        sequence: item.sequence
      });
      return [{
        error: `Property processing failed: ${error.message}`,
        zpid: item.property.zpid,
        sequence: item.sequence,
        total: item.totalEstimated,
      }];
    }
  });
  // Wait for all properties in batch to complete
  const batchResults = await Promise.all(batchPromises);
  // Send all results from this batch
  let resultsSent = 0;
  for (let i = 0; i < batchResults.length; i++) {
    const results = batchResults[i];
    for (let j = 0; j < results.length; j++) {
      try {
        const safeResult = ensureFlutterFlowCompatibility(results[j]);
        // Add deal score
        try {
          const dealInput = mapStrategyResultToDeal(batch[i]?.property || {}, safeResult);
          const dealScore = scoreDeal(dealInput);
          safeResult.score = dealScore.totalScore;
          safeResult.recommendation = dealScore.recommendation;
          safeResult.pattern = dealScore.pattern;
        } catch (scoreErr) { /* scoring is best-effort */ }
        console.log(`📡 BATCH RESULT: ${safeResult.zpid} - ${safeResult.method} ($${safeResult.netReturn}) Score:${safeResult.score || "N/A"} [ID: ${safeResult.calculationId}]`);
        writeEvent("data", safeResult);
        resultsSent++;
      } catch (error) {
        console.error("Error sending batch result:", error);
        writeEvent("data", {
          error: "Batch result processing error",
          zpid: results[j]?.zpid || "unknown",
          method: results[j]?.method || "unknown",
        });
      }
    }
  }
  // Send batch completion notification
  writeEvent("batch-complete", {
    batchSize: batch.length,
    resultsSent: resultsSent,
    totalProcessed: totalProcessed,
    maxProperties: maxProperties,
    batchNumber: Math.floor((batchStartCount + batch.length) / 10),
    message: `Batch completed: ${batch.length} properties processed, ${resultsSent} results sent`,
  });
  // Small pause between batches to prevent overwhelming
  await new Promise((resolve) => setTimeout(resolve, 500));
  return resultsSent;
}

setGlobalOptions({
  region: "us-west1",
  memory: "2GiB",
  timeoutSeconds: 540,
  concurrency: 50,
  minInstances: 0,
});

// Non-streaming endpoint for FlutterFlow compatibility
exports.cloudCalcsSync = onRequest({secrets: [oaDataApiUrl]}, async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  if (!(await requireFirebaseAuth(req, res))) return;

  const params = req.body || {};

  // Map Flutter field names to strategyCalculator param names
  if (params.financingRate && !params.interestRate) params.interestRate = params.financingRate;
  if (params.fixnflipDuration && !params.fixFlipDuration) params.fixFlipDuration = params.fixnflipDuration;
  if (params.newDuration && !params.newBuildDuration) params.newBuildDuration = params.newDuration;
  if (params.vacanyRate && !params.vacancyRate) params.vacancyRate = params.vacanyRate;

  if (!params.location) {
    return res.status(400).json({error: "Missing required 'location' parameter"});
  }

  try {
    // Limit to first page and 5 properties for FlutterFlow
    const response = await fetchZillowDataWithCache("propertyExtendedSearch", {
      location: params.location,
      page: 1,
      status_Type: params.status_Type || "FOR_SALE",
      propertyType: params.propertyType || "SINGLE_FAMILY",
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
    });

    const props = (response?.data?.props || []).slice(0, 5); // Limit to 5 properties
    const results = [];

    for (const prop of props) {
      try {
        const propResults = await processProperty(prop, params, 1, props.length);
        for (const r of propResults.filter((r) => r)) {
          try {
            const dealInput = mapStrategyResultToDeal(prop, r);
            const dealScore = scoreDeal(dealInput);
            r.score = dealScore.totalScore;
            r.recommendation = dealScore.recommendation;
            r.pattern = dealScore.pattern;
          } catch (scoreErr) {
            console.warn(`Scoring failed for ${prop.zpid}: ${scoreErr.message}`);
          }
          results.push(r);
        }
      } catch (error) {
        console.error(`Error processing ${prop.zpid}:`, error);
      }
    }

    return res.status(200).json({
      success: true,
      location: params.location,
      totalProperties: props.length,
      resultsCount: results.length,
      results: results
    });

  } catch (error) {
    console.error("cloudCalcsSync error:", error);
    return res.status(500).json({
      error: "Processing failed",
      details: error.message
    });
  }
});

exports.corsProxy = onRequest({
  region: "us-west1",
  memory: "256MiB",
  timeoutSeconds: 60,
}, async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, HEAD, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
    "Access-Control-Max-Age": "3600",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  const targetUrl = req.query.url;
  if (!targetUrl || Array.isArray(targetUrl)) {
    return res.status(400).json({error: "Missing url query parameter"});
  }

  let parsedUrl;
  try {
    parsedUrl = new URL(targetUrl);
  } catch (error) {
    return res.status(400).json({error: "Invalid url query parameter"});
  }

  if (!["http:", "https:"].includes(parsedUrl.protocol)) {
    return res.status(400).json({error: "Only http and https URLs are supported"});
  }

  try {
    const upstream = await fetch(parsedUrl.toString(), {
      headers: {
        "Accept": "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
        "User-Agent": "Mozilla/5.0 getRealDeal.ai image proxy",
      },
    });

    if (!upstream.ok) {
      return res.status(upstream.status).send(`Upstream image request failed: ${upstream.statusText}`);
    }

    const contentType = upstream.headers.get("content-type") || "application/octet-stream";
    const body = Buffer.from(await upstream.arrayBuffer());
    res.set({
      "Content-Type": contentType,
      "Cache-Control": "public, max-age=86400",
    });

    if (req.method === "HEAD") {
      return res.status(200).send("");
    }
    return res.status(200).send(body);
  } catch (error) {
    console.error("corsProxy error:", error);
    return res.status(502).json({error: "Image proxy request failed"});
  }
});

exports.cloudCalcs = onRequest({secrets: [oaDataApiUrl]}, async (req, res) => {
  const requestId = Math.random().toString(36).substr(2, 9);
  console.log(`\n🚀 REQUEST ${requestId} STARTED`);
  console.log(`📋 Method: ${req.method}`);
  console.log(`🌐 URL: ${req.url}`);
  console.log(`📨 Headers:`, JSON.stringify(req.headers, null, 2));
  console.log(`📦 Body:`, JSON.stringify(req.body, null, 2));
  console.log(`🔍 Query:`, JSON.stringify(req.query, null, 2));

  if (req.method === "OPTIONS") {
    console.log(`✅ Handling CORS preflight request`);
    res.set({
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type, Authorization",
      "Content-Length": "0",
    });
    return res.status(204).send("");
  }

  if (!(await requireFirebaseAuth(req, res))) return;

  const {writeEvent, end, keepAlive} = initSSE(res);
  const params = req.body || {};

  // Map Flutter field names to strategyCalculator param names
  if (params.financingRate && !params.interestRate) params.interestRate = params.financingRate;
  if (params.fixnflipDuration && !params.fixFlipDuration) params.fixFlipDuration = params.fixnflipDuration;
  if (params.newDuration && !params.newBuildDuration) params.newBuildDuration = params.newDuration;
  if (params.vacanyRate && !params.vacancyRate) params.vacancyRate = params.vacanyRate;

  console.log(`🏠 Location parameter: ${params.location || 'NOT PROVIDED'}`);
  console.log(`⚙️ All parameters:`, JSON.stringify(params, null, 2));

  if (!params.location) {
    console.log(`❌ ERROR: Missing required 'location' parameter`);
    writeEvent("error", {error: "Missing required 'location' parameter"});
    return end();
  }

  console.log(`✅ Location provided: ${params.location}`);
  console.log(`🚀 Starting property search process...`);

  // Send initial status to client
  writeEvent("status", {
    message: "Starting property search...",
    location: params.location,
    requestId: requestId,
    timestamp: new Date().toISOString()
  });

  let page = 1;
  let totalProcessed = 0;
  const MAX_PAGES = params.maxPages || 1000; // Allow up to 1000 pages (or user-specified)
  const MAX_PROPERTIES = params.maxProperties || 10000; // Process up to 10,000 properties (or user-specified)
  const BATCH_SIZE = 20; // Process properties in batches of 10
  let totalPages = 1;
  let batchCount = 0;
  let currentBatch = [];

  console.log(`🔧 Processing limits: MAX_PAGES=${MAX_PAGES}, MAX_PROPERTIES=${MAX_PROPERTIES}`);

  try {
    while (page <= totalPages && totalProcessed < MAX_PROPERTIES) {
      console.log(`🔍 FETCHING PAGE ${page}/${totalPages} with params:`, {
        location: params.location,
        page,
        status_Type: params.status_Type || "FOR_SALE",
        propertyType: params.propertyType || "SINGLE_FAMILY",
        minPrice: params.minPrice,
        maxPrice: params.maxPrice
      });

      writeEvent("status", {
        message: `Fetching page ${page}...`,
        page: page,
        totalPages: totalPages,
        timestamp: new Date().toISOString()
      });

      const response = await fetchZillowDataWithCache("propertyExtendedSearch", {
        location: params.location,
        page,
        status_Type: params.status_Type || "FOR_SALE",
        propertyType: params.propertyType || "SINGLE_FAMILY",
        minPrice: params.minPrice,
        maxPrice: params.maxPrice,
      });

      console.log(`📊 ZILLOW RESPONSE for page ${page}:`, {
        hasData: !!response?.data,
        propsCount: response?.data?.props?.length || 0,
        totalPages: response?.data?.totalPages || 0,
        totalResultCount: response?.data?.totalResultCount || 0,
        error: response?.error || null
      });

      const props = (response && response.data && Array.isArray(response.data.props)) ? response.data.props : [];
      totalPages = Math.min((response && response.data && response.data.totalPages) || 1, MAX_PAGES);

      // Break if no more properties found (end of listings)
      if (props.length === 0) {
        console.log(`📝 No more properties found on page ${page}. Ending processing.`);
        writeEvent("status", {
          message: `No properties found on page ${page}. Search complete.`,
          page: page,
          timestamp: new Date().toISOString()
        });
        break;
      }

      writeEvent("page-start", {
        page,
        totalPages,
        propertiesCount: props.length,
      });

      // Collect properties for batch processing
      for (let i = 0; i < props.length; i++) {
        if (totalProcessed >= MAX_PROPERTIES) break;
        currentBatch.push({
          property: props[i],
          sequence: totalProcessed + 1,
          totalEstimated: (response.data && response.data.totalResultCount) || props.length,
        });
        totalProcessed++;
        // Process batch when it reaches BATCH_SIZE or at end of page
        if (currentBatch.length === BATCH_SIZE || i === props.length - 1 || totalProcessed >= MAX_PROPERTIES) {
          await processBatch(currentBatch, params, writeEvent, batchCount, totalProcessed, MAX_PROPERTIES);
          batchCount += currentBatch.length;
          currentBatch = [];
        }
      }
      page++;
    }

    // Process any remaining batch
    if (currentBatch.length > 0) {
      await processBatch(currentBatch, params, writeEvent, batchCount, totalProcessed, MAX_PROPERTIES);
      batchCount += currentBatch.length;
    }

    // Send final summary
    writeEvent("processing-complete", {
      totalPropertiesProcessed: totalProcessed,
      totalBatchesProcessed: Math.ceil(batchCount / BATCH_SIZE),
      pagesProcessed: page - 1,
      message: `Analysis complete: ${totalProcessed} properties processed in batches of ${BATCH_SIZE}`,
    });
    writeEvent("end", {});
    end();
  } catch (error) {
    console.error(`💥 FATAL ERROR in cloudCalcs:`, {
      error: error.message,
      stack: error.stack,
      requestId: requestId,
      timestamp: new Date().toISOString()
    });
    writeEvent("error", {
      error: "Unexpected error",
      details: error.message,
      requestId: requestId,
      timestamp: new Date().toISOString()
    });
    end();
  } finally {
    console.log(`🏁 REQUEST ${requestId} FINISHED at ${new Date().toISOString()}`);
    keepAlive.stop();
  }
});

// HubSpot Integration Endpoints
exports.hubspotTrackCalculation = onRequest({secrets: [hubspotApiKey]}, async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  if (!(await requireFirebaseAuth(req, res))) return;

  try {
    const {email, firstName, lastName, phone, address, method} = req.body;

    if (!email) {
      return res.status(400).json({error: "Email is required"});
    }

    if (!address) {
      return res.status(400).json({error: "Property address is required"});
    }

    if (!method) {
      return res.status(400).json({error: "Investment method is required"});
    }

    const result = await trackPropertyCalculation({
      email,
      firstName,
      lastName,
      phone,
      address,
      method
    });

    return res.status(200).json({
      success: true,
      message: "Property calculation tracked in HubSpot",
      contactId: result.contact.id,
      noteId: result.note.id
    });

  } catch (error) {
    console.error("HubSpot tracking error:", error);
    return res.status(500).json({
      error: "Failed to track calculation in HubSpot",
      details: error.message
    });
  }
});

exports.hubspotCreateContact = onRequest({secrets: [hubspotApiKey]}, async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  if (!(await requireFirebaseAuth(req, res))) return;

  try {
    const {email, firstName, lastName, phone, customProperties} = req.body;

    if (!email) {
      return res.status(400).json({error: "Email is required"});
    }

    const contact = await createOrUpdateContact({
      email,
      firstName,
      lastName,
      phone,
      customProperties
    });

    return res.status(200).json({
      success: true,
      message: "Contact created/updated in HubSpot",
      contactId: contact.id,
      contact: contact
    });

  } catch (error) {
    console.error("HubSpot create contact error:", error);
    return res.status(500).json({
      error: "Failed to create contact in HubSpot",
      details: error.message
    });
  }
});

exports.hubspotFindContact = onRequest({secrets: [hubspotApiKey]}, async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  if (!(await requireFirebaseAuth(req, res))) return;

  try {
    const email = req.body?.email || req.query?.email;

    if (!email) {
      return res.status(400).json({error: "Email is required"});
    }

    const contact = await findContactByEmail(email);

    if (!contact) {
      return res.status(404).json({
        success: false,
        message: "Contact not found in HubSpot"
      });
    }

    return res.status(200).json({
      success: true,
      contact: contact
    });

  } catch (error) {
    console.error("HubSpot find contact error:", error);
    return res.status(500).json({
      error: "Failed to find contact in HubSpot",
      details: error.message
    });
  }
});

// ========================================
// GA4 Analytics Integration
// ========================================

const {onSchedule} = require("firebase-functions/v2/scheduler");
const {
  initializeGA4Client,
  fetchLandingPageEvents,
  fetchConversionEvents,
  testConnection,
} = require("./ga4Service");
const {
  transformGA4Batch,
  deduplicateEngagements,
  aggregatePageViews,
  filterLowValueEvents,
} = require("./ga4Transformer");

/**
 * Scheduled function: Sync GA4 data daily at 7 AM PST
 * Runs every day, fetches yesterday's data, writes to Firestore
 */
exports.syncGA4DataDaily = onSchedule({
  schedule: "0 7 * * *", // 7 AM every day (cron format)
  timeZone: "America/Los_Angeles", // PST timezone
  region: "us-west1",
  memory: "256MiB",
  timeoutSeconds: 300,
}, async (event) => {
  console.log("🚀 Starting daily GA4 sync at", new Date().toISOString());

  try {
    // Get config from environment variables
    const GA4_PROPERTY_ID = process.env.GA4_PROPERTY_ID;
    const GA4_SERVICE_ACCOUNT_PATH = process.env.GA4_SERVICE_ACCOUNT_PATH || "./ga4-service-account.json";
    const DEFAULT_USER_ID = process.env.DEFAULT_USER_ID || "default_user";

    if (!GA4_PROPERTY_ID) {
      throw new Error("GA4_PROPERTY_ID environment variable not set");
    }

    // Initialize GA4 client
    console.log("📊 Initializing GA4 client...");
    initializeGA4Client(GA4_SERVICE_ACCOUNT_PATH);

    // Fetch yesterday's data
    console.log("📥 Fetching GA4 data for yesterday...");
    const [landingPageEvents, conversionEvents] = await Promise.all([
      fetchLandingPageEvents(GA4_PROPERTY_ID, "yesterday", "yesterday"),
      fetchConversionEvents(GA4_PROPERTY_ID, "yesterday", "yesterday"),
    ]);

    const allGA4Events = [...landingPageEvents, ...conversionEvents];
    console.log(`✅ Fetched ${allGA4Events.length} GA4 events`);

    if (allGA4Events.length === 0) {
      console.log("ℹ️  No events to sync");
      return null;
    }

    // Transform GA4 events to engagement events
    console.log("🔄 Transforming GA4 events...");
    let engagements = transformGA4Batch(allGA4Events, DEFAULT_USER_ID);

    // Apply filters and aggregations
    engagements = deduplicateEngagements(engagements);
    engagements = aggregatePageViews(engagements);
    engagements = filterLowValueEvents(engagements);

    console.log(`✅ Transformed to ${engagements.length} engagement events`);

    // Write to Firestore
    console.log("💾 Writing to Firestore...");
    const db = admin.firestore();
    const batch = db.batch();

    engagements.forEach((engagement) => {
      const docRef = db.collection("engagements").doc();
      batch.set(docRef, engagement);
    });

    await batch.commit();
    console.log(`✅ Successfully synced ${engagements.length} engagement events to Firestore`);

    return {
      success: true,
      eventsProcessed: allGA4Events.length,
      engagementsCreated: engagements.length,
      timestamp: new Date().toISOString(),
    };

  } catch (error) {
    console.error("❌ Error syncing GA4 data:", error);
    throw error; // Let Cloud Functions retry
  }
});

// ========================================
// Drip Campaign Automation
// ========================================

/**
 * Scheduled function - runs daily at 8:00 AM PST
 * Checks for contacts needing follow-up emails
 */
exports.runDripCampaigns = onSchedule({
  schedule: "0 8 * * *", // Every day at 8:00 AM
  timeZone: "America/Los_Angeles",
  region: "us-west1",
  memory: "512MiB",
  timeoutSeconds: 540,
}, async (event) => {
  console.log("[Drip Campaigns] Starting daily run...");

  try {
    const db = admin.firestore();

    // Get all users with engagements
    const usersSnapshot = await db.collection("engagements").get();
    const userIds = new Set();

    usersSnapshot.docs.forEach((doc) => {
      const data = doc.data();
      if (data.userId) {
        userIds.add(data.userId);
      }
    });

    console.log(`[Drip Campaigns] Found ${userIds.size} users with engagements`);

    // Process each user
    let totalEmailsSent = 0;

    for (const userId of userIds) {
      const sent = await processUserDripCampaigns(userId, db);
      totalEmailsSent += sent;
    }

    console.log(`[Drip Campaigns] Complete. Sent ${totalEmailsSent} emails.`);

    return {
      success: true,
      totalEmailsSent,
      usersProcessed: userIds.size,
    };
  } catch (error) {
    console.error("[Drip Campaigns] Error:", error);
    throw error;
  }
});

/**
 * Manual trigger for testing
 */
exports.triggerDripCampaigns = onCall({
  region: "us-west1",
}, async (request) => {
  // Require authentication
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "Must be authenticated to trigger drip campaigns"
    );
  }

  console.log("[Drip] Manual trigger by:", request.auth.uid);

  const userId = request.data.userId || request.auth.uid;
  const db = admin.firestore();
  const emailsSent = await processUserDripCampaigns(userId, db);

  return {
    success: true,
    emailsSent,
    userId,
  };
});

/**
 * Process drip campaigns for a single user
 */
async function processUserDripCampaigns(userId, db) {
  let emailsSent = 0;

  // Get all contacts for this user (unique emails)
  const contactsMap = await getUserContacts(userId, db);

  // Check each contact for drip campaign eligibility
  for (const [email, lastEngagement] of contactsMap.entries()) {
    // Check 7-day follow-up
    if (shouldSend7DayFollowUp(lastEngagement)) {
      await send7DayEmail(userId, email, lastEngagement, db);
      emailsSent++;
    }
    // Check 30-day check-in
    else if (shouldSend30DayCheckIn(lastEngagement)) {
      await send30DayEmail(userId, email, lastEngagement, db);
      emailsSent++;
    }
  }

  return emailsSent;
}

/**
 * Get all unique contacts for a user with their last engagement
 */
async function getUserContacts(userId, db) {
  const snapshot = await db
    .collection("engagements")
    .where("userId", "==", userId)
    .where("contactEmail", "!=", null)
    .orderBy("contactEmail")
    .orderBy("timestamp", "desc")
    .get();

  const contactsMap = new Map();

  snapshot.docs.forEach((doc) => {
    const data = doc.data();
    const email = data.contactEmail;

    // Only keep the most recent engagement per contact
    if (email && !contactsMap.has(email)) {
      contactsMap.set(email, {
        ...data,
        id: doc.id,
      });
    }
  });

  return contactsMap;
}

/**
 * Check if contact should receive 7-day follow-up
 */
function shouldSend7DayFollowUp(engagement) {
  const now = new Date();
  const engagementDate = engagement.timestamp.toDate();
  const daysSince = Math.floor(
    (now.getTime() - engagementDate.getTime()) / (1000 * 60 * 60 * 24)
  );

  // Send if:
  // 1. Last engagement was 7 days ago
  // 2. Last engagement was initial_contact or email_sent
  // 3. Haven't sent 7-day follow-up yet

  if (daysSince !== 7) {
    return false;
  }

  if (
    engagement.eventType !== "initial_contact" &&
    engagement.eventType !== "email_sent"
  ) {
    return false;
  }

  // Check if we've already sent 7-day follow-up
  if (engagement.metadata && engagement.metadata.drip7DaySent) {
    return false;
  }

  return true;
}

/**
 * Check if contact should receive 30-day check-in
 */
function shouldSend30DayCheckIn(engagement) {
  const now = new Date();
  const engagementDate = engagement.timestamp.toDate();
  const daysSince = Math.floor(
    (now.getTime() - engagementDate.getTime()) / (1000 * 60 * 60 * 24)
  );

  // Send if:
  // 1. Last engagement was 30 days ago
  // 2. Last engagement was not converted or recommendation stage
  // 3. Haven't sent 30-day check-in yet

  if (daysSince !== 30) {
    return false;
  }

  if (
    engagement.eventType === "deal_closed" ||
    engagement.eventType === "contract_signed" ||
    engagement.eventType === "payment_received" ||
    engagement.eventType === "referral_made" ||
    engagement.eventType === "testimonial_given"
  ) {
    return false;
  }

  // Check if we've already sent 30-day check-in
  if (engagement.metadata && engagement.metadata.drip30DaySent) {
    return false;
  }

  return true;
}

/**
 * Send 7-day follow-up email
 */
async function send7DayEmail(userId, email, engagement, db) {
  console.log(`[Drip] Sending 7-day follow-up to ${email}`);

  // Create email document in 'mail' collection
  await db.collection("mail").add({
    to: email,
    template: {
      name: "realdeal-followup-7day",
      data: {
        contactName: email.split("@")[0], // Extract name from email
      },
    },
  });

  // Mark as sent in engagement metadata
  await db.collection("engagements").doc(engagement.id).update({
    "metadata.drip7DaySent": true,
    "metadata.drip7DaySentAt": admin.firestore.FieldValue.serverTimestamp(),
  });

  // Create engagement event
  await db.collection("engagements").add({
    eventType: "email_sent",
    source: "email",
    contactEmail: email,
    userId,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    metadata: {
      dripCampaign: "7-day-followup",
      templateId: "realdeal-followup-7day",
    },
  });
}

/**
 * Send 30-day check-in email
 */
async function send30DayEmail(userId, email, engagement, db) {
  console.log(`[Drip] Sending 30-day check-in to ${email}`);

  // Create email document in 'mail' collection
  await db.collection("mail").add({
    to: email,
    template: {
      name: "realdeal-checkin-30day",
      data: {
        contactName: email.split("@")[0],
      },
    },
  });

  // Mark as sent in engagement metadata
  await db.collection("engagements").doc(engagement.id).update({
    "metadata.drip30DaySent": true,
    "metadata.drip30DaySentAt": admin.firestore.FieldValue.serverTimestamp(),
  });

  // Create engagement event
  await db.collection("engagements").add({
    eventType: "email_sent",
    source: "email",
    contactEmail: email,
    userId,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    metadata: {
      dripCampaign: "30-day-checkin",
      templateId: "realdeal-checkin-30day",
    },
  });
}

// ============================================================
// DEAL SCANNER - Automated daily property scanning
// ============================================================

/**
 * Load user profile from Firestore and map field names to what strategyCalculator expects.
 * The Flutter app stores fields like "financingRate" and "fixnflipDuration",
 * but strategyCalculator.js reads "interestRate" and "fixFlipDuration".
 */
async function loadUserCalcParams(db, email) {
  const userSnap = await db.collection("UserData")
    .where("email", "==", email).limit(1).get();

  if (userSnap.empty) {
    console.log(`[DealScanner] No user profile found for ${email}, using defaults`);
    return {};
  }

  const u = userSnap.docs[0].data();
  console.log(`[DealScanner] Loaded profile for ${email} (${u.display_name || "unknown"})`);

  // Map user profile field names → strategyCalculator param names
  const params = {};
  if (u.financingRate) params.interestRate = u.financingRate;
  if (u.salRate) params.salRate = u.salRate;
  if (u.loanFeesRate) params.loanFeesRate = u.loanFeesRate;
  if (u.permitsFees) params.permitsFees = u.permitsFees;
  if (u.fixnflipDuration) params.fixFlipDuration = u.fixnflipDuration;
  if (u.addOnDuration) params.addOnDuration = u.addOnDuration;
  if (u.aduDuration) params.aduDuration = u.aduDuration;
  if (u.newDuration) params.newBuildDuration = u.newDuration;
  if (u.oneBdrmMarketValue) params.oneBdrmMarketValue = u.oneBdrmMarketValue;
  if (u.aduImpRate) params.aduImpRate = u.aduImpRate;
  if (u.maintenanceRate) params.maintenanceRate = u.maintenanceRate;
  if (u.operatingExpenseRate) params.operatingExpenseRate = u.operatingExpenseRate;
  if (u.propertyManagementFeeRate) params.propertyManagementFeeRate = u.propertyManagementFeeRate;
  if (u.utilities) params.utilities = u.utilities;
  if (u.vacanyRate) params.vacancyRate = u.vacanyRate;
  if (u.minimumReturn) params.minReturn = u.minimumReturn;

  return params;
}

/**
 * Scheduled Deal Scanner - runs daily at 6:00 AM PST
 * Reads scanConfigs from Firestore, searches each market,
 * runs proforma via processProperty, and emails qualifying deals.
 */
exports.scanDealsDaily = onSchedule({
  schedule: "0 6 * * *",
  timeZone: "America/Los_Angeles",
  region: "us-west1",
  memory: "2GiB",
  timeoutSeconds: 540,
  secrets: [oaDataApiUrl],
}, async (event) => {
  console.log("[DealScanner] Starting daily scan...");
  const db = admin.firestore();

  // [2026-06-29] Outbound scan emails disabled per Don. The RealDeal scan
  // "canary" and "BuyBox Match" digest emails are retired. The scan itself
  // still runs and writes dealAlerts/scanHealth for the app — only the two
  // notification emails are suppressed. Set to true to re-enable both emails.
  const EMAIL_NOTIFICATIONS_ENABLED = false;

  // 1. Load active scan configs
  const configsSnap = await db.collection("scanConfigs")
    .where("active", "==", true).get();

  if (configsSnap.empty) {
    console.log("[DealScanner] No active scan configs. Exiting.");
    return;
  }

  // 2. Load existing alerts to deduplicate (by zpid+method)
  const existingSnap = await db.collection("dealAlerts")
    .where("scannedAt", ">=", new Date(Date.now() - 7 * 24 * 60 * 60 * 1000))
    .get();
  const existingKeys = new Set();
  existingSnap.docs.forEach((d) => {
    const data = d.data();
    existingKeys.add(`${data.zpid}_${data.method}`);
  });

  const allDeals = [];
  const notifyEmails = new Set();

  // 2b. Collect all notify emails first, then load user profile
  for (const doc of configsSnap.docs) {
    const cfg = doc.data();
    if (cfg.notifyEmail) notifyEmails.add(cfg.notifyEmail);
  }

  // 2c. Load user calc params from the first notify email's profile
  const primaryEmail = [...notifyEmails][0];
  const userCalcParams = primaryEmail ? await loadUserCalcParams(db, primaryEmail) : {};

  // 3. Scan each market
  const marketHealth = [];
  for (const doc of configsSnap.docs) {
    const cfg = doc.data();
    const label = cfg.name || cfg.location;
    console.log(`[DealScanner] Scanning: ${label}`);

    try {
      const maxPages = cfg.maxPages || 5;
      let totalPropsScanned = 0;

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
          console.error(`[DealScanner] API fetch failed for ${label} page ${page}: ${fetchErr.message}`);
          break; // Skip remaining pages for this market
        }

        const props = response?.data?.props || [];
        console.log(`[DealScanner] ${label} page ${page}: ${props.length} properties`);

        if (props.length === 0) break; // No more results

        totalPropsScanned += props.length;

        for (let i = 0; i < props.length; i++) {
          try {
            // Skip Redfin API calls in scanner (rate limits cause timeouts)
            // Use zestimate-based ARV instead — Redfin comps used in app UI only
            const results = await processProperty(props[i], {
              ...userCalcParams,
              minReturn: cfg.minReturn || userCalcParams.minReturn || 25000,
              redfinSoldComps: [],
              redfinForSaleComps: [],
            }, totalPropsScanned - props.length + i + 1, totalPropsScanned);

            for (const r of results) {
              if (!r) continue;
              const key = `${r.zpid}_${r.method}`;
              if (existingKeys.has(key)) continue; // Skip duplicates

              const meetsReturn = r.netReturn >= (cfg.minReturn || 25000);
              const meetsROI = r.netROI >= (cfg.minROI || 0.15);
              const meetsCash = !cfg.maxCashNeeded || r.cashNeeded <= cfg.maxCashNeeded;

              if (meetsReturn && meetsROI && meetsCash) {
                existingKeys.add(key);

                // Score the deal using OA scoring engine
                let dealScore = null;
                try {
                  const dealInput = mapStrategyResultToDeal(props[i], r);
                  dealScore = scoreDeal(dealInput);
                } catch (scoreErr) {
                  console.warn(`[DealScanner] Scoring failed for ${r.zpid}: ${scoreErr.message}`);
                }

                allDeals.push({
                  ...r,
                  scanConfig: label,
                  score: dealScore ? dealScore.totalScore : null,
                  recommendation: dealScore ? dealScore.recommendation : null,
                  pattern: dealScore ? dealScore.pattern : null,
                  projectedProfit: dealScore ? dealScore.projectedProfit : null,
                });
              }
            }
          } catch (err) {
            console.warn(`[DealScanner] Error on zpid ${props[i]?.zpid}: ${err.message}`);
          }
        }

        if (props.length < 35) break; // Partial page = last page
      }

      console.log(`[DealScanner] ${label}: ${totalPropsScanned} total properties scanned`);
      marketHealth.push({market: label, location: cfg.location, scanned: totalPropsScanned, error: null});
    } catch (err) {
      console.error(`[DealScanner] Error scanning ${label}: ${err.message}`);
      marketHealth.push({market: label, location: cfg.location, scanned: 0, error: err.message});
    }
  }

  // 3b. Scan-health canary — detect silent zero-result markets.
  // A market that returns 0 properties on a single run is not necessarily
  // broken (tight filters, small inventory), but a market that returns 0 on
  // consecutive runs is a silent-failure signal (e.g. the "City, State"
  // location-parser bug, an expired data source, or an upstream outage).
  // Persist health every run and alert when a zero result repeats.
  try {
    const zeroMarkets = marketHealth.filter((m) => m.scanned === 0).map((m) => m.market);

    const prevSnap = await db.collection("scanHealth")
      .orderBy("ranAt", "desc").limit(1).get();
    const prevZero = new Set();
    if (!prevSnap.empty) {
      (prevSnap.docs[0].data().zeroMarkets || []).forEach((m) => prevZero.add(m));
    }
    const persistentZeroMarkets = zeroMarkets.filter((m) => prevZero.has(m));

    await db.collection("scanHealth").add({
      ranAt: admin.firestore.FieldValue.serverTimestamp(),
      marketsScanned: marketHealth.length,
      dealsFound: allDeals.length,
      perMarket: marketHealth,
      zeroMarkets,
      persistentZeroMarkets,
    });

    if (persistentZeroMarkets.length > 0) {
      console.error(`[DealScanner][CANARY] Persistent 0-result markets (>=2 scans): ${persistentZeroMarkets.join(", ")}`);
      for (const email of (EMAIL_NOTIFICATIONS_ENABLED ? notifyEmails : [])) {
        await db.collection("mail").add({
          to: email,
          message: {
            subject: `⚠️ RealDeal scan canary: ${persistentZeroMarkets.length} market(s) returning 0 results`,
            html: `<div style="font-family:Arial,sans-serif;color:#1e293b;max-width:600px;">
              <p>The daily deal scan returned <strong>0 properties</strong> for the following market(s) on two or more consecutive runs:</p>
              <ul>${persistentZeroMarkets.map((m) => `<li>${m}</li>`).join("")}</ul>
              <p>This usually means a broken location query or an upstream data outage, not a genuinely empty market. Check the OA Data API and each market's <code>location</code> format in <code>scanConfigs</code>.</p>
            </div>`,
          },
        });
      }
    } else if (zeroMarkets.length > 0) {
      console.warn(`[DealScanner][CANARY] 0-result markets this run (watching): ${zeroMarkets.join(", ")}`);
    }
  } catch (canaryErr) {
    console.error(`[DealScanner][CANARY] Health check failed: ${canaryErr.message}`);
  }

  // 4. Store qualifying deals
  for (const deal of allDeals) {
    await db.collection("dealAlerts").add({
      ...deal,
      scannedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  }

  // 5. Send digest email
  if (allDeals.length > 0 && notifyEmails.size > 0) {
    // Sort deals by score (highest first), then by netReturn
    allDeals.sort((a, b) => (b.score || 0) - (a.score || 0) || (b.netReturn || 0) - (a.netReturn || 0));

    const rows = allDeals.map((d) => {
      const listingUrl = d.detailUrl || "#";
      const scoreColor = d.score >= 70 ? "#16a34a" : d.score >= 50 ? "#ca8a04" : "#dc2626";
      const scoreLabel = d.recommendation || "N/A";
      return `<tr>
        <td style="padding:10px 12px;">
          <a href="${listingUrl}" style="color:#2563eb;text-decoration:none;font-weight:600;">${d.address || "N/A"}</a>
        </td>
        <td style="padding:10px 8px;">${d.method}</td>
        <td style="padding:10px 8px;">$${(d.price || 0).toLocaleString()}</td>
        <td style="padding:10px 8px;color:#16a34a;font-weight:600;">$${(d.netReturn || 0).toLocaleString()}</td>
        <td style="padding:10px 8px;">${((d.netROI || 0) * 100).toFixed(1)}%</td>
        <td style="padding:10px 8px;">$${(d.cashNeeded || 0).toLocaleString()}</td>
        <td style="padding:10px 8px;"><span style="color:${scoreColor};font-weight:700;">${d.score || "—"}</span> <span style="font-size:11px;color:#94a3b8;">${scoreLabel}</span></td>
        <td style="padding:10px 8px;">${d.scanConfig}</td>
      </tr>`;
    }).join("");

    const dateStr = new Date().toLocaleDateString("en-US", {weekday: "long", year: "numeric", month: "long", day: "numeric"});

    const html = `
      <div style="max-width:700px;margin:0 auto;font-family:'Helvetica Neue',Arial,sans-serif;color:#1e293b;">
        <!-- Header -->
        <div style="background:linear-gradient(135deg,#1e40af 0%,#3b82f6 100%);padding:24px 28px;border-radius:12px 12px 0 0;">
          <table cellpadding="0" cellspacing="0" border="0" width="100%"><tr>
            <td>
              <span style="font-size:28px;line-height:1;">&#x26A1;</span>
              <span style="font-size:22px;font-weight:700;color:white;vertical-align:middle;margin-left:8px;">BuyBox Match</span>
            </td>
            <td align="right">
              <!-- 3D Box Icon (axonometric cube) -->
              <svg width="40" height="40" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
                <polygon points="50,10 90,30 90,70 50,90 10,70 10,30" fill="none" stroke="white" stroke-width="3"/>
                <line x1="50" y1="10" x2="50" y2="90" stroke="white" stroke-width="2" opacity="0.5"/>
                <line x1="10" y1="30" x2="90" y2="30" stroke="white" stroke-width="2" opacity="0.5"/>
                <polygon points="50,10 90,30 50,50 10,30" fill="rgba(255,255,255,0.15)" stroke="white" stroke-width="2"/>
                <polygon points="50,50 90,30 90,70 50,90" fill="rgba(255,255,255,0.08)" stroke="white" stroke-width="2"/>
                <polygon points="50,50 10,30 10,70 50,90" fill="rgba(255,255,255,0.04)" stroke="white" stroke-width="2"/>
              </svg>
            </td>
          </tr></table>
          <p style="color:rgba(255,255,255,0.85);font-size:14px;margin:8px 0 0 0;">${dateStr}</p>
        </div>

        <!-- Summary -->
        <div style="background:#f8fafc;padding:16px 28px;border-left:1px solid #e2e8f0;border-right:1px solid #e2e8f0;">
          <p style="margin:0;font-size:15px;">
            <strong style="font-size:24px;color:#2563eb;">${allDeals.length}</strong>
            <span style="color:#64748b;"> qualifying deal${allDeals.length > 1 ? "s" : ""} across ${configsSnap.size} market${configsSnap.size > 1 ? "s" : ""}</span>
          </p>
        </div>

        <!-- Deal Table -->
        <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-collapse:collapse;font-size:13px;border-left:1px solid #e2e8f0;border-right:1px solid #e2e8f0;">
          <tr style="background:#1e293b;color:white;">
            <th style="padding:10px 12px;text-align:left;">Address</th>
            <th style="padding:10px 8px;text-align:left;">Strategy</th>
            <th style="padding:10px 8px;text-align:left;">Price</th>
            <th style="padding:10px 8px;text-align:left;">Net Return</th>
            <th style="padding:10px 8px;text-align:left;">ROI</th>
            <th style="padding:10px 8px;text-align:left;">Cash Needed</th>
            <th style="padding:10px 8px;text-align:left;">Score</th>
            <th style="padding:10px 8px;text-align:left;">Market</th>
          </tr>
          ${rows}
        </table>

        <!-- Footer -->
        <div style="background:#f8fafc;padding:20px 28px;border:1px solid #e2e8f0;border-radius:0 0 12px 12px;">
          <table cellpadding="0" cellspacing="0" border="0" width="100%"><tr>
            <td>
              <p style="margin:0 0 8px 0;font-size:12px;color:#94a3b8;">Min Return $25K+ &middot; Min ROI 15%+ &middot; Deduped 7 days</p>
            </td>
            <td align="right">
              <a href="https://app.getrealdeal.ai" style="display:inline-block;background:#2563eb;color:white;padding:8px 20px;border-radius:6px;text-decoration:none;font-size:13px;font-weight:600;">
                &#x26A1; Open in getRealDeal.ai
              </a>
            </td>
          </tr></table>
        </div>
      </div>
    `;

    for (const email of (EMAIL_NOTIFICATIONS_ENABLED ? notifyEmails : [])) {
      await db.collection("mail").add({
        to: email,
        message: {
          subject: `\u26A1 BuyBox Match: ${allDeals.length} Deal${allDeals.length > 1 ? "s" : ""} Found - ${new Date().toLocaleDateString()}`,
          html,
        },
      });
    }
    console.log(`[DealScanner] Digest: ${EMAIL_NOTIFICATIONS_ENABLED ? `sent to ${notifyEmails.size} recipient(s)` : "email disabled, not sent"}.`);
  }

  console.log(`[DealScanner] Complete. ${allDeals.length} qualifying deals from ${configsSnap.size} markets.`);
});

/**
 * Manual trigger for deal scanner (for testing)
 */
exports.triggerDealScan = onCall({
  region: "us-west1",
  memory: "2GiB",
  timeoutSeconds: 540,
  secrets: [oaDataApiUrl],
}, async (request) => {
  if (!request.auth) {
    throw new Error("Authentication required");
  }

  const db = admin.firestore();
  const configsSnap = await db.collection("scanConfigs")
    .where("active", "==", true).get();

  if (configsSnap.empty) {
    return {success: false, message: "No active scan configs"};
  }

  // Reuse the same logic - trigger the scheduled function's handler
  console.log("[DealScanner] Manual trigger by", request.auth.uid);

  // Load the triggering user's calc params from their profile
  const userDoc = await db.collection("UserData").doc(request.auth.uid).get();
  let userCalcParams = {};
  if (userDoc.exists) {
    const u = userDoc.data();
    console.log(`[DealScanner] Loaded profile for ${u.email}`);
    userCalcParams = await loadUserCalcParams(db, u.email);
  }

  // Inline a lightweight version for testing (with pagination)
  const allDeals = [];
  for (const doc of configsSnap.docs) {
    const cfg = doc.data();
    const maxPages = cfg.maxPages || 5;
    try {
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
          console.error(`[DealScanner] API fetch failed for ${cfg.location} page ${page}: ${fetchErr.message}`);
          break;
        }

        const props = response?.data?.props || [];
        console.log(`[DealScanner] ${cfg.location} page ${page}: ${props.length} properties`);

        if (props.length === 0) break;

        for (const prop of props) {
          try {
            const results = await processProperty(prop, {
              ...userCalcParams,
              minReturn: cfg.minReturn || userCalcParams.minReturn || 25000,
              redfinSoldComps: [],
              redfinForSaleComps: [],
            }, 1, props.length);
            allDeals.push(...results.filter((r) => r && r.netROI >= (cfg.minROI || 0.15)));
          } catch (err) {
            // Skip individual property errors
          }
        }

        if (props.length < 35) break; // Partial page = last page
      }
    } catch (err) {
      console.error(`[DealScanner] Error scanning ${cfg.location}: ${err.message}`);
    }
  }

  return {
    success: true,
    dealsFound: allDeals.length,
    results: allDeals,
  };
});

// ============================================================
// EMAIL QUEUE PROCESSOR - SendGrid
// ============================================================

/**
 * Process emails queued in the 'mail' Firestore collection.
 * Replaces the firestore-send-email Firebase extension.
 *
 * Supports two formats:
 *   Direct:   { to, message: { subject, html, text } }
 *   Template: { to, template: { name, data } }
 */
exports.processMailQueue = onDocumentCreated({
  document: "mail/{docId}",
  region: "us-west1",
  secrets: [sendgridApiKey],
}, async (event) => {
  const sgMail = require("@sendgrid/mail");
  sgMail.setApiKey(process.env.SENDGRID_API_KEY);

  const snap = event.data;
  if (!snap) return;

  const mailData = snap.data();
  const docRef = snap.ref;

  const to = mailData.to;
  if (!to) {
    await docRef.update({delivery: {state: "ERROR", error: "Missing 'to' field"}});
    return;
  }

  const from = mailData.from || "admin@fluidcm.com";

  try {
    const msg = {to, from};

    if (mailData.cc) msg.cc = mailData.cc;
    if (mailData.bcc) msg.bcc = mailData.bcc;
    if (mailData.replyTo) msg.replyTo = mailData.replyTo;

    if (mailData.message) {
      // Direct email: { subject, html, text }
      msg.subject = mailData.message.subject || "(No subject)";
      if (mailData.message.html) msg.html = mailData.message.html;
      if (mailData.message.text) msg.text = mailData.message.text;
      if (!msg.html && !msg.text) msg.text = "(Empty email)";
    } else if (mailData.template) {
      // Template email: { name, data }
      msg.templateId = mailData.template.name;
      msg.dynamicTemplateData = mailData.template.data || {};
    } else {
      await docRef.update({delivery: {state: "ERROR", error: "Missing 'message' or 'template'"}});
      return;
    }

    await sgMail.send(msg);
    console.log(`[Mail] Sent to ${to} via SendGrid`);

    await docRef.update({
      delivery: {
        state: "SUCCESS",
        attempts: 1,
        endTime: admin.firestore.FieldValue.serverTimestamp(),
      },
    });
  } catch (error) {
    console.error(`[Mail] Failed to send to ${to}:`, error.message);

    await docRef.update({
      delivery: {
        state: "ERROR",
        attempts: 1,
        error: error.message,
        endTime: admin.firestore.FieldValue.serverTimestamp(),
      },
    });
  }
});

/**
 * Update deal alert pipeline status with transition validation.
 *
 * Valid transitions:
 *   opportunity → reviewing
 *   reviewing   → go | pass
 *   pass        → opportunity  (reopen)
 */
const VALID_TRANSITIONS = {
  opportunity: ["reviewing"],
  reviewing: ["go", "pass"],
  pass: ["opportunity"],
};

exports.updateDealStatus = onCall({
  region: "us-west1",
}, async (request) => {
  if (!request.auth) {
    throw new HttpsError(
      "unauthenticated",
      "Must be authenticated to update deal status",
    );
  }

  const {dealId, newStatus} = request.data;
  if (!dealId || !newStatus) {
    throw new HttpsError(
      "invalid-argument",
      "dealId and newStatus are required",
    );
  }

  const db = admin.firestore();
  const docRef = db.collection("dealAlerts").doc(dealId);
  const doc = await docRef.get();

  if (!doc.exists) {
    throw new HttpsError(
      "not-found",
      `Deal alert ${dealId} not found`,
    );
  }

  const currentStatus = doc.data().status || "opportunity";
  const allowed = VALID_TRANSITIONS[currentStatus];

  if (!allowed || !allowed.includes(newStatus)) {
    throw new HttpsError(
      "failed-precondition",
      `Cannot transition from "${currentStatus}" to "${newStatus}". ` +
      `Allowed: ${(allowed || []).join(", ") || "none"}`,
    );
  }

  const updateData = {
    status: newStatus,
    statusUpdatedAt: admin.firestore.FieldValue.serverTimestamp(),
    statusUpdatedBy: request.auth.uid,
  };

  // On GO: record approval metadata
  if (newStatus === "go") {
    updateData.approvedAt = admin.firestore.FieldValue.serverTimestamp();
    updateData.approvedBy = request.auth.uid;
  }

  await docRef.update(updateData);

  console.log(
    `[DealStatus] ${dealId}: ${currentStatus} → ${newStatus} by ${request.auth.uid}`,
  );

  // On GO: create FluidCM project for deal handoff
  if (newStatus === "go") {
    try {
      const dealData = doc.data();
      const result = await createFluidCMProject(dealData, dealId);
      if (result && result.projectId) {
        await docRef.update({
          fluidcm_project_id: result.projectId,
          fluidcm_project_code: result.projectCode,
          fluidcm_handoff_at: admin.firestore.FieldValue.serverTimestamp(),
        });
        console.log(`[FluidCM] Project ${result.projectCode} created for deal ${dealId}`);
      }
    } catch (err) {
      // Non-blocking: log but don't fail the status update
      console.error(`[FluidCM] Handoff failed for deal ${dealId}:`, err.message);
    }
  }

  return {
    success: true,
    dealId,
    previousStatus: currentStatus,
    newStatus,
  };
});

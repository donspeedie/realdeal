require("dotenv").config();

const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {setGlobalOptions} = require("firebase-functions/v2/options");
const admin = require("firebase-admin");
const {initSSE} = require("./sseWriter");
const {fetchZillowDataWithCache} = require("./zillowApi");
const {processProperty} = require("./propertyProcessor");
const {trackPropertyCalculation, createOrUpdateContact, findContactByEmail} = require("./hubspotIntegration");

if (admin.apps.length === 0) admin.initializeApp();

exports.autoRecalculateSavedPropertyV2 = onDocumentUpdated({
  document: "savedProperties/{docId}",
  region: "us-west1",
  memory: "512MiB",
  timeoutSeconds: 540,
  concurrency: 10,
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
        console.log(`📡 BATCH RESULT: ${safeResult.zpid} - ${safeResult.method} ($${safeResult.netReturn}) [ID: ${safeResult.calculationId}]`);
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
  minInstances: 1,
});

// Non-streaming endpoint for FlutterFlow compatibility
exports.cloudCalcsSync = onRequest(async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  const params = req.body || {};
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
        results.push(...propResults.filter(r => r)); // Filter out nulls
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

// Simple test endpoint
exports.testSimple = onRequest(async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS, GET",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  return res.status(200).json({
    success: true,
    message: "Endpoint is working",
    timestamp: new Date().toISOString()
  });
});

exports.cloudCalcs = onRequest(async (req, res) => {
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

  const {writeEvent, end, keepAlive} = initSSE(res);
  const params = req.body || {};

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
exports.hubspotTrackCalculation = onRequest(async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

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

exports.hubspotCreateContact = onRequest(async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

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

exports.hubspotFindContact = onRequest(async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

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

/**
 * Manual trigger function: Test GA4 sync on-demand
 * Call this via HTTP to test the sync process
 */
exports.testGA4Sync = onRequest({
  region: "us-west1",
  memory: "256MiB",
  timeoutSeconds: 300,
}, async (req, res) => {
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  console.log("🧪 Manual GA4 sync test started");

  try {
    // Get config from environment variables or request body
    const GA4_PROPERTY_ID = req.body?.propertyId || process.env.GA4_PROPERTY_ID;
    const GA4_SERVICE_ACCOUNT_PATH = process.env.GA4_SERVICE_ACCOUNT_PATH || "./ga4-service-account.json";
    const DEFAULT_USER_ID = req.body?.userId || process.env.DEFAULT_USER_ID || "default_user";
    const startDate = req.body?.startDate || "yesterday";
    const endDate = req.body?.endDate || "yesterday";

    if (!GA4_PROPERTY_ID) {
      return res.status(400).json({error: "GA4_PROPERTY_ID not provided"});
    }

    // Initialize GA4 client
    console.log("📊 Initializing GA4 client...");
    initializeGA4Client(GA4_SERVICE_ACCOUNT_PATH);

    // Test connection first
    console.log("🔌 Testing GA4 connection...");
    const connectionTest = await testConnection(GA4_PROPERTY_ID);

    if (!connectionTest.success) {
      return res.status(500).json({
        error: "Failed to connect to GA4",
        details: connectionTest.error,
      });
    }

    // Fetch data
    console.log(`📥 Fetching GA4 data from ${startDate} to ${endDate}...`);
    const [landingPageEvents, conversionEvents] = await Promise.all([
      fetchLandingPageEvents(GA4_PROPERTY_ID, startDate, endDate),
      fetchConversionEvents(GA4_PROPERTY_ID, startDate, endDate),
    ]);

    const allGA4Events = [...landingPageEvents, ...conversionEvents];
    console.log(`✅ Fetched ${allGA4Events.length} GA4 events`);

    // Transform
    console.log("🔄 Transforming GA4 events...");
    let engagements = transformGA4Batch(allGA4Events, DEFAULT_USER_ID);
    engagements = deduplicateEngagements(engagements);
    engagements = aggregatePageViews(engagements);
    engagements = filterLowValueEvents(engagements);

    console.log(`✅ Transformed to ${engagements.length} engagement events`);

    // Write to Firestore (unless dryRun mode)
    const dryRun = req.body?.dryRun || false;

    if (!dryRun) {
      console.log("💾 Writing to Firestore...");
      const db = admin.firestore();
      const batch = db.batch();

      engagements.forEach((engagement) => {
        const docRef = db.collection("engagements").doc();
        batch.set(docRef, engagement);
      });

      await batch.commit();
      console.log(`✅ Successfully wrote ${engagements.length} engagements to Firestore`);
    } else {
      console.log("🏃 Dry run mode - skipping Firestore write");
    }

    // Return results
    return res.status(200).json({
      success: true,
      connection: connectionTest,
      ga4Events: allGA4Events.length,
      engagementsCreated: engagements.length,
      dryRun,
      sampleEngagements: engagements.slice(0, 5), // Show first 5 for preview
      timestamp: new Date().toISOString(),
    });

  } catch (error) {
    console.error("❌ Error testing GA4 sync:", error);
    return res.status(500).json({
      error: "Failed to test GA4 sync",
      details: error.message,
      stack: error.stack,
    });
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
const {onCall} = require("firebase-functions/v2/https");

exports.triggerDripCampaigns = onCall({
  region: "us-west1",
}, async (request) => {
  // Require authentication
  if (!request.auth) {
    throw new functions.https.HttpsError(
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

# RealDeal.ai - System Verification Checklist

**Created:** 2026-02-05
**Updated:** 2026-04-25 — Phase 4-5 verified complete. See "OA Data API Migration Status" below.
**Purpose:** Verify system integrity and document required setup steps

> **NOTE:** RapidAPI is fully migrated. All RapidAPI references in this checklist below §11 are HISTORICAL. The system runs entirely on OA Data API.

---

## 0. OA Data API Migration Status (verified 2026-04-25)

| Phase | Status | Evidence |
|---|---|---|
| 3 — Code rewired to use `oaDataApi.js` | ✅ DONE | `propertyProcessor.js:1` imports from `./oaDataApi`. `zillowApi.js`/`redfinApi.js` moved to `functions/old/`. No `process.env.RAPID_API_KEY` references in active code. |
| 4a — Deploy OA Data API to Cloud Run | ✅ DONE | `oa-data-api` service live at `https://oa-data-api-310350296592.us-west1.run.app`. `/health` returns `{"status":"ok"}`. |
| 4b — Bind `OA_DATA_API_URL` to Functions | ✅ DONE | Secret bound to `cloudCalcs`, `scanDealsDaily`, `triggerDealScan`, `cloudCalcsSync` (all critical scoring functions). |
| 4c — Remove `RAPID_API_KEY` | ⚠️ DORMANT | Secret still exists in `habu-1gxak2` project but **NOT BOUND to any active function**. Zero billing risk. Pending deletion (P0 destructive op). |
| 5 — End-to-end verify | ✅ EFFECTIVELY DONE | OA Data API endpoints respond correctly. Functions wired correctly. Production scoring runs through OA Data API. |

### Known issue (filed 2026-04-25)

`/api/v1/listings/search?location=Stockton` returns 2 results; `location=Stockton, CA` returns 0. The OA Data API's location parser doesn't handle `"City, State"` format. **RealDeal's `oaDataApi.js` likely passes that format** (matching Zillow's old API), causing silent 0-result responses in production scans.

**Fix options:**
- (a) Strip state suffix in `oaDataApi.js` before sending: `location.split(',')[0].trim()`
- (b) Update OA Data API location parser in `OperationAlpha/data_api/routes/listings.py` to accept `"City, State"` format

Recommend (b) — Zillow-shape compatibility is the explicit design goal.

---

## 1. Environment Variables Status

| Variable | Required | Status | Notes |
|----------|----------|--------|-------|
| `OA_DATA_API_URL` | Yes | ✅ Set | Bound as Firebase secret to all 4 critical scoring functions |
| `RAPID_API_KEY` | No (legacy) | 🪦 DORMANT | Secret exists but unbound; pending deletion |
| `STRIPE_SECRET_KEY` | Yes | ✅ Set | Via Firebase config (`stripe.secret`) |
| `HUBSPOT_API_KEY` | Optional | ✅ Set | Via Firebase config (`hubspot.api_key`) |
| `GA4_PROPERTY_ID` | Optional | ⚠️ Unknown | Check if configured |
| `GA4_SERVICE_ACCOUNT_PATH` | Optional | ⚠️ Unknown | Check if configured |

**CRITICAL MIGRATION NOTICE:**
Firebase `functions.config()` API is **deprecated and will stop working in March 2026**.
Must migrate to `.env` files before then. See: https://firebase.google.com/docs/functions/config-env#migrate-to-dotenv

**Action:** Copy `functions/.env.example` to `functions/.env` and migrate config values.

---

## 2. External API Subscriptions

### RapidAPI (Zillow + Redfin) - ❌ SUBSCRIPTION EXPIRED
- [x] Account exists at https://rapidapi.com
- [ ] **RENEW:** Subscription to `zillow-com1.p.rapidapi.com` (returns 404)
- [ ] **RENEW:** Subscription to `redfin-com.p.rapidapi.com` (likely also expired)
- [x] API key exists in Firebase config

**Tested 2026-02-05:** Direct API call returns 404 - subscription inactive
```
POST https://us-west1-habu-1gxak2.cloudfunctions.net/cloudCalcsSync
{"location": "Sacramento, CA"}
Response: {"error":"Processing failed","details":"Request failed with status code 404"}
```

### Stripe
- [ ] Account active at https://stripe.com
- [ ] Products created in Stripe dashboard
- [ ] API key (test or live) copied to `.env`

### HubSpot (Optional)
- [ ] Account active at https://hubspot.com
- [ ] API key created with required scopes
- [ ] API key copied to `.env`

### Google Analytics 4 (Optional)
- [ ] GA4 property created
- [ ] Service account created in Google Cloud
- [ ] Service account granted Viewer role on GA4 property
- [ ] JSON key downloaded to `functions/service-account-ga4.json`

---

## 3. Firebase Deployment Status

### Project Info
- **Project ID:** `habu-1gxak2`
- **Region:** `us-west1`
- **Runtime:** Node 22

### Check Deployment
```bash
# Login to Firebase
firebase login

# Select project
firebase use habu-1gxak2

# Check functions status
firebase functions:list

# View recent logs
firebase functions:log --only makeApiCall
```

### Redeploy Functions
```bash
cd C:\Dev\Projects\RealDeal\functions

# Install dependencies
npm install

# Deploy all functions
firebase deploy --only functions

# Or deploy specific function
firebase deploy --only functions:makeApiCall
```

---

## 4. Verify Endpoints

### Cloud Functions Base URL
```
https://us-west1-habu-1gxak2.cloudfunctions.net/
```

### Test Endpoints
```bash
# Test makeApiCall (requires auth token)
curl -X POST "https://us-west1-habu-1gxak2.cloudfunctions.net/makeApiCall" \
  -H "Content-Type: application/json" \
  -d '{"callName": "ListAllProductsCall"}'
```

---

## 5. Websites Status

| Site | URL | Hosting | Status |
|------|-----|---------|--------|
| Landing | https://getrealdeal.ai | Vercel | ✅ Online (HTTP 200) |
| App | https://app.getrealdeal.ai | Firebase Hosting | ✅ Online (HTTP 200) |

### Verify Websites
- [x] https://getrealdeal.ai loads
- [x] https://app.getrealdeal.ai loads
- [ ] Login/signup works
- [ ] Property search returns results

---

## 6. Known Issues

### Critical - Immediate Action Required
1. **RapidAPI subscription EXPIRED** (Tested 2026-02-05)
   - Zillow API returns 404 - subscription inactive
   - Property search is completely broken
   - **Action:** Renew subscription at https://rapidapi.com/apimaker/api/zillow-com1
   - Cost: ~$50-100/month depending on plan

### Critical - Action Required by March 2026
2. **Firebase config deprecation** - Must migrate from `functions.config()` to `.env` files
   - Current: Keys stored via `firebase functions:config:set`
   - Required: Copy to `.env` file and update code to use `process.env`
   - Deadline: March 2026 (Cloud Runtime Configuration API shutdown)

### Verified Working
1. ✅ Stripe API key configured
2. ✅ HubSpot API key configured
3. ✅ 14 Cloud Functions deployed and running
4. ✅ Both websites accessible

### To Investigate
1. ~~RapidAPI subscription status~~ **CONFIRMED EXPIRED**
2. Stripe webhook endpoint - verify configured correctly
3. GA4 service account - may not be configured

---

## 7. Roadmap Tasks (from roadmap tracker)

| Task ID | Description | Hours | Status |
|---------|-------------|-------|--------|
| GRD-1 | Restore application | 4h | Done |
| GRD-2 | Frontend review | 8h | Pending |
| GRD-3 | Tie into OA logic | 16h | Pending |

---

## 8. Migration Steps (Required by March 2026)

### Export current config to .env
```bash
cd C:\Dev\Projects\RealDeal\functions

# View current config
firebase functions:config:get

# Create .env from template
cp .env.example .env

# Copy values from config to .env:
# zillow.api_key → RAPID_API_KEY
# stripe.secret → STRIPE_SECRET_KEY
# hubspot.api_key → HUBSPOT_API_KEY
```

### Update code to use process.env
The functions already use `process.env`, but verify:
- `zillowApi.js`: uses `process.env.RAPID_API_KEY`
- `redfinApi.js`: uses `process.env.RAPID_API_KEY`
- `api_manager.js`: uses `process.env.STRIPE_SECRET_KEY`
- `hubspotIntegration.js`: uses `process.env.HUBSPOT_API_KEY`

### Deploy with .env (after migration)
```bash
firebase deploy --only functions
```

### Verify
```bash
firebase functions:log --only testSimple
```

---

## 9. Architecture Reference

```
RealDeal/
├── landing/          # Marketing site (React+Vite) → Vercel
├── app/              # Flutter app → Firebase Hosting
│   └── lib/
│       └── backend/
│           └── api_requests/  # Calls Cloud Functions
└── functions/        # Firebase Cloud Functions (Node 22)
    ├── index.js      # Main entry, exports callable functions
    ├── api_manager.js    # Stripe API calls
    ├── zillowApi.js      # Zillow RapidAPI
    ├── redfinApi.js      # Redfin RapidAPI
    ├── hubspotIntegration.js  # HubSpot CRM
    └── ga4Service.js     # Google Analytics
```

---

**Next Steps:**
1. ✅ Verified: API keys are configured via Firebase config
2. ✅ Verified: Functions are deployed and running
3. ✅ Verified: Websites are accessible
4. ❌ **FAILED:** Property search - RapidAPI subscription expired
5. **URGENT:** Renew RapidAPI subscription (~$50-100/month)
6. **TODO:** Migrate to `.env` files before March 2026 deadline
7. **TODO:** Complete GRD-2 (Frontend review - 8h)
8. **TODO:** Complete GRD-3 (Tie into OA logic - 16h)

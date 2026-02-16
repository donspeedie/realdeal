# RealDeal.ai - System Verification Checklist

**Created:** 2026-02-05
**Purpose:** Verify system integrity and document required setup steps

---

## 1. Environment Variables Status

| Variable | Required | Status | Notes |
|----------|----------|--------|-------|
| `RAPID_API_KEY` | Yes | ❌ **EXPIRED** | Key exists but subscription inactive (404) |
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

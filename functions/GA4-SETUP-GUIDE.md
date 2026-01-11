# GA4 Integration Setup Guide

Complete guide for setting up Google Analytics 4 data feed into RealDeal engagement tracking.

---

## Overview

This integration:
- **Fetches** GA4 web analytics data (page views, events, conversions)
- **Transforms** GA4 events into engagement events
- **Syncs** automatically every day at 8 AM PST
- **Stores** in Firestore `engagements` collection

---

## Prerequisites

✅ Google Cloud project (same as Firebase project)
✅ GA4 property created
✅ Service account with GA4 Data API access
✅ Firebase Cloud Functions deployed

---

## Part 1: GA4 Setup

### Step 1: Create GA4 Property

1. Go to [Google Analytics](https://analytics.google.com/)
2. **Admin** → **Create Property**
3. Property name: `RealDeal.ai`
4. Timezone: Your timezone
5. Currency: USD
6. Click **Create**

### Step 2: Set Up Web Data Stream

1. In Property → **Data Streams** → **Add stream** → **Web**
2. Configure:
   - **Website URL**: Your landing page URL
   - **Stream name**: `RealDeal Web App`
   - **Enhanced measurement**: Toggle ON
3. Click **Create stream**
4. **SAVE**: Copy your **Measurement ID** (format: `G-XXXXXXXXXX`)

### Step 3: Install GA4 Tracking Code

**Option A: Using Firebase Hosting (Recommended)**

1. Firebase Console → Your project
2. **Project Settings** → **Integrations**
3. **Google Analytics** → **Link**
4. Select your GA4 property
5. **Enable Google Analytics**

**Option B: Manual Installation (React)**

Add to your `index.html` or main app component:

```html
<!-- Google Analytics 4 -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

Replace `G-XXXXXXXXXX` with your Measurement ID.

---

## Part 2: API Access Setup

### Step 4: Enable GA4 Data API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. **☰** → **APIs & Services** → **Library**
4. Search: **"Google Analytics Data API"**
5. Click → **Enable**

### Step 5: Create Service Account

1. **☰** → **APIs & Services** → **Credentials**
2. **Create Credentials** → **Service Account**
3. Fill in:
   - Name: `ga4-data-reader`
   - Description: `Service account for GA4 data access`
4. Click **Create and Continue**
5. Grant role: **Viewer**
6. Click **Done**

### Step 6: Generate Service Account Key

1. Click on the service account you just created
2. **Keys** tab → **Add Key** → **Create new key**
3. Select **JSON** → **Create**
4. File downloads automatically
5. **IMPORTANT**: Rename to `ga4-service-account.json`
6. Move to: `C:\Projects\RealDeal\backend\functions\ga4-service-account.json`

### Step 7: Grant GA4 Access to Service Account

1. Copy service account email (format: `ga4-data-reader@PROJECT_ID.iam.gserviceaccount.com`)
2. Go to [Google Analytics](https://analytics.google.com/) → **Admin**
3. **Property** → **Property Access Management**
4. Click **+** (top right) → **Add users**
5. Paste service account email
6. Role: **Viewer**
7. Click **Add**

---

## Part 3: Configure Environment Variables

### Step 8: Add to `.env` File

Edit `C:\Projects\RealDeal\backend\functions\.env`:

```bash
# GA4 Configuration
GA4_PROPERTY_ID=123456789
GA4_SERVICE_ACCOUNT_PATH=./ga4-service-account.json
DEFAULT_USER_ID=your_user_id_here
```

**How to find GA4_PROPERTY_ID:**

1. Google Analytics → **Admin** → **Property Settings**
2. Look for **Property ID** (9-digit number like `123456789`)
3. **NOT** the Measurement ID (G-XXXXXXXXXX)

**Set DEFAULT_USER_ID:**

- Your Firebase user ID (from Authentication)
- Or use `default_user` for testing

### Step 9: Update `.gitignore`

Ensure these are in `.gitignore`:

```
# GA4 credentials
ga4-service-account.json
.env
.env.local
```

**⚠️ NEVER commit these files to git!**

---

## Part 4: Deploy and Test

### Step 10: Deploy Functions

```bash
cd C:\Projects\RealDeal\backend\functions
firebase deploy --only functions:syncGA4DataDaily,functions:testGA4Sync
```

Wait for deployment to complete (~2-3 minutes).

### Step 11: Test Connection

**Method 1: Using curl**

```bash
curl -X POST https://YOUR_REGION-YOUR_PROJECT.cloudfunctions.net/testGA4Sync \
  -H "Content-Type: application/json" \
  -d '{
    "propertyId": "123456789",
    "startDate": "7daysAgo",
    "endDate": "yesterday",
    "dryRun": true
  }'
```

**Method 2: Using Firebase Emulator (Local Testing)**

```bash
# Start emulator
cd C:\Projects\RealDeal\backend\functions
npm run serve

# In another terminal
curl -X POST http://localhost:5001/YOUR_PROJECT/us-west1/testGA4Sync \
  -H "Content-Type: application/json" \
  -d '{
    "propertyId": "123456789",
    "startDate": "yesterday",
    "endDate": "yesterday",
    "dryRun": true
  }'
```

**Expected Response:**

```json
{
  "success": true,
  "connection": {
    "success": true,
    "propertyId": "123456789",
    "message": "Successfully connected to GA4..."
  },
  "ga4Events": 45,
  "engagementsCreated": 12,
  "dryRun": true,
  "sampleEngagements": [...],
  "timestamp": "2025-11-18T..."
}
```

### Step 12: Verify Firestore Data

1. Firebase Console → **Firestore Database**
2. Look for `engagements` collection
3. Check for new documents with:
   - `eventType`: "landing_page_view", "form_submission", etc.
   - `source`: "google_ads", "facebook_organic", etc.
   - `stage`: "awareness", "follow_up", etc.
   - `metadata`: GA4 event details

---

## Part 5: Scheduled Sync

### Step 13: Verify Scheduler

The `syncGA4DataDaily` function runs automatically every day at 8 AM PST.

**Check scheduler status:**

1. Firebase Console → **Functions**
2. Find `syncGA4DataDaily`
3. Click → **Logs** tab
4. Look for scheduled executions

**Manually trigger scheduled function (testing):**

```bash
# Using Firebase CLI
firebase functions:shell

# In shell
syncGA4DataDaily({})
```

---

## Troubleshooting

### Issue: "GA4_PROPERTY_ID not provided"

**Solution:**
- Check `.env` file has `GA4_PROPERTY_ID=123456789`
- Redeploy functions after changing `.env`
- Use Property ID (numbers only), not Measurement ID (G-XXX)

### Issue: "Permission denied on GA4 API"

**Solution:**
- Verify service account email is added to GA4 Property Access
- Grant **Viewer** role minimum
- Wait 5-10 minutes for permissions to propagate

### Issue: "No events to sync"

**Possible causes:**
- Landing page has no traffic yet
- GA4 tracking code not installed correctly
- Data delay (GA4 processes data with 24-48 hour delay for some metrics)

**Test with sample data:**
- Visit your landing page multiple times
- Wait 24 hours
- Run `testGA4Sync` with `startDate: "7daysAgo"`

### Issue: Service account key not found

**Solution:**
```bash
# Verify file exists
ls C:\Projects\RealDeal\backend\functions\ga4-service-account.json

# Check path in .env
cat C:\Projects\RealDeal\backend\functions\.env
```

---

## Event Type Mappings

GA4 events are automatically mapped to engagement event types:

| GA4 Event | Engagement Type | Funnel Stage |
|-----------|-----------------|--------------|
| `page_view` | `landing_page_view` | Awareness |
| `first_visit` | `landing_page_view` | Awareness |
| `scroll` | `content_engagement` | Awareness |
| `form_submit` | `form_submission` | Follow-up |
| `sign_up` | `app_signup` | Follow-up |
| `generate_lead` | `form_submission` | Follow-up |
| `purchase` | `deal_closed` | Converted |

## Source Mappings

GA4 source/medium combinations are mapped to engagement sources:

| GA4 Source | GA4 Medium | Engagement Source |
|------------|------------|-------------------|
| google | cpc | `google_ads` |
| google | organic | `google_organic` |
| facebook | cpc/paid | `facebook_ads` |
| facebook | organic | `facebook_organic` |
| linkedin | cpc/paid | `linkedin_ads` |
| linkedin | organic | `linkedin_organic` |
| (direct) | (none) | `direct` |
| email | email | `email` |
| * | referral | `referral` |

---

## Data Flow

```
GA4 Property
    ↓
Daily at 8 AM PST
    ↓
Cloud Function: syncGA4DataDaily
    ↓
Fetch yesterday's events via GA4 Data API
    ↓
Transform to engagement events
    ↓
Filter & deduplicate
    ↓
Write to Firestore: engagements collection
    ↓
Dashboard auto-updates
```

---

## Cost Estimation

**GA4 Data API Quotas (Free Tier):**
- 25,000 requests per day per property
- 200 requests per hour per property
- Daily sync uses ~2-4 requests per day

**Firebase Cloud Functions:**
- Scheduled function: ~2-5 seconds execution time
- Daily cost: < $0.01/day
- Monthly cost: ~$0.30/month

**Total estimated cost: ~$0.30-$1.00/month**

---

## Next Steps

After GA4 is working:

1. ✅ **Add Facebook Ads integration** (similar pattern)
2. ✅ **Add Google Ads integration** (similar pattern)
3. ✅ **Build email drip campaigns** (SendGrid)
4. ✅ **Create engagement dashboard** (already built in frontend)

---

## Support

**Documentation:**
- [GA4 Data API Docs](https://developers.google.com/analytics/devguides/reporting/data/v1)
- [Firebase Scheduled Functions](https://firebase.google.com/docs/functions/schedule-functions)

**Files Created:**
- `ga4Service.js` - GA4 API client
- `ga4Transformer.js` - Data transformation logic
- `index.js` (updated) - Cloud Functions

**Testing:**
```bash
# Local test
npm run serve
curl -X POST http://localhost:5001/.../testGA4Sync -d '{"dryRun":true}'

# Production test
curl -X POST https://.../testGA4Sync -d '{"dryRun":true}'
```

---

**Setup Complete!** 🎉

Your GA4 data will now automatically sync every day at 8 AM PST.

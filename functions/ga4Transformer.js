/**
 * GA4 Data Transformer
 *
 * Transforms GA4 analytics events into engagement events
 * compatible with the RealDeal engagement tracking system.
 */

const admin = require('firebase-admin');

/**
 * Map GA4 event names to engagement event types
 */
const GA4_EVENT_MAP = {
  // Awareness stage
  'page_view': 'landing_page_view',
  'first_visit': 'landing_page_view',
  'session_start': 'landing_page_view',
  'scroll': 'content_engagement',
  'user_engagement': 'content_engagement',

  // Follow-up stage
  'form_submit': 'form_submission',
  'sign_up': 'app_signup',
  'generate_lead': 'form_submission',
  'click': 'email_click', // Context-dependent

  // Converted stage
  'purchase': 'deal_closed',
  'contact': 'initial_contact',
};

/**
 * Map GA4 source/medium to engagement source
 */
function mapGA4Source(source, medium) {
  const lowerSource = (source || '').toLowerCase();
  const lowerMedium = (medium || '').toLowerCase();

  // Google Ads
  if (lowerSource.includes('google') && lowerMedium.includes('cpc')) {
    return 'google_ads';
  }

  // Facebook Ads
  if (lowerSource.includes('facebook') || lowerSource.includes('fb')) {
    if (lowerMedium.includes('cpc') || lowerMedium.includes('paid')) {
      return 'facebook_ads';
    }
    return 'facebook_organic';
  }

  // LinkedIn
  if (lowerSource.includes('linkedin')) {
    if (lowerMedium.includes('cpc') || lowerMedium.includes('paid')) {
      return 'linkedin_ads';
    }
    return 'linkedin_organic';
  }

  // Organic search
  if (lowerMedium === 'organic') {
    if (lowerSource.includes('google')) return 'google_organic';
    if (lowerSource.includes('bing')) return 'bing';
    return 'organic_search';
  }

  // Email
  if (lowerMedium === 'email' || lowerSource.includes('email')) {
    return 'email';
  }

  // Referral
  if (lowerMedium === 'referral') {
    return 'referral';
  }

  // Direct
  if (lowerSource === '(direct)' || lowerSource === 'direct') {
    return 'direct';
  }

  // Default
  return 'web_other';
}

/**
 * Determine funnel stage based on event type
 */
function getFunnelStage(eventType) {
  const awarenessEvents = [
    'landing_page_view',
    'social_post',
    'ad_impression',
    'ad_click',
    'content_engagement',
  ];

  const followUpEvents = [
    'email_open',
    'email_click',
    'form_submission',
    'phone_call',
    'meeting_scheduled',
    'app_signup',
    'initial_contact',
  ];

  const convertedEvents = [
    'deal_closed',
    'contract_signed',
    'payment_received',
  ];

  const recommendationEvents = [
    'referral_made',
    'testimonial_given',
    'repeat_purchase',
  ];

  if (awarenessEvents.includes(eventType)) return 'awareness';
  if (followUpEvents.includes(eventType)) return 'follow_up';
  if (convertedEvents.includes(eventType)) return 'converted';
  if (recommendationEvents.includes(eventType)) return 'recommendation';

  return 'awareness'; // Default
}

/**
 * Transform a single GA4 event into an engagement event
 * @param {Object} ga4Event - Raw GA4 event data
 * @param {string} userId - User ID to associate with engagement
 * @returns {Object} Engagement event object
 */
function transformGA4Event(ga4Event, userId) {
  // Map GA4 event name to engagement event type
  const eventType = GA4_EVENT_MAP[ga4Event.eventName] || 'content_engagement';

  // Map source/medium to engagement source
  const source = mapGA4Source(ga4Event.sessionSource, ga4Event.sessionMedium);

  // Determine funnel stage
  const stage = getFunnelStage(eventType);

  // Parse date (GA4 format: YYYYMMDD)
  const dateStr = ga4Event.date || '';
  const timestamp = dateStr.length === 8
    ? admin.firestore.Timestamp.fromDate(
        new Date(
          dateStr.substring(0, 4), // Year
          parseInt(dateStr.substring(4, 6)) - 1, // Month (0-indexed)
          dateStr.substring(6, 8) // Day
        )
      )
    : admin.firestore.Timestamp.now();

  // Build engagement event
  const engagement = {
    userId,
    eventType,
    source,
    stage,
    timestamp,
    metadata: {
      ga4_event_name: ga4Event.eventName,
      ga4_source: ga4Event.sessionSource || 'unknown',
      ga4_medium: ga4Event.sessionMedium || 'unknown',
      page_path: ga4Event.pagePath || '/',
      event_count: ga4Event.eventCount || 1,
      active_users: ga4Event.activeUsers || 1,
      engagement_rate: ga4Event.engagementRate || 0,
      avg_session_duration: ga4Event.averageSessionDuration || 0,
    },
    contactId: null, // Will be set later if contact is matched
    notes: `Auto-imported from GA4: ${ga4Event.eventName} via ${source}`,
  };

  return engagement;
}

/**
 * Transform batch of GA4 events into engagement events
 * @param {Array} ga4Events - Array of GA4 events
 * @param {string} userId - User ID
 * @returns {Array} Array of engagement events
 */
function transformGA4Batch(ga4Events, userId) {
  return ga4Events.map((event) => transformGA4Event(event, userId));
}

/**
 * Deduplicate engagement events (prevent duplicate imports)
 * @param {Array} engagements - Engagement events
 * @returns {Array} Deduplicated events
 */
function deduplicateEngagements(engagements) {
  const seen = new Set();
  const unique = [];

  engagements.forEach((engagement) => {
    // Create unique key based on userId, eventType, source, and date
    const dateStr = engagement.timestamp.toDate().toISOString().split('T')[0];
    const key = `${engagement.userId}_${engagement.eventType}_${engagement.source}_${dateStr}`;

    if (!seen.has(key)) {
      seen.add(key);
      unique.push(engagement);
    }
  });

  return unique;
}

/**
 * Aggregate multiple page views into a single engagement
 * Useful for reducing noise from multiple page views on same day
 * @param {Array} engagements - Engagement events
 * @returns {Array} Aggregated events
 */
function aggregatePageViews(engagements) {
  const aggregated = [];
  const pageViewMap = new Map();

  engagements.forEach((engagement) => {
    if (engagement.eventType === 'landing_page_view') {
      const dateStr = engagement.timestamp.toDate().toISOString().split('T')[0];
      const key = `${engagement.userId}_${engagement.source}_${dateStr}`;

      if (pageViewMap.has(key)) {
        // Increment event count
        const existing = pageViewMap.get(key);
        existing.metadata.event_count += engagement.metadata.event_count || 1;
        existing.metadata.active_users = Math.max(
          existing.metadata.active_users || 0,
          engagement.metadata.active_users || 0
        );
      } else {
        pageViewMap.set(key, engagement);
      }
    } else {
      // Keep non-page-view events as-is
      aggregated.push(engagement);
    }
  });

  // Add aggregated page views
  pageViewMap.forEach((engagement) => aggregated.push(engagement));

  return aggregated;
}

/**
 * Filter out low-value events (e.g., single scroll events)
 * @param {Array} engagements - Engagement events
 * @returns {Array} Filtered events
 */
function filterLowValueEvents(engagements) {
  return engagements.filter((engagement) => {
    // Keep conversion events always
    if (engagement.stage === 'converted') return true;

    // Keep follow-up events always
    if (engagement.stage === 'follow_up') return true;

    // For awareness events, filter out low engagement
    if (engagement.eventType === 'content_engagement') {
      const engagementRate = engagement.metadata.engagement_rate || 0;
      return engagementRate > 0.1; // Only keep if >10% engagement rate
    }

    // Keep everything else
    return true;
  });
}

module.exports = {
  transformGA4Event,
  transformGA4Batch,
  deduplicateEngagements,
  aggregatePageViews,
  filterLowValueEvents,
  mapGA4Source,
  getFunnelStage,
};

/**
 * GA4 Data Service
 *
 * Handles all interactions with Google Analytics 4 Data API.
 * Fetches web analytics data and transforms it into engagement events.
 */

const { BetaAnalyticsDataClient } = require('@google-analytics/data');
const path = require('path');

// Initialize GA4 client
let analyticsDataClient;

/**
 * Initialize GA4 client with service account credentials
 * @param {string} keyFilePath - Path to service account JSON key
 */
function initializeGA4Client(keyFilePath) {
  if (analyticsDataClient) {
    return analyticsDataClient;
  }

  analyticsDataClient = new BetaAnalyticsDataClient({
    keyFilename: keyFilePath,
  });

  return analyticsDataClient;
}

/**
 * Fetch landing page events from GA4
 * @param {string} propertyId - GA4 Property ID (format: "123456789")
 * @param {string} startDate - Start date (YYYY-MM-DD or "NdaysAgo")
 * @param {string} endDate - End date (YYYY-MM-DD or "today")
 * @returns {Promise<Array>} Array of GA4 events
 */
async function fetchLandingPageEvents(propertyId, startDate = 'yesterday', endDate = 'yesterday') {
  if (!analyticsDataClient) {
    throw new Error('GA4 client not initialized. Call initializeGA4Client() first.');
  }

  try {
    const [response] = await analyticsDataClient.runReport({
      property: `properties/${propertyId}`,
      dateRanges: [
        {
          startDate,
          endDate,
        },
      ],
      dimensions: [
        { name: 'eventName' },        // Event type (page_view, user_engagement, etc.)
        { name: 'date' },              // Date (YYYYMMDD format)
        { name: 'pagePath' },          // URL path
        { name: 'sessionSource' },     // Traffic source (google, facebook, direct, etc.)
        { name: 'sessionMedium' },     // Traffic medium (organic, cpc, referral, etc.)
      ],
      metrics: [
        { name: 'eventCount' },        // Number of events
        { name: 'activeUsers' },       // Number of unique users
        { name: 'averageSessionDuration' }, // Avg session length
        { name: 'engagementRate' },    // Engagement rate
      ],
      // Filter for relevant events only
      dimensionFilter: {
        filter: {
          fieldName: 'eventName',
          inListFilter: {
            values: [
              'page_view',
              'user_engagement',
              'session_start',
              'first_visit',
              'form_submit',
              'click',
              'scroll',
            ],
          },
        },
      },
      // Order by date descending
      orderBys: [
        {
          dimension: {
            dimensionName: 'date',
          },
          desc: true,
        },
      ],
    });

    return parseGA4Response(response);
  } catch (error) {
    console.error('Error fetching GA4 data:', error);
    throw error;
  }
}

/**
 * Fetch conversion events from GA4 (form submits, signups)
 * @param {string} propertyId - GA4 Property ID
 * @param {string} startDate - Start date
 * @param {string} endDate - End date
 * @returns {Promise<Array>} Array of conversion events
 */
async function fetchConversionEvents(propertyId, startDate = 'yesterday', endDate = 'yesterday') {
  if (!analyticsDataClient) {
    throw new Error('GA4 client not initialized. Call initializeGA4Client() first.');
  }

  try {
    const [response] = await analyticsDataClient.runReport({
      property: `properties/${propertyId}`,
      dateRanges: [{ startDate, endDate }],
      dimensions: [
        { name: 'eventName' },
        { name: 'date' },
        { name: 'sessionSource' },
        { name: 'sessionMedium' },
      ],
      metrics: [
        { name: 'eventCount' },
        { name: 'activeUsers' },
      ],
      // Only conversion events
      dimensionFilter: {
        filter: {
          fieldName: 'eventName',
          inListFilter: {
            values: [
              'form_submit',
              'sign_up',
              'generate_lead',
              'purchase',
              'contact',
            ],
          },
        },
      },
    });

    return parseGA4Response(response);
  } catch (error) {
    console.error('Error fetching conversion events:', error);
    throw error;
  }
}

/**
 * Parse GA4 API response into structured objects
 * @param {Object} response - Raw GA4 API response
 * @returns {Array} Parsed event data
 */
function parseGA4Response(response) {
  if (!response || !response.rows) {
    return [];
  }

  const events = [];

  response.rows.forEach((row) => {
    const event = {};

    // Parse dimensions
    row.dimensionValues.forEach((dimension, index) => {
      const dimensionName = response.dimensionHeaders[index].name;
      event[dimensionName] = dimension.value;
    });

    // Parse metrics
    row.metricValues.forEach((metric, index) => {
      const metricName = response.metricHeaders[index].name;
      event[metricName] = parseFloat(metric.value) || 0;
    });

    events.push(event);
  });

  return events;
}

/**
 * Get real-time user activity (last 30 minutes)
 * @param {string} propertyId - GA4 Property ID
 * @returns {Promise<Object>} Real-time metrics
 */
async function getRealTimeMetrics(propertyId) {
  if (!analyticsDataClient) {
    throw new Error('GA4 client not initialized. Call initializeGA4Client() first.');
  }

  try {
    const [response] = await analyticsDataClient.runRealtimeReport({
      property: `properties/${propertyId}`,
      dimensions: [
        { name: 'eventName' },
        { name: 'country' },
      ],
      metrics: [
        { name: 'activeUsers' },
      ],
    });

    return parseGA4Response(response);
  } catch (error) {
    console.error('Error fetching real-time metrics:', error);
    throw error;
  }
}

/**
 * Test GA4 connection
 * @param {string} propertyId - GA4 Property ID
 * @returns {Promise<Object>} Connection test result
 */
async function testConnection(propertyId) {
  try {
    const [response] = await analyticsDataClient.runReport({
      property: `properties/${propertyId}`,
      dateRanges: [{ startDate: 'yesterday', endDate: 'yesterday' }],
      dimensions: [{ name: 'date' }],
      metrics: [{ name: 'activeUsers' }],
    });

    return {
      success: true,
      propertyId,
      rowCount: response.rowCount || 0,
      message: `Successfully connected to GA4 property ${propertyId}`,
    };
  } catch (error) {
    return {
      success: false,
      propertyId,
      error: error.message,
      message: 'Failed to connect to GA4',
    };
  }
}

module.exports = {
  initializeGA4Client,
  fetchLandingPageEvents,
  fetchConversionEvents,
  getRealTimeMetrics,
  testConnection,
  parseGA4Response,
};

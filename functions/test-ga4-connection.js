/**
 * Quick test script to verify GA4 connection
 * Run with: node test-ga4-connection.js
 */

require('dotenv').config();
const { initializeGA4Client, testConnection, fetchLandingPageEvents } = require('./ga4Service');

async function testGA4Connection() {
  console.log('🧪 Testing GA4 Connection...\n');

  try {
    // Get config from .env
    const propertyId = process.env.GA4_PROPERTY_ID;
    const keyPath = process.env.GA4_SERVICE_ACCOUNT_PATH;

    console.log('📊 Configuration:');
    console.log(`   Property ID: ${propertyId}`);
    console.log(`   Key Path: ${keyPath}`);
    console.log('');

    // Initialize client
    console.log('🔌 Initializing GA4 client...');
    initializeGA4Client(keyPath);
    console.log('✅ Client initialized\n');

    // Test connection
    console.log('🔍 Testing connection to GA4...');
    const connectionResult = await testConnection(propertyId);

    if (!connectionResult.success) {
      console.error('❌ Connection failed:', connectionResult.error);
      process.exit(1);
    }

    console.log('✅ Connection successful!');
    console.log(`   Property ID: ${connectionResult.propertyId}`);
    console.log(`   Row count: ${connectionResult.rowCount}`);
    console.log('');

    // Fetch sample data
    console.log('📥 Fetching last 7 days of data...');
    const events = await fetchLandingPageEvents(propertyId, '7daysAgo', 'today');

    console.log(`✅ Fetched ${events.length} events\n`);

    if (events.length > 0) {
      console.log('📊 Sample Events (first 5):');
      console.log('─────────────────────────────────────────────────────');
      events.slice(0, 5).forEach((event, index) => {
        console.log(`\n${index + 1}. Event: ${event.eventName}`);
        console.log(`   Date: ${event.date}`);
        console.log(`   Source: ${event.sessionSource || 'direct'}`);
        console.log(`   Medium: ${event.sessionMedium || 'none'}`);
        console.log(`   Page: ${event.pagePath || '/'}`);
        console.log(`   Event Count: ${event.eventCount || 0}`);
        console.log(`   Active Users: ${event.activeUsers || 0}`);
      });
      console.log('\n─────────────────────────────────────────────────────');
    } else {
      console.log('ℹ️  No events found in the last 7 days');
      console.log('   This could mean:');
      console.log('   - GA4 tracking is not installed yet');
      console.log('   - No website traffic in last 7 days');
      console.log('   - Data processing delay (can take 24-48 hours)');
    }

    console.log('\n🎉 GA4 Connection Test Complete!\n');

  } catch (error) {
    console.error('\n❌ Error testing GA4 connection:', error.message);
    console.error('\nFull error:', error);
    process.exit(1);
  }
}

// Run the test
testGA4Connection();

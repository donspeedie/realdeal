// Quick test script for HubSpot integration
require('dotenv').config();
const { getHubSpotClient, findContactByEmail } = require('./hubspotIntegration');

async function testConnection() {
  try {
    console.log('🔍 Testing HubSpot connection...');
    console.log('API Key length:', process.env.HUBSPOT_API_KEY?.length || 0);

    const client = getHubSpotClient();
    console.log('✅ HubSpot client initialized successfully');

    // Try to search for a contact (this will work even if no contact exists)
    console.log('\n🔍 Testing contact search...');
    const result = await findContactByEmail('test@example.com');

    if (result) {
      console.log('✅ Found contact:', result.id);
    } else {
      console.log('ℹ️  No contact found (this is expected for test email)');
    }

    console.log('\n✅ HubSpot integration is working correctly!');
    console.log('Your RealDeal.ai → HubSpot connection is ready to use.');

  } catch (error) {
    console.error('❌ HubSpot connection test failed:');
    console.error('Error:', error.message);
    console.error('\nPlease check:');
    console.error('1. HUBSPOT_API_KEY is set correctly in .env file');
    console.error('2. The API key has the required scopes (contacts read/write)');
    console.error('3. Your internet connection is working');
  }
}

testConnection();

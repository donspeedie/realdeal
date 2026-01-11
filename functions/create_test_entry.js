// Create a test entry in HubSpot
require('dotenv').config();
const { trackPropertyCalculation } = require('./hubspotIntegration');

async function createTestEntry() {
  try {
    console.log('🧪 Creating test entry in HubSpot...\n');

    const testData = {
      email: 'testy@realdeal.ai',
      firstName: 'Testy',
      lastName: 'McTesterson',
      phone: '+1-555-TEST-123',
      address: '123 Test Street, Los Angeles, CA 90001',
      method: 'Fix&Flip'
    };

    console.log('📋 Test data:');
    console.log(JSON.stringify(testData, null, 2));
    console.log();

    const result = await trackPropertyCalculation(testData);

    console.log('\n✅ Test entry created successfully!\n');
    console.log('📊 Results:');
    console.log('├─ Contact ID:', result.contact.id);
    console.log('├─ Contact Email:', result.contact.properties.email);
    console.log('├─ Contact Name:',
      `${result.contact.properties.firstname || 'N/A'} ${result.contact.properties.lastname || 'N/A'}`);
    console.log('└─ Note ID:', result.note.id);
    console.log();
    console.log('🎉 Check your HubSpot portal at:');
    console.log(`   https://app.hubspot.com/contacts/4823994/contact/${result.contact.id}`);

  } catch (error) {
    console.error('❌ Failed to create test entry:');
    console.error('Error:', error.message);
    if (error.body) {
      console.error('Details:', JSON.stringify(error.body, null, 2));
    }
  }
}

createTestEntry();

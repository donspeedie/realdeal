/**
 * Drip Campaign Automation
 *
 * Scheduled function that runs daily to send automated follow-up emails
 * based on engagement timeline
 */

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

// Initialize Firebase Admin if not already initialized
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

interface Engagement {
  id: string;
  eventType: string;
  source: string;
  contactEmail: string;
  timestamp: admin.firestore.Timestamp;
  userId: string;
  metadata?: any;
}

/**
 * Scheduled function - runs daily at 8:00 AM PST
 * Checks for contacts needing follow-up emails
 */
export const runDripCampaigns = functions
  .runWith({
    timeoutSeconds: 540, // 9 minutes
    memory: '512MB',
  })
  .pubsub
  .schedule('0 8 * * *') // Every day at 8:00 AM
  .timeZone('America/Los_Angeles')
  .onRun(async (context) => {
    console.log('[Drip Campaigns] Starting daily run...');

    try {
      // Get all users with engagements
      const usersSnapshot = await db
        .collection('engagements')
        .get();

      const userIds = new Set<string>();
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
        const sent = await processUserDripCampaigns(userId);
        totalEmailsSent += sent;
      }

      console.log(`[Drip Campaigns] Complete. Sent ${totalEmailsSent} emails.`);

      return {
        success: true,
        totalEmailsSent,
        usersProcessed: userIds.size,
      };
    } catch (error) {
      console.error('[Drip Campaigns] Error:', error);
      throw error;
    }
  });

/**
 * Process drip campaigns for a single user
 */
async function processUserDripCampaigns(userId: string): Promise<number> {
  let emailsSent = 0;

  // Get all contacts for this user (unique emails)
  const contactsMap = await getUserContacts(userId);

  // Check each contact for drip campaign eligibility
  for (const [email, lastEngagement] of contactsMap.entries()) {
    // Check 7-day follow-up
    if (shouldSend7DayFollowUp(lastEngagement)) {
      await send7DayEmail(userId, email, lastEngagement);
      emailsSent++;
    }

    // Check 30-day check-in
    else if (shouldSend30DayCheckIn(lastEngagement)) {
      await send30DayEmail(userId, email, lastEngagement);
      emailsSent++;
    }
  }

  return emailsSent;
}

/**
 * Get all unique contacts for a user with their last engagement
 */
async function getUserContacts(
  userId: string
): Promise<Map<string, Engagement>> {
  const snapshot = await db
    .collection('engagements')
    .where('userId', '==', userId)
    .where('contactEmail', '!=', null)
    .orderBy('contactEmail')
    .orderBy('timestamp', 'desc')
    .get();

  const contactsMap = new Map<string, Engagement>();

  snapshot.docs.forEach((doc) => {
    const data = doc.data() as Engagement;
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
function shouldSend7DayFollowUp(engagement: Engagement): boolean {
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
    engagement.eventType !== 'initial_contact' &&
    engagement.eventType !== 'email_sent'
  ) {
    return false;
  }

  // Check if we've already sent 7-day follow-up
  if (engagement.metadata?.drip7DaySent) {
    return false;
  }

  return true;
}

/**
 * Check if contact should receive 30-day check-in
 */
function shouldSend30DayCheckIn(engagement: Engagement): boolean {
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
    engagement.eventType === 'deal_closed' ||
    engagement.eventType === 'contract_signed' ||
    engagement.eventType === 'payment_received' ||
    engagement.eventType === 'referral_made' ||
    engagement.eventType === 'testimonial_given'
  ) {
    return false;
  }

  // Check if we've already sent 30-day check-in
  if (engagement.metadata?.drip30DaySent) {
    return false;
  }

  return true;
}

/**
 * Send 7-day follow-up email
 */
async function send7DayEmail(
  userId: string,
  email: string,
  engagement: Engagement
): Promise<void> {
  console.log(`[Drip] Sending 7-day follow-up to ${email}`);

  // Create email document in 'mail' collection
  await db.collection('mail').add({
    to: email,
    template: {
      name: 'realdeal-followup-7day',
      data: {
        contactName: email.split('@')[0], // Extract name from email
      },
    },
  });

  // Mark as sent in engagement metadata
  await db.collection('engagements').doc(engagement.id).update({
    'metadata.drip7DaySent': true,
    'metadata.drip7DaySentAt': admin.firestore.FieldValue.serverTimestamp(),
  });

  // Create engagement event
  await db.collection('engagements').add({
    eventType: 'email_sent',
    source: 'email',
    contactEmail: email,
    userId,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    metadata: {
      dripCampaign: '7-day-followup',
      templateId: 'realdeal-followup-7day',
    },
  });
}

/**
 * Send 30-day check-in email
 */
async function send30DayEmail(
  userId: string,
  email: string,
  engagement: Engagement
): Promise<void> {
  console.log(`[Drip] Sending 30-day check-in to ${email}`);

  // Create email document in 'mail' collection
  await db.collection('mail').add({
    to: email,
    template: {
      name: 'realdeal-checkin-30day',
      data: {
        contactName: email.split('@')[0],
      },
    },
  });

  // Mark as sent in engagement metadata
  await db.collection('engagements').doc(engagement.id).update({
    'metadata.drip30DaySent': true,
    'metadata.drip30DaySentAt': admin.firestore.FieldValue.serverTimestamp(),
  });

  // Create engagement event
  await db.collection('engagements').add({
    eventType: 'email_sent',
    source: 'email',
    contactEmail: email,
    userId,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    metadata: {
      dripCampaign: '30-day-checkin',
      templateId: 'realdeal-checkin-30day',
    },
  });
}

/**
 * Manual trigger for testing
 * Usage: Call this function manually from Firebase Console or via HTTP
 */
export const triggerDripCampaigns = functions.https.onCall(async (data, context) => {
  // Require authentication
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Must be authenticated to trigger drip campaigns'
    );
  }

  console.log('[Drip] Manual trigger by:', context.auth.uid);

  const userId = data.userId || context.auth.uid;
  const emailsSent = await processUserDripCampaigns(userId);

  return {
    success: true,
    emailsSent,
    userId,
  };
});

const functions = require("firebase-functions");
const admin = require("firebase-admin");
if (admin.apps.length === 0) admin.initializeApp();

const Stripe = require("stripe");
const stripe = new Stripe(functions.config().stripe.secret);
// uses your sk_* from `firebase functions:config:set stripe.secret="..."`

const endpointSecret = functions.config().webhook.secret;
// uses your whsec_* from `firebase functions:config:set webhook.secret="..."`

exports.handleStripeWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers["stripe-signature"];

  let event;
  try {
    // Verify the Stripe signature
    event = stripe.webhooks.constructEvent(req.rawBody, sig, endpointSecret);
  } catch (err) {
    console.error("Webhook signature verification failed:", err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  if (event.type === "checkout.session.completed") {
    const session = event.data.object;
    const stripeCustomerId = session.customer;
    const checkoutId = session.id;
    const tokensToAdd = parseInt(session.metadata.token || "0", 10);

    try {
      const userQuerySnapshot = await admin
        .firestore()
        .collection("UserData")
        .where("stripeCustomerId", "==", stripeCustomerId)
        .limit(1)
        .get();

      if (userQuerySnapshot.empty) {
        console.warn("No user found for Stripe customer ID:", stripeCustomerId);
        return res.status(404).send("User not found");
      }

      const userDoc = userQuerySnapshot.docs[0];
      const userRef = userDoc.ref;

      await userRef.update({
        checkoutCompleted: admin.firestore.FieldValue.arrayUnion(checkoutId),
        tokens: admin.firestore.FieldValue.increment(tokensToAdd),
      });

      console.log(
        `Updated user ${userRef.id} with checkout ${checkoutId} and added ${tokensToAdd} tokens`,
      );
      return res.status(200).send("Success");
    } catch (error) {
      console.error("Error updating user document:", error);
      return res.status(500).send("Internal Server Error");
    }
  } else {
    return res.status(200).send("Event type not handled");
  }
});

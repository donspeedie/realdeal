const functions = require("firebase-functions");
const admin = require("firebase-admin");
// To avoid deployment errors, do not call admin.initializeApp() in your code
const functions = require("firebase-functions");
const admin = require("firebase-admin");
if (admin.apps.length === 0) admin.initializeApp();

const Stripe = require("stripe");
const stripe = new Stripe(functions.config().stripe.secret); // sk_* from functions:config

// quick CORS helper
function allow(req, res) {
  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type, Authorization");
  if (req.method === "OPTIONS") {
    res.status(204).send("");
    return true;
  }
  return false;
}

exports.createCustomer = functions
  .region("us-west1")
  .https.onRequest(async (req, res) => {
    if (allow(req, res)) return;
    try {
      if (req.method !== "POST")
        return res.status(405).send("Method not allowed");

      const { uid, email } = req.body || {};
      if (!uid) return res.status(400).send("Missing uid");

      const userRef = admin.firestore().collection("UserData").doc(uid);
      const snap = await userRef.get();
      if (snap.exists && snap.data()?.stripeCustomerId) {
        return res.json({ customerId: snap.data().stripeCustomerId });
      }

      const customer = await stripe.customers.create({
        email: email || undefined,
        metadata: { uid },
      });

      await userRef.set({ stripeCustomerId: customer.id }, { merge: true });
      return res.json({ customerId: customer.id });
    } catch (e) {
      console.error("createCustomer error:", e);
      return res.status(500).send("createCustomer failed");
    }
  });

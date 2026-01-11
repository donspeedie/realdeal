const functions = require("firebase-functions");
const admin = require("firebase-admin");
// To avoid deployment errors, do not call admin.initializeApp() in your code
const functions = require("firebase-functions");
const admin = require("firebase-admin");
if (admin.apps.length === 0) admin.initializeApp();

const Stripe = require("stripe");
const stripe = new Stripe(functions.config().stripe.secret);

// CORS
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

exports.createCheckoutSession = functions
  .region("us-west1")
  .https.onRequest(async (req, res) => {
    if (allow(req, res)) return;
    try {
      if (req.method !== "POST")
        return res.status(405).send("Method not allowed");

      const {
        line_items_0_price_id,
        line_items_0_quantity,
        customer,
        success_url,
        token,
        uid,
      } = req.body || {};

      if (!line_items_0_price_id)
        return res.status(400).send("Missing line_items_0_price_id");
      if (!customer) return res.status(400).send("Missing customer");
      if (!success_url) return res.status(400).send("Missing success_url");

      const qty = Number(line_items_0_quantity || 1);
      let tokenCount =
        token && typeof token === "object" && "token" in token
          ? token.token
          : token;
      tokenCount = Number(String(tokenCount || 0));

      const session = await stripe.checkout.sessions.create({
        mode: "payment",
        customer,
        client_reference_id: uid || undefined,
        line_items: [{ price: line_items_0_price_id, quantity: qty }],
        success_url,
        cancel_url: success_url,
        metadata: { token: String(tokenCount), uid: uid || "" },
      });

      return res.json({ id: session.id, url: session.url });
    } catch (e) {
      console.error("createCheckoutSession error:", e);
      return res.status(500).send("createCheckoutSession failed");
    }
  });

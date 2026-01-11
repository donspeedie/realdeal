const admin = require("firebase-admin/app");
admin.initializeApp();

const reInvestCalcsCombined = require("./re_invest_calcs_combined.js");
exports.reInvestCalcsCombined = reInvestCalcsCombined.reInvestCalcsCombined;
const handleStripeWebhook = require("./handle_stripe_webhook.js");
exports.handleStripeWebhook = handleStripeWebhook.handleStripeWebhook;
const createCustomer = require("./create_customer.js");
exports.createCustomer = createCustomer.createCustomer;
const createCheckoutSession = require("./create_checkout_session.js");
exports.createCheckoutSession = createCheckoutSession.createCheckoutSession;

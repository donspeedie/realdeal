// Simple test endpoint to verify basic connectivity
const {onRequest} = require("firebase-functions/v2/https");

exports.testSimple = onRequest(async (req, res) => {
  console.log('Simple test endpoint called');

  // Handle CORS
  res.set({
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, OPTIONS, GET",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
  });

  if (req.method === "OPTIONS") {
    return res.status(204).send("");
  }

  // Return simple JSON response instead of SSE
  return res.status(200).json({
    success: true,
    message: "Endpoint is working",
    timestamp: new Date().toISOString(),
    body: req.body
  });
});
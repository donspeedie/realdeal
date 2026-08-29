const admin = require("firebase-admin");

/**
 * Requires a valid Firebase Auth ID token on the `Authorization: Bearer <token>`
 * header. Any signed-in Firebase user (including anonymous auth) satisfies this
 * check — it is not a login wall, just proof the caller went through Firebase Auth.
 *
 * On success, resolves with the decoded token. On failure, writes a 401 JSON
 * response (with CORS still applied so browser callers can read the error) and
 * resolves with null — callers must return immediately when this resolves null.
 */
async function requireFirebaseAuth(req, res) {
  const authHeader = req.get("Authorization") || "";
  const match = /^Bearer (.+)$/.exec(authHeader);
  if (!match) {
    res.set({"Access-Control-Allow-Origin": "*"});
    res.status(401).json({error: "Unauthorized: missing bearer token"});
    return null;
  }
  try {
    return await admin.auth().verifyIdToken(match[1]);
  } catch (error) {
    console.warn("requireFirebaseAuth: token verification failed:", error.message);
    res.set({"Access-Control-Allow-Origin": "*"});
    res.status(401).json({error: "Unauthorized: invalid token"});
    return null;
  }
}

/**
 * Verifies the caller is only reading/writing the HubSpot record for their
 * *own* account (CWE-639: Authorization Bypass Through User-Controlled Key).
 * `requireFirebaseAuth` alone only proves the caller has some valid Firebase
 * session — it does not prove they're allowed to act on the `email` they
 * supplied in the request body/query. This closes that gap by requiring the
 * decoded token's `email` claim to match the requested email.
 *
 * Anonymous Firebase sessions have no `email` claim and always fail this
 * check — there is no verified identity to bind the request to.
 *
 * On success, returns true. On failure, writes a 403 JSON response (with
 * CORS still applied) and returns false — callers must return immediately
 * when this returns false.
 */
function requireOwnEmail(decodedToken, email, res) {
  const tokenEmail = typeof decodedToken.email === "string" ? decodedToken.email.toLowerCase() : null;
  const requestedEmail = typeof email === "string" ? email.toLowerCase() : null;

  if (!tokenEmail || !requestedEmail || tokenEmail !== requestedEmail) {
    res.set({"Access-Control-Allow-Origin": "*"});
    res.status(403).json({error: "Forbidden: email must match the authenticated account"});
    return false;
  }
  return true;
}

module.exports = {requireFirebaseAuth, requireOwnEmail};

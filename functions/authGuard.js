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

module.exports = {requireFirebaseAuth};

// Helpers for logging request data without leaking sensitive values (CWE-532).
// Cloud Functions logs are broadly readable/exportable, so request headers,
// bodies, and query strings must never be dumped raw — auth tokens, cookies,
// and user-supplied data can end up in them.

const safeKeys = (obj) => {
  if (!obj || typeof obj !== "object") return [];
  return Object.keys(obj);
};

module.exports = {
  safeKeys,
};

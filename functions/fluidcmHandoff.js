/**
 * FluidCM Deal Handoff
 *
 * When a deal transitions to "go" in RealDeal, this module creates
 * a corresponding project in FluidCM for construction management.
 *
 * Config (environment variables):
 *   FLUIDCM_API_URL   - FluidCM FastAPI base URL (e.g., https://52.53.76.100:8001)
 *   FLUIDCM_API_TOKEN - Service account Bearer token for FluidCM
 *   FLUIDCM_ORG_ID    - Default organization ID in FluidCM
 */

const axios = require("axios").default;

/**
 * Create a FluidCM project from a RealDeal deal.
 *
 * @param {Object} dealData - The dealAlerts document data
 * @param {string} dealId   - The dealAlerts document ID
 * @returns {Object|null}   - { projectId, projectCode } or null if skipped
 */
async function createFluidCMProject(dealData, dealId) {
  const apiUrl = process.env.FLUIDCM_API_URL;
  const apiToken = process.env.FLUIDCM_API_TOKEN;
  const orgId = parseInt(process.env.FLUIDCM_ORG_ID || "1", 10);

  if (!apiUrl || !apiToken) {
    console.warn("[FluidCM] FLUIDCM_API_URL or FLUIDCM_API_TOKEN not configured, skipping handoff");
    return null;
  }

  // Build project code from address (e.g., "123 Main St" -> "RD-123-MAIN")
  const address = dealData.address || dealData.streetAddress || "Unknown";
  const projectCode = buildProjectCode(address);

  // Build project payload
  const payload = {
    code: projectCode,
    name: address,
    organization_id: orgId,
    description: buildDescription(dealData, dealId),
    zip_code: dealData.zipcode || dealData.zip || undefined,
    base_value: dealData.price || dealData.listPrice || undefined,
  };

  const response = await axios.post(
    `${apiUrl}/api/v1/projects`,
    payload,
    {
      headers: {
        "Authorization": `Bearer ${apiToken}`,
        "Content-Type": "application/json",
      },
      timeout: 10000,
    },
  );

  return {
    projectId: response.data.id,
    projectCode: response.data.code,
  };
}

/**
 * Build a short project code from an address.
 * "4901 Parker Ave, Patterson CA" -> "RD-4901-PARKER"
 */
function buildProjectCode(address) {
  const parts = address.split(/[\s,]+/).filter(Boolean);
  const number = parts.find((p) => /^\d+$/.test(p)) || "";
  const street = parts.find((p) => /^[A-Za-z]{3,}$/.test(p) && !isStopWord(p)) || "";
  const code = `RD-${number}-${street}`.toUpperCase().slice(0, 15);
  return code || `RD-${Date.now().toString(36).toUpperCase()}`;
}

function isStopWord(word) {
  return ["the", "and", "ave", "street", "drive", "road", "lane", "way", "blvd", "court"].includes(
    word.toLowerCase(),
  );
}

/**
 * Build a project description from deal data.
 */
function buildDescription(dealData, dealId) {
  const lines = [`Imported from RealDeal deal ${dealId}`];
  if (dealData.method) lines.push(`Strategy: ${dealData.method}`);
  if (dealData.price) lines.push(`List price: $${Number(dealData.price).toLocaleString()}`);
  if (dealData.score) lines.push(`Deal score: ${dealData.score}`);
  if (dealData.recommendation) lines.push(`Recommendation: ${dealData.recommendation}`);
  return lines.join("\n");
}

module.exports = {createFluidCMProject};

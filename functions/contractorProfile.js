/**
 * Contractor Profile Schema & Utilities
 *
 * Defines the blank contractor profile structure used during onboarding.
 * When a service work contractor is brought on board with FluidCM,
 * an agent interviews them to populate this profile.
 *
 * Firestore collection: contractors/{contractorId}
 */

/**
 * Returns a blank contractor profile with all fields initialized.
 * This is the starting point for the onboarding interview.
 */
function createBlankProfile(email) {
  return {
    // ── Identity ──────────────────────────────────────────────
    email: email || "",
    displayName: "",
    companyName: "",
    phone: "",
    photoUrl: "",

    // ── Onboarding Status ─────────────────────────────────────
    onboardingStatus: "pending", // pending | in_progress | completed
    onboardingStartedAt: null,
    onboardingCompletedAt: null,
    createdAt: new Date().toISOString(),

    // ── Trade & Specialization ────────────────────────────────
    primaryTrade: "", // e.g. "general", "electrical", "plumbing", "roofing", "hvac", "framing", "concrete", "landscaping"
    secondaryTrades: [], // additional capabilities
    licenseNumber: "",
    licenseState: "",
    insured: false,
    bonded: false,

    // ── Service Area & Availability ───────────────────────────
    serviceAreaZips: [], // zip codes they cover
    serviceRadiusMiles: null,
    baseCity: "",
    baseState: "",
    availabilityNotes: "", // e.g. "booked through May, available for small jobs"
    preferredProjectSize: "", // "small", "medium", "large", "any"

    // ── Experience & Track Record ─────────────────────────────
    yearsInBusiness: null,
    projectsCompleted: null, // rough estimate
    typicalProjectTypes: [], // e.g. ["fix_and_flip", "adu", "new_build", "add_on", "rental_rehab"]
    portfolioLinks: [], // links to past work, social media, website
    references: [], // { name, phone, relationship }

    // ── Pricing & Approach ────────────────────────────────────
    rateStructure: "", // "hourly", "per_sqft", "fixed_bid", "time_and_materials", "flexible"
    hourlyRateRange: {min: null, max: null}, // if hourly
    typicalSqftRate: null, // if per-sqft
    estimateLeadTimeDays: null, // how fast they can turn around a bid
    paymentTerms: "", // e.g. "50/50", "30/40/30 draw schedule", "net 30"

    // ── Capacity ──────────────────────────────────────────────
    crewSize: null,
    concurrentProjects: null, // how many jobs they can run simultaneously
    hasOwnEquipment: false,
    subcontractsOut: [], // trades they sub out (e.g. ["electrical", "plumbing"])

    // ── Communication Preferences ─────────────────────────────
    preferredContact: "", // "phone", "text", "email", "app"
    responseTimeExpectation: "", // "same_day", "next_day", "within_48h"
    usesProjectMgmtSoftware: false,
    existingSoftware: [], // e.g. ["buildertrend", "procore", "none"]

    // ── FluidCM Integration ───────────────────────────────────
    fluidcmContractorId: null, // set after FluidCM profile is created
    fluidcmOrgId: null,
    agreedToTerms: false,
    agreedToTermsAt: null,

    // ── Agent Interview Transcript ────────────────────────────
    interviewTranscript: [], // { role: "agent"|"contractor", message, timestamp }
    interviewNotes: "", // agent-generated summary after interview
  };
}

/**
 * Validate that a profile has the minimum required fields for FluidCM onboarding.
 */
function validateProfileForOnboarding(profile) {
  const required = [
    {field: "displayName", label: "Full name"},
    {field: "phone", label: "Phone number"},
    {field: "primaryTrade", label: "Primary trade"},
    {field: "serviceAreaZips", label: "Service area", check: (v) => Array.isArray(v) && v.length > 0},
    {field: "licenseNumber", label: "License number"},
    {field: "insured", label: "Insurance confirmation", check: (v) => v === true},
  ];

  const missing = [];
  for (const req of required) {
    const value = profile[req.field];
    if (req.check) {
      if (!req.check(value)) missing.push(req.label);
    } else if (!value) {
      missing.push(req.label);
    }
  }

  return {
    valid: missing.length === 0,
    missing,
  };
}

/**
 * Map RealDeal investment strategy names to contractor-friendly project types.
 */
const STRATEGY_TO_PROJECT_TYPE = {
  "Fix & Flip": "fix_and_flip",
  "Add-On": "add_on",
  "ADU": "adu",
  "New Build": "new_build",
  "Rental": "rental_rehab",
};

module.exports = {createBlankProfile, validateProfileForOnboarding, STRATEGY_TO_PROJECT_TYPE};

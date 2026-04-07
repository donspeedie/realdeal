/**
 * Contractor Onboarding Cloud Functions
 *
 * Endpoints for creating, updating, and managing contractor profiles
 * during the onboarding interview flow.
 *
 * Firestore collection: contractors/{contractorId}
 */

const admin = require("firebase-admin");
const {createBlankProfile, validateProfileForOnboarding} = require("./contractorProfile");

/**
 * Initialize a new contractor profile.
 * Called when starting the onboarding interview.
 *
 * @param {Object} req.body - { email, displayName? }
 * @returns {Object} - { contractorId, profile }
 */
async function initContractorProfile(req, res) {
  try {
    const {email, displayName} = req.body;

    if (!email) {
      return res.status(400).json({error: "Email is required"});
    }

    // Check for existing profile
    const existing = await admin.firestore()
      .collection("contractors")
      .where("email", "==", email)
      .limit(1)
      .get();

    if (!existing.empty) {
      const doc = existing.docs[0];
      return res.json({
        contractorId: doc.id,
        profile: doc.data(),
        existing: true,
      });
    }

    // Create blank profile
    const profile = createBlankProfile(email);
    if (displayName) profile.displayName = displayName;
    profile.onboardingStatus = "in_progress";
    profile.onboardingStartedAt = new Date().toISOString();

    const docRef = await admin.firestore()
      .collection("contractors")
      .add(profile);

    return res.json({
      contractorId: docRef.id,
      profile,
      existing: false,
    });
  } catch (error) {
    console.error("[ContractorOnboarding] initContractorProfile error:", error);
    return res.status(500).json({error: "Failed to create contractor profile"});
  }
}

/**
 * Update contractor profile with interview responses.
 * Called incrementally as the agent collects answers.
 *
 * @param {Object} req.body - { contractorId, updates: {...}, transcript?: { role, message } }
 */
async function updateContractorProfile(req, res) {
  try {
    const {contractorId, updates, transcript} = req.body;

    if (!contractorId) {
      return res.status(400).json({error: "contractorId is required"});
    }

    const docRef = admin.firestore().collection("contractors").doc(contractorId);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({error: "Contractor not found"});
    }

    const updateData = {...updates};

    // Append to interview transcript if provided
    if (transcript) {
      updateData.interviewTranscript = admin.firestore.FieldValue.arrayUnion({
        ...transcript,
        timestamp: new Date().toISOString(),
      });
    }

    await docRef.update(updateData);

    const updated = (await docRef.get()).data();
    const validation = validateProfileForOnboarding(updated);

    return res.json({
      profile: updated,
      validation,
    });
  } catch (error) {
    console.error("[ContractorOnboarding] updateContractorProfile error:", error);
    return res.status(500).json({error: "Failed to update contractor profile"});
  }
}

/**
 * Complete the onboarding process.
 * Validates the profile and optionally creates the FluidCM contractor record.
 *
 * @param {Object} req.body - { contractorId, interviewNotes? }
 */
async function completeOnboarding(req, res) {
  try {
    const {contractorId, interviewNotes} = req.body;

    if (!contractorId) {
      return res.status(400).json({error: "contractorId is required"});
    }

    const docRef = admin.firestore().collection("contractors").doc(contractorId);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({error: "Contractor not found"});
    }

    const profile = doc.data();
    const validation = validateProfileForOnboarding(profile);

    if (!validation.valid) {
      return res.status(400).json({
        error: "Profile incomplete",
        missing: validation.missing,
        message: `Missing required fields: ${validation.missing.join(", ")}`,
      });
    }

    const updateData = {
      onboardingStatus: "completed",
      onboardingCompletedAt: new Date().toISOString(),
    };

    if (interviewNotes) {
      updateData.interviewNotes = interviewNotes;
    }

    // Create FluidCM contractor record if configured
    const fluidcmResult = await createFluidCMContractor(profile);
    if (fluidcmResult) {
      updateData.fluidcmContractorId = fluidcmResult.contractorId;
      updateData.fluidcmOrgId = fluidcmResult.orgId;
    }

    await docRef.update(updateData);

    return res.json({
      success: true,
      contractorId,
      fluidcmContractorId: fluidcmResult?.contractorId || null,
      validation,
    });
  } catch (error) {
    console.error("[ContractorOnboarding] completeOnboarding error:", error);
    return res.status(500).json({error: "Failed to complete onboarding"});
  }
}

/**
 * Create a contractor record in FluidCM.
 * Returns null if FluidCM is not configured.
 */
async function createFluidCMContractor(profile) {
  const apiUrl = process.env.FLUIDCM_API_URL;
  const apiToken = process.env.FLUIDCM_API_TOKEN;
  const orgId = parseInt(process.env.FLUIDCM_ORG_ID || "1", 10);

  if (!apiUrl || !apiToken) {
    console.warn("[ContractorOnboarding] FluidCM not configured, skipping contractor creation");
    return null;
  }

  try {
    const axios = require("axios").default;
    const response = await axios.post(
      `${apiUrl}/api/v1/contractors`,
      {
        name: profile.displayName,
        company: profile.companyName,
        email: profile.email,
        phone: profile.phone,
        organization_id: orgId,
        trade: profile.primaryTrade,
        license_number: profile.licenseNumber,
        insured: profile.insured,
        bonded: profile.bonded,
        service_area_zips: profile.serviceAreaZips,
        notes: profile.interviewNotes || "",
      },
      {
        headers: {
          "Authorization": `Bearer ${apiToken}`,
          "Content-Type": "application/json",
        },
        timeout: 10000,
      },
    );

    return {
      contractorId: response.data.id,
      orgId,
    };
  } catch (error) {
    console.error("[ContractorOnboarding] FluidCM contractor creation failed:", error.message);
    return null;
  }
}

module.exports = {initContractorProfile, updateContractorProfile, completeOnboarding};

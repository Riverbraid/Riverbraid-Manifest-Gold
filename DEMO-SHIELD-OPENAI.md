# Demo: Riverbraid Shield + OpenAI Integration

## 1. Normal Operation (Verification Passed)
**Input:** `POST /v1/chat/completions` (Policy: Safety-Audit-V1)
**Shield Processing:**
- Fetching Manifest: `fa7475`
- Validating Local Substrate... [OK]
- Proxying Request to Provider... [OK]
- Verifying Response Hash... [OK]
**Result:** 200 OK (Payload includes `x-riverbraid-signature`)

## 2. Tamper Attempt (Fail-Closed Triggered)
**Action:** Manually modified `sovereign-manifest.json` by 1 bit.
**Shield Processing:**
- Fetching Manifest: `fa7475`
- Validating Local Substrate... [FAIL]
- **REASON:** Merkle Root Mismatch (Expected: `fa7475`, Found: `b1c2...`)
**Result:** 500 Internal Server Error
**Output:** `Verification Error: System Integrity Compromised. Execution Halted.`

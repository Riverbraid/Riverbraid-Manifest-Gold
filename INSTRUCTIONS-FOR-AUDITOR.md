# Independent Reproduction & Audit Protocol

This document defines the procedure for verifying the Riverbraid v1.5.0-Genesis stationary state.

## 1. Environment Setup
- **OS:** Ubuntu 22.04 or equivalent (clean environment preferred).
- **Node.js:** v20.11.0.
- **Tools:** Git, GPG, Python (for OpenTimestamps).

## 2. Reproduction Sequence
1. **Clone the Manifest:**
   `git clone https://github.com/Riverbraid/Riverbraid-Manifest-Gold.git`
2. **Execute Global Audit:**
   Run `node generate-swarm-manifest.cjs`.
3. **Verify Sovereign Root:**
   Confirm the output `FINAL_SWARM_ROOT` matches `fa7475`.
4. **Verify Bitcoin Anchor:**
   Run `ots verify anchor/anchor.txt.ots`. Confirm it hashes to the Sovereign Root.

## 3. Tamper Verification (Negative Testing)
To confirm the fail-closed nature, perform the following:
- Modify a single character in any repository listed in the manifest.
- Re-run the audit.
- **Expected Result:** Absolute failure/mismatch of the Merkle Root.

## 4. Reporting
Please document:
- The `SHA256` of your local environment's output.
- Any discrepancy found.
- The GPG fingerprint used to sign your audit report.

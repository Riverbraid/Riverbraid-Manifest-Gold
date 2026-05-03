const fs = require('fs');
const path = require('path');
const manifestPath = path.join(__dirname, 'riverbraid.constellation.json');

const exists = fs.existsSync(manifestPath);
let isValid = false;

if (exists) {
  try {
    const data = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
    isValid = Array.isArray(data.canonical_floor);
  } catch (e) {
    isValid = false;
  }
}

console.log(JSON.stringify({
  repo: "Riverbraid-Manifest-Gold",
  state: "active",
  status: (exists && isValid) ? "PASS" : "FAIL",
  claim_boundary: "manifest-structural-integrity",
  failure_codes: exists ? (isValid ? [] : ["RB_MANIFEST_INVALID"]) : ["RB_MANIFEST_MISSING"]
}));
const fs = require('fs');
const path = require('path');

describe('Phase 4: Identity & Protocol Binding', () => {
  const manifest = JSON.parse(fs.readFileSync('./riverbraid.constellation.json', 'utf8'));

  test('Core identity matches Manifest expectations', () => {
    const coreContractPath = path.join(__dirname, '../../Riverbraid-Core/riverbraid.contract.json');
    const coreContract = JSON.parse(fs.readFileSync(coreContractPath, 'utf8'));
    const manifestEntry = manifest.repositories.find(r => r.name === "Riverbraid-Core");

    expect(coreContract.role).toBe(manifestEntry.role);
    expect(coreContract.authority).toBe(manifestEntry.authority);
  });
});

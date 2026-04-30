const fs = require('fs');
const manifest = JSON.parse(fs.readFileSync('./riverbraid.constellation.json', 'utf8'));

describe('Phase 0: Topology Integrity', () => {
  test('Constellation contains exactly 45 repositories', () => {
    // Current list is partial; update this as the list expands
    expect(manifest.total_repos).toBe(45);
  });

  test('All repositories use locked vocabulary for State', () => {
    const validStates = ['active', 'parked', 'experimental', 'deprecated', 'archived'];
    manifest.repositories.forEach(repo => {
      expect(validStates).toContain(repo.state);
    });
  });

  test('All repositories use locked vocabulary for Authority', () => {
    const validAuthorities = ['normative', 'verifier', 'support', 'informative', 'none'];
    manifest.repositories.forEach(repo => {
      expect(validAuthorities).toContain(repo.authority);
    });
  });
});

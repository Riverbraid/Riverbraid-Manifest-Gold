const fs = require('fs');
const crypto = require('crypto');

const agents = fs.readdirSync('..').filter(n => n.startsWith('Riverbraid-') && n.endsWith('-Gold'));
const manifest = {
    version: "1.5.0",
    timestamp: new Date().toISOString(),
    agents: {}
};

agents.forEach(agent => {
    const snapshotPath = `../${agent}/constitution.snapshot.json`;
    if (fs.existsSync(snapshotPath)) {
        const content = fs.readFileSync(snapshotPath);
        manifest.agents[agent] = {
            signature_hash: crypto.createHash('sha256').update(content).digest('hex')
        };
    }
});

const finalBuffer = Buffer.from(JSON.stringify(manifest.agents, Object.keys(manifest.agents).sort()));
const root = crypto.createHash('sha256').update(finalBuffer).digest('hex').substring(0, 6);

fs.writeFileSync('/workspaces/Riverbraid-Manifest-Gold/swarm.manifest.json', JSON.stringify(manifest, null, 2));
console.log(`[GENESIS] Swarm Manifest Created.`);
console.log(`[ROOT] Merkle Root: ${root}`);

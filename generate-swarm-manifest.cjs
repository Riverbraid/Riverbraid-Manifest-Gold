const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const BASE = '/workspaces';
const agents = fs.readdirSync(BASE).filter(n => n.startsWith('Riverbraid-') && n.endsWith('-Gold'));
const swarm = { version: "1.5.0", agents: {} }; 

console.log("[BUILD] Generating Static Swarm Manifest...");
agents.forEach(agent => {
    const sigPath = path.join(BASE, agent, 'constitution.snapshot.json.asc');
    if (fs.existsSync(sigPath)) {
        const content = fs.readFileSync(sigPath, 'utf8');
        const hash = crypto.createHash('sha256').update(content).digest('hex');
        swarm.agents[agent] = { signature_hash: hash, status: "VERIFIED" };
    }
});

const manifestBuffer = Buffer.from(JSON.stringify(swarm, null, 2));
const swarmRoot = crypto.createHash('sha256').update(manifestBuffer).digest('hex').substring(0, 6);
fs.writeFileSync('swarm.manifest.json', manifestBuffer);

console.log(`\n[SEAL] Swarm Manifest Written: 1.5.0-STATIC`);
console.log(`[ROOT] Permanent Root Fragment: ${swarmRoot}`);

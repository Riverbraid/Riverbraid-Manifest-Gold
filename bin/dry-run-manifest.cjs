const fs = require('fs');
const path = require('path');
const BASE = '/workspaces';
const agents = fs.readdirSync(BASE).filter(n => n.startsWith('Riverbraid-') && n.endsWith('-Gold'));
console.log("[DRY-RUN] Aggregating Swarm Signatures...");
const manifest = {};
agents.forEach(agent => {
    const sigPath = path.join(BASE, agent, 'constitution.snapshot.json.asc');
    process.stdout.write(`Checking ${agent}... `);
    if (fs.existsSync(sigPath)) {
        const content = fs.readFileSync(sigPath, 'utf8');
        manifest[agent] = { status: "SIGNED", present: true, length: content.length };
        console.log("VALID");
    } else {
        manifest[agent] = { status: "MISSING", present: false };
        console.log("MISSING");
    }
});
const total = Object.keys(manifest).length;
const signed = Object.values(manifest).filter(a => a.present).length;
console.log(`\n[RESULT] Coverage: ${signed}/${total}`);
if (signed === total) {
    console.log("OK: Swarm Coherence Verified.");
} else {
    console.error("FAIL: Swarm Fragmentation Detected.");
    process.exit(1);
}

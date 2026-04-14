const fs = require('fs');

function canonicalize(obj) {
  if (Array.isArray(obj)) return obj.map(canonicalize);
  if (obj !== null && typeof obj === 'object') {
    return Object.keys(obj).sort().reduce((acc, key) => {
      acc[key] = canonicalize(obj[key]);
      return acc;
    }, {});
  }
  return obj;
}

const filePath = process.argv[2];
if (!filePath) process.exit(1);

const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
console.log(JSON.stringify(canonicalize(data), null, 2));

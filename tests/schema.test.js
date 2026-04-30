const fs = require('fs');
const Ajv = require('ajv');
const ajv = new Ajv();

describe('Phase 2: Schema Enforcement', () => {
  test('Manifest matches Constellation Schema', () => {
    const schema = JSON.parse(fs.readFileSync('./schemas/riverbraid.constellation.schema.json', 'utf8'));
    const data = JSON.parse(fs.readFileSync('./riverbraid.constellation.json', 'utf8'));
    const validate = ajv.compile(schema);
    const valid = validate(data);
    if (!valid) console.log(validate.errors);
    expect(valid).toBe(true);
  });
});

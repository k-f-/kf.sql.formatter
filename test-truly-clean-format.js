const fs = require('fs');
const path = require('path');

// Load the formatter
const formatterPath = path.join(__dirname, 'dist', 'formatter.js');
const { formatSQL } = require(formatterPath);

const inputFile = 'test-truly-clean.sql';
const sql = fs.readFileSync(inputFile, 'utf8');

console.log('=== ORIGINAL SQL ===');
console.log(sql);
console.log('\n=== FORMATTING (1st pass) ===');

const formatted1 = formatSQL(sql);
console.log(formatted1);

console.log('\n=== FORMATTING (2nd pass - testing idempotence) ===');
const formatted2 = formatSQL(formatted1);
console.log(formatted2);

console.log('\n=== COMPARISON ===');
if (formatted1 === formatted2) {
  console.log('✅ IDEMPOTENT: First and second format are identical');
} else {
  console.log('❌ NOT IDEMPOTENT: Formatting changed on second pass');
  console.log('\nDifferences:');
  const lines1 = formatted1.split('\n');
  const lines2 = formatted2.split('\n');
  const maxLines = Math.max(lines1.length, lines2.length);
  for (let i = 0; i < maxLines; i++) {
    if (lines1[i] !== lines2[i]) {
      console.log(`Line ${i + 1}:`);
      console.log(`  1st: "${lines1[i] || '(missing)'}"`);
      console.log(`  2nd: "${lines2[i] || '(missing)'}"`);
    }
  }
}

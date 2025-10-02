const fs = require('fs');
const path = require('path');

// Load the formatter
const formatterPath = path.join(__dirname, 'dist', 'formatter.js');
const { formatSql } = require(formatterPath);

const examplesDir = path.join(__dirname, 'examples');
const exampleFiles = [
  '01-basic-queries.sql',
  '02-ctes-subqueries.sql',
  '03-joins.sql',
  '04-expressions.sql',
  '05-spark-specific.sql',
  '06-dml-ddl.sql',
  '07-comments-strings.sql',
  '08-edge-cases.sql'
];

let totalTests = 0;
let passedTests = 0;
let idempotentTests = 0;

console.log('='.repeat(80));
console.log('TESTING FORMATTER WITH CLEAN EXAMPLES');
console.log('='.repeat(80));

exampleFiles.forEach(filename => {
  const filePath = path.join(examplesDir, filename);

  if (!fs.existsSync(filePath)) {
    console.log(`\n❌ SKIP: ${filename} - File not found`);
    return;
  }

  totalTests++;
  const sql = fs.readFileSync(filePath, 'utf8');

  console.log(`\n📄 ${filename}`);
  console.log('-'.repeat(80));

  try {
    // First format
    const formatted1 = formatSql(sql);
    console.log('✅ First format: SUCCESS');

    // Second format (idempotence test)
    const formatted2 = formatSql(formatted1);
    console.log('✅ Second format: SUCCESS');

    // Check idempotence
    if (formatted1 === formatted2) {
      console.log('✅ IDEMPOTENT: Formatting is stable');
      idempotentTests++;
      passedTests++;
    } else {
      console.log('❌ NOT IDEMPOTENT: Formatting differs on second pass');

      // Show first few differences
      const lines1 = formatted1.split('\n');
      const lines2 = formatted2.split('\n');
      const maxLines = Math.max(lines1.length, lines2.length);
      let diffCount = 0;

      console.log('\nFirst 5 differences:');
      for (let i = 0; i < maxLines && diffCount < 5; i++) {
        if (lines1[i] !== lines2[i]) {
          diffCount++;
          console.log(`  Line ${i + 1}:`);
          console.log(`    1st: "${lines1[i] || '(missing)'}"`);
          console.log(`    2nd: "${lines2[i] || '(missing)'}"`);
        }
      }
    }

  } catch (error) {
    console.log(`❌ FAILED: ${error.message}`);
  }
});

console.log('\n' + '='.repeat(80));
console.log('SUMMARY');
console.log('='.repeat(80));
console.log(`Total files tested: ${totalTests}`);
console.log(`Successful formats: ${passedTests}`);
console.log(`Idempotent: ${idempotentTests}`);
console.log(`Non-idempotent: ${passedTests - idempotentTests}`);
console.log('='.repeat(80));

if (idempotentTests === totalTests && totalTests > 0) {
  console.log('\n🎉 ALL TESTS PASSED! Formatter is working correctly!');
  process.exit(0);
} else {
  console.log('\n⚠️  Some tests failed or are not idempotent');
  process.exit(1);
}

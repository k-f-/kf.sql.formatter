#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const { formatDocument } = require('./dist/formatter');

const opts = {
  keywordCase: 'upper',
  functionCase: 'lower',
  indent: 2,
  leadingCommas: true,
  dialect: 'spark',
  aliasAlignmentScope: 'file',
  aliasMinGap: 2,
  aliasMaxColumnCap: 80,
  forceAsForAliases: 'existingOnly',
  joinInlineSingle: true,
  joinInlineMaxWidth: 100,
  usingMultiLineThreshold: 3,
  semicolonStyle: 'leading-when-multi',
  semicolonSkipComments: false,
  trimTrailingWhitespace: true,
  commentWrapColumn: 100
};

const testCasesDir = path.join(__dirname, 'test-cases');
const outputDir = path.join(__dirname, 'test-cases', 'formatted');

// Create output directory
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

console.log('================================================================================');
console.log('SQL FORMATTER TEST SUITE');
console.log('================================================================================\n');

const testFiles = [
  '01-simple-selects.sql',
  '02-joins.sql',
  '03-ctes-subqueries.sql',
  '04-complex-expressions.sql',
  '05-dml-operations.sql',
  '06-spark-specific.sql',
  '07-comments-strings.sql',
  '08-edge-cases.sql'
];

const results = {
  totalFiles: 0,
  successful: 0,
  failed: 0,
  idempotent: 0,
  nonIdempotent: 0,
  details: []
};

testFiles.forEach(filename => {
  const inputPath = path.join(testCasesDir, filename);

  if (!fs.existsSync(inputPath)) {
    console.log(`⚠️  SKIPPED: ${filename} (file not found)`);
    return;
  }

  results.totalFiles++;

  console.log(`\n${'='.repeat(80)}`);
  console.log(`Testing: ${filename}`);
  console.log('='.repeat(80));

  try {
    // Read input
    const input = fs.readFileSync(inputPath, 'utf8');
    const inputLines = input.split('\n').length;

    // Format once
    const formatted = formatDocument(input, opts);
    const formattedLines = formatted.split('\n').length;

    // Format twice (idempotence test)
    const formatted2 = formatDocument(formatted, opts);
    const isIdempotent = formatted === formatted2;

    // Save formatted output
    const outputPath = path.join(outputDir, filename);
    fs.writeFileSync(outputPath, formatted, 'utf8');

    // Update results
    results.successful++;
    if (isIdempotent) {
      results.idempotent++;
    } else {
      results.nonIdempotent++;
    }

    // Summary for this file
    console.log(`✅ SUCCESS`);
    console.log(`   Input lines:     ${inputLines}`);
    console.log(`   Formatted lines: ${formattedLines}`);
    console.log(`   Idempotent:      ${isIdempotent ? '✅ YES' : '❌ NO'}`);
    console.log(`   Output:          ${outputPath}`);

    if (!isIdempotent) {
      console.log(`\n   ⚠️  WARNING: Not idempotent! First 5 differences:`);
      const lines1 = formatted.split('\n');
      const lines2 = formatted2.split('\n');
      let diffCount = 0;
      for (let i = 0; i < Math.max(lines1.length, lines2.length) && diffCount < 5; i++) {
        if (lines1[i] !== lines2[i]) {
          console.log(`   Line ${i + 1}:`);
          console.log(`     1st: ${JSON.stringify(lines1[i] || '(empty)')}`);
          console.log(`     2nd: ${JSON.stringify(lines2[i] || '(empty)')}`);
          diffCount++;
        }
      }
    }

    results.details.push({
      filename,
      success: true,
      inputLines,
      formattedLines,
      idempotent: isIdempotent
    });

  } catch (error) {
    results.failed++;
    console.log(`❌ FAILED: ${error.message}`);
    console.log(`   Error: ${error.stack}`);

    results.details.push({
      filename,
      success: false,
      error: error.message
    });
  }
});

// Final summary
console.log('\n\n' + '='.repeat(80));
console.log('FINAL SUMMARY');
console.log('='.repeat(80));
console.log(`Total files:       ${results.totalFiles}`);
console.log(`Successful:        ${results.successful} ✅`);
console.log(`Failed:            ${results.failed} ${results.failed > 0 ? '❌' : ''}`);
console.log(`Idempotent:        ${results.idempotent} ✅`);
console.log(`Non-idempotent:    ${results.nonIdempotent} ${results.nonIdempotent > 0 ? '⚠️' : ''}`);

if (results.successful === results.totalFiles && results.idempotent === results.totalFiles) {
  console.log('\n🎉 ALL TESTS PASSED! Formatter is working correctly.');
} else if (results.failed > 0) {
  console.log('\n⚠️  Some tests failed. Please review the errors above.');
} else if (results.nonIdempotent > 0) {
  console.log('\n⚠️  All tests passed but some are not idempotent.');
}

// Save results to JSON
const resultsPath = path.join(__dirname, 'test-results.json');
fs.writeFileSync(resultsPath, JSON.stringify(results, null, 2), 'utf8');
console.log(`\n📊 Detailed results saved to: ${resultsPath}`);

console.log('\n' + '='.repeat(80));
process.exit(results.failed > 0 ? 1 : 0);

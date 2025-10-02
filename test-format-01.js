#!/usr/bin/env node
const fs = require('fs');
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

const filePath = 'examples/01-test-input.sql';
const content = fs.readFileSync(filePath, 'utf8');

console.log('================================================================================');
console.log('TEST: Formatting 01-test-input.sql (Clean Test Cases)');
console.log('================================================================================\n');

const formatted = formatDocument(content, opts);

console.log('=== FORMATTED OUTPUT ===\n');
console.log(formatted);

// Test idempotence
const formatted2 = formatDocument(formatted, opts);
const isIdempotent = formatted === formatted2;

console.log('\n================================================================================');
console.log('SUMMARY');
console.log('================================================================================');
console.log(`Original lines: ${content.split('\n').length}`);
console.log(`Formatted lines: ${formatted.split('\n').length}`);
console.log(`Idempotence: ${isIdempotent ? '✅ PASS' : '❌ FAIL'}`);

if (!isIdempotent) {
  console.log('\n⚠️  WARNING: Formatting is not idempotent!');
  console.log('\nFirst 10 differences:');
  const lines1 = formatted.split('\n');
  const lines2 = formatted2.split('\n');
  let diffCount = 0;
  for (let i = 0; i < Math.max(lines1.length, lines2.length) && diffCount < 10; i++) {
    if (lines1[i] !== lines2[i]) {
      console.log(`\nLine ${i + 1}:`);
      console.log(`  1st: ${JSON.stringify(lines1[i])}`);
      console.log(`  2nd: ${JSON.stringify(lines2[i])}`);
      diffCount++;
    }
  }
}

// Save formatted output
const outputPath = 'examples/01-test-input-FORMATTED.sql';
fs.writeFileSync(outputPath, formatted, 'utf8');
console.log(`\n✅ Output written to: ${outputPath}`);

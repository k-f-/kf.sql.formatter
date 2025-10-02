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

// Read the file from main branch (original)
const filePath = 'examples/01-basic-queries.sql';
const content = fs.readFileSync(filePath, 'utf8');

console.log('================================================================================');
console.log('FORMATTING: 01-basic-queries.sql');
console.log('================================================================================\n');

const formatted = formatDocument(content, opts);

console.log('=== FORMATTED OUTPUT (first 100 lines) ===\n');
const lines = formatted.split('\n');
console.log(lines.slice(0, 100).join('\n'));

console.log('\n\n=== SUMMARY ===');
console.log(`Original lines: ${content.split('\n').length}`);
console.log(`Formatted lines: ${lines.length}`);

// Test idempotence
const formatted2 = formatDocument(formatted, opts);
const isIdempotent = formatted === formatted2;
console.log(`Idempotence: ${isIdempotent ? '✅ PASS' : '❌ FAIL'}`);

if (!isIdempotent) {
  console.log('\n⚠️  WARNING: Formatting is not idempotent!');
  console.log('Differences on second format:');
  const lines1 = formatted.split('\n');
  const lines2 = formatted2.split('\n');
  for (let i = 0; i < Math.max(lines1.length, lines2.length); i++) {
    if (lines1[i] !== lines2[i]) {
      console.log(`Line ${i + 1}:`);
      console.log(`  First:  ${JSON.stringify(lines1[i])}`);
      console.log(`  Second: ${JSON.stringify(lines2[i])}`);
    }
  }
}

// Write formatted version to a temp file for inspection
const outputPath = 'examples/01-basic-queries-FORMATTED.sql';
fs.writeFileSync(outputPath, formatted, 'utf8');
console.log(`\n✅ Formatted file written to: ${outputPath}`);
console.log('   Review this file in Extension Development Host to validate formatting');

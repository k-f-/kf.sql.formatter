#!/usr/bin/env node

/**
 * Test script to format all example SQL files and display results
 * Usage: node scripts/test-examples.js [file-number]
 * Example: node scripts/test-examples.js 01  (formats only 01-basic-queries.sql)
 */

const fs = require('fs');
const path = require('path');

// Import the formatter (after compilation)
const { formatDocument } = require('../dist/formatter');

// Default formatter options (matching extension defaults)
const defaultOptions = {
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

const examplesDir = path.join(__dirname, '../examples');
const fileFilter = process.argv[2]; // Optional: filter by file number (e.g., '01')

// Get all SQL files
const files = fs.readdirSync(examplesDir)
  .filter(f => f.endsWith('.sql') && f !== 'test.sql')
  .filter(f => !fileFilter || f.startsWith(fileFilter))
  .sort();

console.log('='.repeat(80));
console.log('FORMATTING EXAMPLE SQL FILES');
console.log('='.repeat(80));
console.log();

files.forEach(file => {
  const filePath = path.join(examplesDir, file);
  const content = fs.readFileSync(filePath, 'utf8');

  console.log(`\n${'='.repeat(80)}`);
  console.log(`FILE: ${file}`);
  console.log('='.repeat(80));

  try {
    const formatted = formatDocument(content, defaultOptions);

    // Show formatted output
    console.log(formatted);

    // Check idempotence
    const formatted2 = formatDocument(formatted, defaultOptions);
    const isIdempotent = formatted === formatted2;

    console.log('\n' + '-'.repeat(80));
    console.log(`✓ Formatted successfully`);
    console.log(`${isIdempotent ? '✓' : '✗'} Idempotence: ${isIdempotent ? 'PASS' : 'FAIL'}`);

    if (!isIdempotent) {
      console.log('\n⚠️  WARNING: Formatting is not idempotent!');
      console.log('Second format differs from first.');
    }

  } catch (err) {
    console.log('\n❌ ERROR during formatting:');
    console.log(err.message);
    console.log(err.stack);
  }

  console.log('='.repeat(80));
});

console.log('\n✅ All files processed');

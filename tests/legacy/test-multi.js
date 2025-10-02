#!/usr/bin/env node
const { formatDocument } = require('./dist/formatter');

const opts = {
  keywordCase: 'upper',
  functionCase: 'lower',
  indent: 2,
  leadingCommas: true,
  dialect: 'spark',
  aliasAlignmentScope: 'file',
  semicolonStyle: 'leading-when-multi',
  trimTrailingWhitespace: true
};

const sql = `-- Test 1
SELECT id, name FROM users WHERE status = 'active';

-- Test 2
SELECT email FROM users WHERE country = 'US';`;

console.log('=== INPUT ===');
console.log(sql);
console.log('\n=== OUTPUT ===');
const result = formatDocument(sql, opts);
console.log(result);
console.log('\n=== LINE BY LINE ===');
result.split('\n').forEach((line, i) => console.log(`${i+1}: ${JSON.stringify(line)}`));

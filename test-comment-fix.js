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

// Test 1: Comment with SQL keywords
const test1 = `-- This comment mentions SELECT and FROM keywords
SELECT user_id, name, email
FROM users
WHERE status = 'active';`;

console.log('=== TEST 1: Comment with SQL Keywords ===');
console.log('\nINPUT:');
console.log(test1);
console.log('\nOUTPUT:');
const result1 = formatDocument(test1, opts);
console.log(result1);

// Test idempotence
const result1_2 = formatDocument(result1, opts);
console.log('\nIDEMPOTENCE:', result1 === result1_2 ? '✅ PASS' : '❌ FAIL');

if (result1 !== result1_2) {
  console.log('\nDifferences:');
  const lines1 = result1.split('\n');
  const lines2 = result1_2.split('\n');
  for (let i = 0; i < Math.max(lines1.length, lines2.length); i++) {
    if (lines1[i] !== lines2[i]) {
      console.log(`Line ${i+1}:`);
      console.log(`  1st: ${JSON.stringify(lines1[i])}`);
      console.log(`  2nd: ${JSON.stringify(lines2[i])}`);
    }
  }
}

// Test 2: Multiple statements with comments
const test2 = `-- First query: Get active users
SELECT id, name FROM users WHERE status = 'active';

-- Second query: Get recent orders
SELECT order_id, customer_id FROM orders WHERE order_date >= '2024-01-01';`;

console.log('\n\n=== TEST 2: Multiple Statements with Comments ===');
console.log('\nINPUT:');
console.log(test2);
console.log('\nOUTPUT:');
const result2 = formatDocument(test2, opts);
console.log(result2);

const result2_2 = formatDocument(result2, opts);
console.log('\nIDEMPOTENCE:', result2 === result2_2 ? '✅ PASS' : '❌ FAIL');

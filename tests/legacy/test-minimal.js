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

const sql = `-- Simple test
SELECT id, name FROM users WHERE status = 'active';`;

console.log('=== INPUT ===');
console.log(sql);
console.log('\n=== OUTPUT ===');
console.log(formatDocument(sql, opts));

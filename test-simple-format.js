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

// Test 1: Simple query (may be kept on one line due to length)
const sql1 = `
SELECT id, name, email
FROM users
WHERE status = 'active'
`;

console.log('=== TEST 1: SIMPLE (may collapse) ===');
console.log(formatDocument(sql1, opts));

// Test 2: Query with alias (should format with leading commas)
const sql2 = `
SELECT id, name, email as user_email
FROM users
WHERE status = 'active'
`;

console.log('\n=== TEST 2: WITH ALIAS (should format) ===');
console.log(formatDocument(sql2, opts));

// Test 3: Multiple columns with aliases
const sql3 = `
SELECT
  user_id,
  first_name,
  last_name,
  email as user_email,
  created_at as registration_date
FROM customers
WHERE country = 'US'
ORDER BY created_at DESC
`;

console.log('\n=== TEST 3: MULTIPLE COLUMNS (full formatting) ===');
console.log(formatDocument(sql3, opts));

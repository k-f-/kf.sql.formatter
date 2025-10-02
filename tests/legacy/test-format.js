const { formatDocument } = require('./dist/formatter');
const fs = require('fs');

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

const content = fs.readFileSync('examples/01-basic-queries.sql', 'utf8');
const formatted = formatDocument(content, opts);

console.log(formatted);

import { normalizeKeywordCase, splitStatementsCTESafe } from './utils';
import { clauseStructurePass } from './passes/01-clause-structure';
import { leadingCommasPass } from './passes/02-leading-commas';
import { breakersPass } from './passes/03-breakers';
import { namedStructAlignPass } from './passes/04-namedstruct-align';
import { aliasAlignPass, computeGlobalColumns } from './passes/05-alias-align';
import { joinWhereAlignPass } from './passes/06-join-where-align';
import { groupOrderAlignPass } from './passes/07-group-order-align';
import { updateSetAlignPass } from './passes/08-update-set-align';
import { semicolonsPass } from './passes/09-semicolons';
import { trailingWhitespacePass } from './passes/10-trailing-ws';
import { commentWrapPass } from './passes/11-comment-wrap';

export interface FormatterOptions {
  keywordCase: 'lower' | 'upper' | 'preserve';
  functionCase: 'lower' | 'upper' | 'preserve';
  indent: number;
  leadingCommas: boolean;
  dialect: 'spark' | 'hive' | 'ansi';
  aliasAlignmentScope: 'file' | 'select' | 'none';
  aliasMinGap: number;
  aliasMaxColumnCap: number;
  forceAsForAliases: 'existingOnly' | 'off';
  joinInlineSingle: boolean;
  joinInlineMaxWidth: number;
  usingMultiLineThreshold: number;
  semicolonStyle: 'leading-when-multi';
  semicolonSkipComments: boolean;
  trimTrailingWhitespace: boolean;
  commentWrapColumn: number;
}

export function formatDocument(text: string, opts: FormatterOptions): string {
  // Ensure leading commas is always enabled
  const enforceOpts = {
    ...opts,
    leadingCommas: true
  };

  // 0) Case normalization for keywords/functions (non-invasive)
  let t = normalizeKeywordCase(text, enforceOpts.keywordCase, enforceOpts.functionCase);

  // 1) Split into statements (CTE safe: DO NOT split between with...select/insert/update/delete/merge)
  const stmts = splitStatementsCTESafe(t);

  // 2) Format each statement independently, then rejoin (semicolon handling later)
  const formattedStatements = stmts.map((stmt) => {
    let s = stmt;
    s = clauseStructurePass(s, enforceOpts);      // Clause structure with keyword casing
    s = leadingCommasPass(s, enforceOpts);        // Leading commas (no space after comma)
    s = breakersPass(s, enforceOpts);             // CASE/OVER/long functions
    s = namedStructAlignPass(s, enforceOpts);     // named_struct alignment
    s = aliasAlignPass(s, enforceOpts);           // File-wide alias alignment at column 80+
    s = joinWhereAlignPass(s, enforceOpts);       // Align comments in join/where
    s = groupOrderAlignPass(s, enforceOpts);      // Align comments in group/order
    s = updateSetAlignPass(s, enforceOpts);       // Align '=' in update set
    s = trailingWhitespacePass(s, enforceOpts);   // Trim trailing whitespace
    return s;
  });

  // 3) Rejoin and apply semicolon policy across statements
  let joined = formattedStatements.join('\n');
  joined = semicolonsPass(joined, enforceOpts);        // Inline semicolons with following statement

  // 4) Apply alias alignment again for global consistency
  joined = aliasAlignPass(joined, enforceOpts);

  // 5) Wrap long comments last (to avoid breaking alignment calc)
  const finalText = commentWrapPass(joined, enforceOpts);

  return finalText;
}

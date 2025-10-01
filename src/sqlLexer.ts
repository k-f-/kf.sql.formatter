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
  // 0) Case normalization for keywords/functions (non-invasive)
  let t = normalizeKeywordCase(text, opts.keywordCase, opts.functionCase);

  // 1) Split into statements (CTE safe: DO NOT split between with...select/insert/update/delete/merge)
  const stmts = splitStatementsCTESafe(t);

  // 2) Format each statement independently, then rejoin (semicolon handling later)
  const formattedStatements = stmts.map((stmt) => {
    let s = stmt;
    s = clauseStructurePass(s, opts);
    s = leadingCommasPass(s, opts);
    s = breakersPass(s, opts);              // CASE/OVER/long functions + USING threshold
    s = namedStructAlignPass(s, opts);
    s = aliasAlignPass(s, opts);            // enforce 'as' for existing aliases, compute alias col
    s = joinWhereAlignPass(s, opts);        // align comments in join/where
    s = groupOrderAlignPass(s, opts);       // align comments in group/order
    s = updateSetAlignPass(s, opts);        // align '=' in update set
    s = trailingWhitespacePass(s, opts);    // trim trailing ws
    return s;
  });

  // 3) Rejoin and apply semicolon policy across statements
  let joined = formattedStatements.join('\n');
  joined = semicolonsPass(joined, opts);        // leading-when-multi + W-Lead + CTE safety

  // 4) Global alias/comment columns (requires whole file)
  const withGlobalCols = computeGlobalColumns(joined, opts);

  // 5) Wrap long comments last (to avoid breaking alignment calc)
  const finalText = commentWrapPass(withGlobalCols, opts);

  return finalText;
}

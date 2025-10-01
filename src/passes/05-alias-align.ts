import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

// Heuristics: detect ' as alias' for SELECT items and FROM/JOIN sources.
// Align 'as' to global column, and align inline comments to global comment column.

export function aliasAlignPass(text: string, opts: FormatterOptions): string {
  // We do a first pass to ensure 'as' exists when alias already present (existingOnly).
  // Then we align to per-statement columns; global columns are finalized later.
  const ls = lines(text);
  const out: string[] = [];

  const AS_RE = /\s+as\s+([A-Za-z0-9_`"\[\]]+)$/i;
  const ALIAS_TAIL_RE = /\s+([A-Za-z0-9_`"\[\]]+)\s*(--.*)?$/;

  for (let raw of ls) {
    let line = raw;

    // Only normalize 'as' when an alias is already present without 'as'
    // SELECT items: look for trailing alias token (but avoid comments)
    const commentIdx = line.indexOf('--');
    const code = commentIdx >= 0 ? line.slice(0, commentIdx) : line;
    const comment = commentIdx >= 0 ? line.slice(commentIdx) : '';

    // If code likely has ' expr alias' and no ' as ' already, inject ' as '
    if (!/^\s*(select|from|join|where|group|order|update|merge|with|;)/i.test(code)) {
      if (!/\sas\s/i.test(code)) {
        // trailing simple alias?
        const m = code.match(ALIAS_TAIL_RE);
        if (m && mayBeAliasContext(code)) {
          const alias = m[1];
          const expr = code.slice(0, code.lastIndexOf(alias)).trimEnd();
          line = `${expr} as ${alias}${comment ? ' ' + comment : ''}`;
        }
      }
    }

    out.push(line);
  }

  return rejoin(out);
}

function mayBeAliasContext(code: string): boolean {
  // Heuristic: for SELECT item or FROM/JOIN source line, if last token isn't keyword or operator
  // Avoid adding for 't.*', '*', or lines that end with ')' without alias.
  if (/\*\s*$/.test(code)) return false;
  if (/\)\s*$/.test(code) && !/\)\s+[A-Za-z0-9_`"]+$/.test(code)) return false;
  return true;
}

// Final global column computation and realignment for both 'as' and comments.
export function computeGlobalColumns(text: string, opts: FormatterOptions): string {
  const ls = lines(text);

  // Discover alias start columns and comment start columns
  let maxExprEndPlusGap = 0;
  const aliasMinGap = Math.max(0, opts.aliasMinGap || 8);
  const cap = Math.max(aliasMinGap + 8, opts.aliasMaxColumnCap || 120);

  interface LineParts { code: string; comment: string; }
  const split = (line: string): LineParts => {
    const i = line.indexOf('--');
    return i >= 0 ? { code: line.slice(0, i), comment: line.slice(i) } : { code: line, comment: '' };
  };

  // Measure expr end as position where ' as ' begins or where code ends
  const measures = ls.map((line) => {
    const { code } = split(line);
    const idx = code.toLowerCase().lastIndexOf(' as ');
    const exprEnd = idx >= 0 ? idx : code.length;
    return exprEnd;
  });

  for (const exprEnd of measures) {
    maxExprEndPlusGap = Math.max(maxExprEndPlusGap, exprEnd + aliasMinGap);
  }
  const aliasCol = Math.min(maxExprEndPlusGap, cap);

  // Comments: global column after considering alias column + a couple spaces
  let maxForComments = aliasCol + 2;
  for (const line of ls) {
    const i = line.indexOf('--');
    if (i >= 0) {
      maxForComments = Math.max(maxForComments, i);
    }
  }
  const commentCol = Math.min(Math.max(maxForComments, aliasCol + 2), Math.max(cap, aliasCol + 20));

  // Realign pass
  const out: string[] = [];
  for (const raw of ls) {
    let { code, comment } = split(raw);
    let rebuilt = raw;

    // Align ' as ' if present
    const asIdx = code.toLowerCase().lastIndexOf(' as ');
    if (asIdx >= 0) {
      const before = code.slice(0, asIdx).rstrip();
      const after = code.slice(asIdx + 4).lstrip(); // alias
      const pad = Math.max(0, aliasCol - before.length);
      const left = before + ' '.repeat(pad) + 'as ' + after;
      rebuilt = left;
    } else {
      // no 'as'; keep code as-is
      rebuilt = code.rstrip();
    }

    // Align inline comment to commentCol
    if (comment) {
      const padForComment = Math.max(2, commentCol - rebuilt.length);
      rebuilt = rebuilt + ' '.repeat(padForComment) + comment.trimStart();
    }

    out.push(rebuilt);
  }

  return out.join('\n');
}

// small helpers
declare global { interface String { lstrip(): string; rstrip(): string; } }
if (!String.prototype.lstrip) {
  // @ts-ignore
  String.prototype.lstrip = function () { return this.replace(/^\s+/, ''); };
}
if (!String.prototype.rstrip) {
  // @ts-ignore
  String.prototype.rstrip = function () { return this.replace(/\s+$/, ''); };
}

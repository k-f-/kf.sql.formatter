import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

// This pass ensures all aliases are aligned to a consistent column across the file
export function aliasAlignPass(text: string, opts: FormatterOptions): string {
  const ls = lines(text);
  const out: string[] = [];

  const aliasLines = ls.filter(line => /\sas\s/i.test(line));
  const aliasPositions = aliasLines.map(line => line.indexOf(' as '));
  const maxAliasPos = Math.min(
    Math.max(...aliasPositions.map(pos => pos + opts.aliasMinGap)),
    opts.aliasMaxColumnCap
  );

  for (const line of ls) {
    const aliasMatch = line.match(/^(.*?)(\s+as\s+)(\S+)(.*)$/i);
    if (aliasMatch) {
      const [_, expr, asPart, alias, rest] = aliasMatch;
      const paddedExpr = expr.trimEnd().padEnd(maxAliasPos - asPart.length);
      const rebuilt = `${paddedExpr}${asPart}${alias}${rest}`;
      out.push(rebuilt);
    } else {
      out.push(line);
    }
  }

  return rejoin(out);
}

// This pass also computes global alignment for comments after alias alignment
export function computeGlobalColumns(text: string, opts: FormatterOptions): string {
  const ls = lines(text);
  const out: string[] = [];

  let maxCodeLength = 0;
  for (const line of ls) {
    const code = line.split('--')[0].trimEnd();
    maxCodeLength = Math.max(maxCodeLength, code.length);
  }

  for (const line of ls) {
    const [code, comment] = line.split('--');
    const paddedCode = code.trimEnd().padEnd(maxCodeLength + 2);
    if (comment !== undefined) {
      out.push(`${paddedCode}-- ${comment.trim()}`);
    } else {
      out.push(code);
    }
  }

  return rejoin(out);
}

import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function joinWhereAlignPass(text: string, opts: FormatterOptions): string {
  const ls = lines(text);
  const out: string[] = [];

  let maxExprLength = 0;
  const exprLines: string[] = [];

  for (const line of ls) {
    if (/^\s*(and|or)?\s*[a-z_]+\s*=/.test(line)) {
      const code = line.split('--')[0].trimEnd();
      maxExprLength = Math.max(maxExprLength, code.length);
      exprLines.push(line);
    } else {
      out.push(line);
    }
  }

  for (const line of exprLines) {
    const [code, comment] = line.split('--');
    const padded = code.padEnd(maxExprLength + 2);
    out.push(comment ? `${padded}-- ${comment.trim()}` : padded);
  }

  return rejoin(out);
}

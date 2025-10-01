import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function groupOrderAlignPass(text: string, opts: FormatterOptions): string {
  const ls = lines(text);
  const out: string[] = [];

  let inGroup = false;
  let inOrder = false;
  let maxExprLength = 0;
  const groupLines: string[] = [];
  const orderLines: string[] = [];

  for (const line of ls) {
    if (/^\s*group by\b/i.test(line)) {
      inGroup = true;
      inOrder = false;
      out.push(line);
      continue;
    }
    if (/^\s*order by\b/i.test(line)) {
      inGroup = false;
      inOrder = true;
      out.push(line);
      continue;
    }
    if (/^\s*(where|select|from|update|insert|merge|with|;)/i.test(line)) {
      inGroup = false;
      inOrder = false;
      out.push(line);
      continue;
    }

    if (inGroup || inOrder) {
      const code = line.split('--')[0].trimEnd();
      maxExprLength = Math.max(maxExprLength, code.length);
      if (inGroup) groupLines.push(line);
      if (inOrder) orderLines.push(line);
    } else {
      out.push(line);
    }
  }

  const alignLines = (lines: string[]) => {
    return lines.map(line => {
      const [code, comment] = line.split('--');
      const padded = code.padEnd(maxExprLength + 2);
      return comment ? `${padded}-- ${comment.trim()}` : padded;
    });
  };

  out.push(...alignLines(groupLines));
  out.push(...alignLines(orderLines));

  return rejoin(out);
}

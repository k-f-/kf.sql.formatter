import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function updateSetAlignPass(text: string, _opts: FormatterOptions): string {
  const ls = lines(text);
  const out: string[] = [];

  let inUpdateSet = false;
  let block: string[] = [];

  const flush = () => {
    if (!block.length) return;
    const pairs = block.map((ln) => {
      const idx = ln.indexOf('=');
      if (idx < 0) return { lhs: ln, rhs: '', raw: ln, hasEq: false };
      return { lhs: ln.slice(0, idx).trimEnd(), rhs: ln.slice(idx + 1).trimStart(), raw: ln, hasEq: true };
    });
    const maxLHS = Math.max(...pairs.filter(p => p.hasEq).map(p => p.lhs.length), 0);
    const aligned = pairs.map(p => {
      if (!p.hasEq) return p.raw;
      const pad = Math.max(1, maxLHS - p.lhs.length);
      return `${p.lhs}${' '.repeat(pad)} = ${p.rhs}`;
    });
    out.push(...aligned);
    block = [];
  };

  for (const raw of ls) {
    const ln = raw;
    if (/^\s*when\s+matched\b.*then\s+update\s+set\b/i.test(ln) || /^\s*update\b/i.test(ln) && /\bset\b/i.test(ln)) {
      inUpdateSet = true;
      out.push(ln);
      continue;
    }
    if (inUpdateSet) {
      if (/^\s*(when\s+|insert\b|values\b|where\b|group\b|order\b|from\b|;|$)/i.test(ln)) {
        flush();
        inUpdateSet = false;
        out.push(ln);
      } else {
        block.push(ln);
      }
    } else {
      out.push(ln);
    }
  }
  flush();
  return rejoin(out);
}

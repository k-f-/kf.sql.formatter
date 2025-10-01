import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function leadingCommasPass(text: string, opts: FormatterOptions): string {
  if (!opts.leadingCommas) return text;
  const ls = lines(text);
  const out: string[] = [];

  let inSelect = false;
  for (let line of ls) {
    if (/^\s*select\b/i.test(line)) {
      inSelect = true;
      out.push(line);
      continue;
    }
    if (/^\s*(from|where|group|order|having|union|;|update|insert|merge|with)\b/i.test(line)) {
      inSelect = false;
      out.push(line);
      continue;
    }

    if (inSelect && /^\s*[^,]/.test(line)) {
      line = ',' + line.trimStart();
    }
    out.push(line);
  }

  return rejoin(out);
}

import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function trailingWhitespacePass(text: string, opts: FormatterOptions): string {
  if (!opts.trimTrailingWhitespace) return text;
  const ls = lines(text);
  const out = ls.map(line => line.replace(/\s+$/, ''));
  return rejoin(out);
}

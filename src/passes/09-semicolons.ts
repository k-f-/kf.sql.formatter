import { FormatterOptions } from '../formatter';
import { splitStatementsCTESafe } from '../utils';

export function semicolonsPass(text: string, opts: FormatterOptions): string {
  const stmts = splitStatementsCTESafe(text);

  if (stmts.length <= 1) {
    return stmts[0].replace(/;\s*$/m, '').trimEnd();
  }

  const normalized: string[] = [];
  for (let i = 0; i < stmts.length; i++) {
    let s = stmts[i].replace(/;\s*$/m, '').trimEnd();
    if (i === 0) {
      normalized.push(s);
    } else {
      const lines = s.split('\n');
      let emitted = false;
      for (let j = 0; j < lines.length; j++) {
        const ln = lines[j];
        if (!emitted && (!opts.semicolonSkipComments || !ln.trim().startsWith('--')) && ln.trim().length > 0) {
          lines[j] = ';' + ln.trimStart();
          emitted = true;
        }
      }
      normalized.push(lines.join('\n'));
    }
  }

  return normalized.join('\n');
}

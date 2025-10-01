import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function namedStructAlignPass(text: string, opts: FormatterOptions): string {
  const ls = lines(text);
  const out: string[] = [];

  let inStruct = false;
  let structLines: string[] = [];
  let maxKeyLength = 0;

  for (const line of ls) {
    if (/named_struct\s*\(/i.test(line)) {
      inStruct = true;
      structLines.push(line);
      continue;
    }

    if (inStruct) {
      if (/\)/.test(line)) {
        inStruct = false;
        structLines.push(line);

        // Align keys
        const aligned = structLines.map(l => {
          const match = l.match(/'([^']+)'\s*,\s*(.+)/);
          if (match) {
            const key = `'${match[1]}'`;
            const value = match[2].split('--')[0].trim();
            maxKeyLength = Math.max(maxKeyLength, key.length);
            const comment = l.includes('--') ? l.split('--')[1].trim() : '';
            return `${key.padEnd(maxKeyLength + 2)}, ${value}${comment ? '  -- ' + comment : ''}`;
          }
          return l;
        });

        out.push(...aligned);
        structLines = [];
      } else {
        structLines.push(line);
      }
    } else {
      out.push(line);
    }
  }

  return rejoin(out);
}

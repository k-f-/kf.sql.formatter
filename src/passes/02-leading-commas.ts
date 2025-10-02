import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function leadingCommasPass(text: string, opts: FormatterOptions): string {
  // Always enforce leading commas (no space after comma)
  const ls = lines(text);
  const out: string[] = [];

  for (let i = 0; i < ls.length; i++) {
    const line = ls[i];
    const nextLine = ls[i + 1];
    const trimmed = line.trim();

    // Check if this line ends with a comma
    if (trimmed.endsWith(',')) {
      // Remove trailing comma and any trailing whitespace
      const withoutComma = line.replace(/,\s*$/, '');
      out.push(withoutComma);

      // Add comma to the beginning of the next non-empty line
      if (nextLine && nextLine.trim()) {
        i++;
        const nextTrimmed = nextLine.trim();
        const leadingSpaces = nextLine.match(/^\s*/)?.[0] || '';
        // Ensure comma without space after it
        out.push(leadingSpaces + ',' + nextTrimmed);
      }
    } else {
      out.push(line);
    }
  }

  return rejoin(out);
}

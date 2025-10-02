import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function leadingCommasPass(text: string, opts: FormatterOptions): string {
  // Step 1: Split comma-separated items onto separate lines
  let result = text;

  // Split SELECT column lists: find lines that start with SELECT and have columns
  const ls = lines(result);
  const expanded: string[] = [];

  for (let i = 0; i < ls.length; i++) {
    const line = ls[i];
    const trimmed = line.trim();

    // Skip blank lines that come right after SELECT keyword
    if (trimmed === '' && i > 0 && /^(select|select\s+distinct)$/i.test(ls[i-1].trim())) {
      continue; // Skip this blank line
    }

    // Check if this line starts with SELECT/SELECT DISTINCT and has columns with commas
    const selectMatch = trimmed.match(/^(select|select\s+distinct)\s+(.+)$/i);
    if (selectMatch) {
      const keyword = selectMatch[1];
      const columnList = selectMatch[2];

      if (columnList.includes(',')) {
        // Split the columns
        const leadingSpaces = line.match(/^\s*/)?.[0] || '';
        const parts = columnList.split(',').map(p => p.trim()).filter(p => p);

        // Add SELECT on its own line
        expanded.push(leadingSpaces + keyword);

        // Add first column without comma (indented)
        if (parts.length > 0) {
          expanded.push(leadingSpaces + '  ' + parts[0]);
        }

        // Add remaining columns with leading commas (indented)
        for (let j = 1; j < parts.length; j++) {
          expanded.push(leadingSpaces + '  ,' + parts[j]);
        }
        continue;
      }
    }

    // Check if this is a line after SELECT that has commas (already split SELECT)
    if (i > 0 && /^(select|select\s+distinct)$/i.test(ls[i-1].trim())) {
      // This line comes right after SELECT - check if it has commas
      if (trimmed.includes(',') && !trimmed.startsWith('(')) {
        // Split on commas and create separate lines
        const leadingSpaces = line.match(/^\s*/)?.[0] || '  ';
        const parts = trimmed.split(',').map(p => p.trim()).filter(p => p);

        // Add first column without comma
        if (parts.length > 0) {
          expanded.push(leadingSpaces + parts[0]);
        }

        // Add remaining columns with leading commas
        for (let j = 1; j < parts.length; j++) {
          expanded.push(leadingSpaces + ',' + parts[j]);
        }
        continue;
      }
    }

    // For other lines, check if they contain commas in a list context
    // (not in function calls or CASE statements)
    if (trimmed.includes(',') && !trimmed.match(/\b(select|from|where|join|on|group by|order by|having|limit)\b/i)) {
      // Check if this looks like a comma-separated list (simple heuristic)
      const hasMultipleCommas = (trimmed.match(/,/g) || []).length > 1;
      if (hasMultipleCommas && !trimmed.includes('(')) {
        // Split this line too
        const leadingSpaces = line.match(/^\s*/)?.[0] || '  ';
        const parts = trimmed.split(',').map(p => p.trim()).filter(p => p);

        if (parts.length > 0) {
          expanded.push(leadingSpaces + parts[0]);
        }
        for (let j = 1; j < parts.length; j++) {
          expanded.push(leadingSpaces + ',' + parts[j]);
        }
        continue;
      }
    }

    expanded.push(line);
  }  // Step 2: Move trailing commas to leading commas (original logic)
  const out: string[] = [];

  for (let i = 0; i < expanded.length; i++) {
    const line = expanded[i];
    const nextLine = expanded[i + 1];
    const trimmed = line.trim();

    // Check if this line ends with a comma (and doesn't start with one)
    if (trimmed.endsWith(',') && !trimmed.startsWith(',')) {
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

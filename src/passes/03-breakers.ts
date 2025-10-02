
import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function breakersPass(text: string, opts: FormatterOptions): string {
  const ls = lines(text);
  const out: string[] = [];

  for (let line of ls) {
    // Break CASE statements - uppercase CASE, WHEN, THEN, ELSE; lowercase end
    if (/\bcase\b/i.test(line)) {
      // Replace CASE keywords with proper casing and line breaks
      line = line.replace(/\bcase\b/gi, 'CASE');
      line = line.replace(/\bwhen\b/gi, '\n         WHEN');
      line = line.replace(/\bthen\b/gi, 'THEN');
      line = line.replace(/\belse\b/gi, '\n         ELSE');
      line = line.replace(/\bend\b/gi, '\n       END');

      // Indent AND/OR within WHEN conditions
      line = line.replace(/\s+and\s+/gi, '\n              and ');
      line = line.replace(/\s+or\s+/gi, '\n              or ');
    }

    // Break complex OVER clauses (keep simple ones inline)
    const overMatch = line.match(/over\s*\(([^)]+)\)/i);
    if (overMatch) {
      const content = overMatch[1];
      // If content is complex (has ROWS/RANGE or multiple clauses), break it
      if (content.length > 60 || /\b(rows|range)\b/i.test(content)) {
        line = line.replace(/over\s*\(/i, 'over (\n       ');
        line = line.replace(/partition\s+by\s+/gi, 'partition by ');
        line = line.replace(/order\s+by\s+/gi, '\n       order by ');
        line = line.replace(/rows\s+between\s+/gi, '\n       rows between ');
        line = line.replace(/\)\s*$/i, '\n     )');
      }
    }

    // Handle array/struct access patterns
    if (/\[\d+\]/.test(line) || /\.\w+/.test(line)) {
      // Keep simple array/struct access inline unless too long
      if (line.length > opts.joinInlineMaxWidth) {
        line = line.replace(/(\.\w+|\[\d+\])\s*\./g, '$1\n    .');
      }
    }

    // Handle LATERAL VIEW explode
    if (/lateral\s+view\s+explode\s*\(/i.test(line)) {
      const explodeMatch = line.match(/explode\s*\(([^)]+)\)/i);
      if (explodeMatch && explodeMatch[1].length > 40) {
        line = line.replace(/explode\s*\(/i, 'explode(\n        ')
                   .replace(/\)\s*(\w+)/, '\n    ) $1');
      }
    }

    out.push(line);
  }

  return rejoin(out);
}

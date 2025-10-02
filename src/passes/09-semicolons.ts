import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function semicolonsPass(text: string, opts: FormatterOptions): string {
  const ls = lines(text);
  const out: string[] = [];

  // Tracking state
  let inCTE = false;
  let parenDepth = 0;
  let currentStatement: string[] = [];

  const flushStatement = (addSemicolon: boolean) => {
    if (currentStatement.length === 0) return;

    // Remove any existing semicolons from the statement
    const cleanedStatement = currentStatement.map(line =>
      line.replace(/;\s*$/, '')
    );

    out.push(...cleanedStatement);
    currentStatement = [];
  };

  for (let i = 0; i < ls.length; i++) {
    const line = ls[i];
    const trimmed = line.trim();
    const upper = trimmed.toUpperCase();

    // Track parentheses depth
    for (const char of line) {
      if (char === '(') parenDepth++;
      else if (char === ')') parenDepth--;
    }

    // Check for CTE start
    if (parenDepth === 0 && /^WITH\b/i.test(trimmed)) {
      if (currentStatement.length > 0) {
        flushStatement(true);
        // Add semicolon inline with WITH
        out[out.length - 1] = out[out.length - 1] + '\n;';
      }
      inCTE = true;
    }

    // Check for statement keywords that indicate a new statement
    const isNewStatement = parenDepth === 0 && !inCTE &&
      /^(SELECT|INSERT|UPDATE|DELETE|MERGE|CREATE|DROP|ALTER|TRUNCATE)\b/i.test(trimmed);

    if (isNewStatement && currentStatement.length > 0) {
      flushStatement(true);
      // Add semicolon on the last line
      out[out.length - 1] = out[out.length - 1] + '\n;';
    }

    // Add current line to statement
    currentStatement.push(line);

    // Check if we're ending a CTE (moving to main query)
    if (inCTE && parenDepth === 0 && /^(SELECT|INSERT|UPDATE|DELETE|MERGE)\b/i.test(trimmed)) {
      inCTE = false;
    }

    // Check for explicit semicolon
    if (trimmed.endsWith(';')) {
      flushStatement(false);
    }
  }

  // Flush any remaining statement
  if (currentStatement.length > 0) {
    flushStatement(false);
    // Add final semicolon
    out[out.length - 1] = out[out.length - 1] + '\n;';
  }

  return rejoin(out);
}

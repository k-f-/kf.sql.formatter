import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function semicolonsPass(text: string, opts: FormatterOptions): string {
  const ls = lines(text);
  const out: string[] = [];

  // Tracking state
  let inCTE = false;
  let parenDepth = 0;
  let currentStatement: string[] = [];
  let isFirstStatement = true; // Track if this is the first statement

  const flushStatement = (addLeadingSemicolon: boolean) => {
    if (currentStatement.length === 0) return;

    // Remove any existing semicolons from the statement
    const cleanedStatement = currentStatement.map(line =>
      line.replace(/;\s*$/, '')
    );

    // Add leading semicolon if requested and NOT the first statement
    if (addLeadingSemicolon && !isFirstStatement && out.length > 0) {
      out.push(';');
    }

    out.push(...cleanedStatement);
    currentStatement = [];
    isFirstStatement = false; // After first statement is flushed
  };

  for (let i = 0; i < ls.length; i++) {
    const line = ls[i];
    const trimmed = line.trim();

    // Skip empty lines and comments at the beginning (before first statement)
    if (isFirstStatement && currentStatement.length === 0 && (trimmed === '' || trimmed.startsWith('--'))) {
      out.push(line);
      continue;
    }

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
      }
      inCTE = true;
    }

    // Check for statement keywords that indicate a new statement
    const isNewStatement = parenDepth === 0 && !inCTE &&
      /^(SELECT|INSERT|UPDATE|DELETE|MERGE|CREATE|DROP|ALTER|TRUNCATE)\b/i.test(trimmed);

    if (isNewStatement && currentStatement.length > 0) {
      flushStatement(true);
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

  // Flush any remaining statement with trailing semicolon
  if (currentStatement.length > 0) {
    const cleanedStatement = currentStatement.map(line =>
      line.replace(/;\s*$/, '')
    );
    out.push(...cleanedStatement);

    // Add final trailing semicolon
    if (out.length > 0) {
      out[out.length - 1] = out[out.length - 1] + '\n;';
    }
  }

  return rejoin(out);
}

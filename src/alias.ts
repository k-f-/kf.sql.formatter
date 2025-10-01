// This file handles on-demand semantic aliasing for SQL expressions.

export function autoAliasEverything(text: string, opts: {
  aliasMinGap: number;
  aliasMaxColumnCap: number;
  commentWrapColumn: number;
}): string {
  const lines = text.split('\n');
  const output: string[] = [];
  let aliasCounter = 1;

  for (let line of lines) {
    if (/^\s*(select|,)/i.test(line) && !/\sas\s/i.test(line)) {
      const expr = line.trim().replace(/^,/, '').trim();
      const alias = generateSemanticAlias(expr, aliasCounter++);
      if (alias) {
        line = line.replace(expr, `${expr} as ${alias}`);
      }
    }
    output.push(line);
  }

  return output.join('\n');
}

function generateSemanticAlias(expr: string, counter: number): string {
  if (/^max\(/i.test(expr)) return `max_${extractArg(expr)}`;
  if (/^sum\(/i.test(expr)) return `sum_${extractArg(expr)}`;
  if (/^count\(/i.test(expr)) {
    if (/\*/.test(expr)) return 'count_all';
    return `count_${extractArg(expr)}`;
  }
  if (/^case\b/i.test(expr)) return `case_expr${counter}`;
  if (/^\w+\s*[\+\-\*\/]\s*\w+$/.test(expr)) return `expr${counter}`;
  return `expr${counter}`;
}

function extractArg(expr: string): string {
  const match = expr.match(/\(([^)]+)\)/);
  if (!match) return 'arg';
  return match[1].split(',')[0].trim().replace(/[^a-zA-Z0-9_]/g, '');
}


import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

export function breakersPass(text: string, opts: FormatterOptions): string {
  const ls = lines(text);
  const out: string[] = [];

  for (let line of ls) {
    // Break CASE blocks
    if (/case\s+when\s+/i.test(line)) {
      line = line.replace(/case\s+when\s+/i, 'case\n    when ');
      line = line.replace(/\s+then\s+/gi, '\n    then ');
      line = line.replace(/\s+else\s+/gi, '\n    else ');
      line = line.replace(/\s+end\b/gi, '\nend');
    }

    // Break OVER clauses
    if (/over\s*\(/i.test(line)) {
      line = line.replace(/over\s*\(/i, 'over (\n    ');
      line = line.replace(/\)\s*$/i, '\n)');
    }

    // Break long function calls
    const funcMatch = line.match(/([a-z_]+)\(([^)]+)\)/i);
    if (funcMatch && funcMatch[2].split(',').length > 3) {
      const args = funcMatch[2].split(',').map(arg => arg.trim());
      const brokenArgs = args.map(arg => `    ,${arg}`);
      line = `${funcMatch[1]}(\n${brokenArgs.join('\n')}\n)`;
    }

    out.push(line);
  }

  return rejoin(out);
}

// This file handles semicolon normalization across multi-statement SQL files.

export function normalizeSemicolons(text: string, opts: {
  style: 'leading-when-multi';
  skipCommentLines: boolean;
}): string {
  const lines = text.split('\n');
  const output: string[] = [];
  let statementCount = 0;
  let buffer: string[] = [];

  const flushBuffer = () => {
    if (buffer.length === 0) return;
    const statement = buffer.join('\n').trimEnd();
    if (statementCount === 0) {
      output.push(statement);
    } else {
      const firstLineIndex = buffer.findIndex(line =>
        !opts.skipCommentLines || !line.trim().startsWith('--')
      );
      if (firstLineIndex >= 0) {
        buffer[firstLineIndex] = ';' + buffer[firstLineIndex].trimStart();
      }
      output.push(buffer.join('\n'));
    }
    buffer = [];
    statementCount++;
  };

  for (const line of lines) {
    if (/^\s*;/.test(line)) {
      flushBuffer();
      buffer.push(line.replace(/^\s*;/, '').trimStart());
    } else {
      buffer.push(line);
    }
  }

  flushBuffer();
  return output.join('\n');
}

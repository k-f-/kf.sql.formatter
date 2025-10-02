import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

// Helper: Extract comments and replace with placeholders
function extractComments(text: string): { code: string; comments: Map<string, string> } {
  const comments = new Map<string, string>();
  let placeholderIndex = 0;

  // Extract line comments (-- ...)
  let code = text.replace(/--[^\n]*/g, (match) => {
    const placeholder = `__COMMENT_${placeholderIndex}__`;
    comments.set(placeholder, match);
    placeholderIndex++;
    return placeholder;
  });

  // Extract block comments (/* ... */)
  code = code.replace(/\/\*[\s\S]*?\*\//g, (match) => {
    const placeholder = `__COMMENT_${placeholderIndex}__`;
    comments.set(placeholder, match);
    placeholderIndex++;
    return placeholder;
  });

  return { code, comments };
}

// Helper: Restore comments from placeholders
function restoreComments(code: string, comments: Map<string, string>): string {
  let result = code;
  for (const [placeholder, comment] of comments.entries()) {
    result = result.replace(placeholder, comment);
  }
  return result;
}

// This pass ensures that major SQL clauses start on their own lines
export function clauseStructurePass(text: string, opts: FormatterOptions): string {
  // Check if statement is short enough to keep on one line (≤100 characters)
  const totalLength = text.replace(/\s+/g, ' ').trim().length;
  if (totalLength <= 100 && !text.includes(' as ')) {
    // Keep short statements without aliases on one line
    return text.replace(/\s+/g, ' ').trim();
  }

  // Extract comments before processing
  const { code, comments } = extractComments(text);

  const clauseKeywords = [
    'select', 'select distinct', 'from', 'where', 'group by', 'order by', 'having',
    'join', 'left join', 'right join', 'full join', 'inner join', 'outer join',
    'cross join', 'lateral view',
    'on', 'using', 'union', 'union all', 'insert into', 'update', 'delete',
    'merge', 'values', 'create', 'create or replace', 'truncate', 'with',
    'limit', 'fetch', 'distribute by', 'cluster by'
  ];

  let result = code;

  // Ensure SELECT and SELECT DISTINCT are always on their own line
  // But don't add extra newline after SELECT - columns should follow immediately
  result = result.replace(/\bselect\s+distinct\b/gi, '\nselect distinct ');
  result = result.replace(/\bselect\b/gi, '\nselect ');

  for (const keyword of clauseKeywords.sort((a, b) => b.length - a.length)) {
    const regex = new RegExp(`\\s+(${keyword.replace(/ /g, '\\s+')})\\b`, 'gi');
    result = result.replace(regex, '\n$1');
  }

  // Clean up multiple newlines - but allow max 1 blank line
  result = result.replace(/\n{3,}/g, '\n\n');

  // Remove blank lines between comments and the first statement
  result = result.replace(/(__COMMENT_\d+__\n)\n+(?=\s*select\b)/gi, '$1');

  // Apply proper keyword casing
  result = result.replace(/\bselect\b/gi, 'select');
  result = result.replace(/\bfrom\b/gi, 'from');
  result = result.replace(/\bwhere\b/gi, 'where');
  result = result.replace(/\bjoin\b/gi, 'join');
  result = result.replace(/\bleft\b/gi, 'left');
  result = result.replace(/\bright\b/gi, 'right');
  result = result.replace(/\binner\b/gi, 'inner');
  result = result.replace(/\bouter\b/gi, 'outer');
  result = result.replace(/\bfull\b/gi, 'full');
  result = result.replace(/\bcross\b/gi, 'cross');
  result = result.replace(/\bon\b/gi, 'on');
  result = result.replace(/\bas\b/gi, 'as');
  result = result.replace(/\band\b/gi, 'and');
  result = result.replace(/\bor\b/gi, 'or');
  result = result.replace(/\bin\b/gi, 'in');
  result = result.replace(/\bgroup\s+by\b/gi, 'group by');
  result = result.replace(/\border\s+by\b/gi, 'order by');
  result = result.replace(/\bhaving\b/gi, 'having');
  result = result.replace(/\blimit\b/gi, 'limit');
  result = result.replace(/\bdistinct\b/gi, 'distinct');
  result = result.replace(/\bwith\b/gi, 'with');

  // Uppercase CASE statement keywords
  result = result.replace(/\bCASE\b/gi, 'CASE');
  result = result.replace(/\bWHEN\b/gi, 'WHEN');
  result = result.replace(/\bTHEN\b/gi, 'THEN');
  result = result.replace(/\bELSE\b/gi, 'ELSE');
  result = result.replace(/\bEND\b/gi, 'END');

  // Restore comments before indentation
  result = restoreComments(result, comments);

  // Normalize indentation
  const indented = lines(result).map((line) => {
    const trimmed = line.trim();
    if (!trimmed) return '';
    // Don't indent comment lines
    if (trimmed.startsWith('--') || trimmed.startsWith('/*')) {
      return trimmed;
    }
    if (/^(select|from|where|group by|order by|having|join|left join|right join|on|using|union|insert|update|delete|merge|create|truncate|with|limit|fetch)/i.test(trimmed)) {
      return trimmed;
    }
    return '  ' + trimmed;
  });

  return rejoin(indented);
}

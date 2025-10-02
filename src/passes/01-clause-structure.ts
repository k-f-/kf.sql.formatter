import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

// This pass ensures that major SQL clauses start on their own lines
export function clauseStructurePass(text: string, opts: FormatterOptions): string {
  // Check if statement is short enough to keep on one line (≤100 characters)
  const totalLength = text.replace(/\s+/g, ' ').trim().length;
  if (totalLength <= 100 && !text.includes(' as ')) {
    // Keep short statements without aliases on one line
    return text.replace(/\s+/g, ' ').trim();
  }

  const clauseKeywords = [
    'select', 'select distinct', 'from', 'where', 'group by', 'order by', 'having',
    'join', 'left join', 'right join', 'full join', 'inner join', 'outer join',
    'cross join', 'lateral view',
    'on', 'using', 'union', 'union all', 'insert into', 'update', 'delete',
    'merge', 'values', 'create', 'create or replace', 'truncate', 'with',
    'limit', 'fetch', 'distribute by', 'cluster by'
  ];

  let result = text;

  // Ensure SELECT and SELECT DISTINCT are always on their own line
  result = result.replace(/\bselect\s+distinct\b/gi, '\nselect distinct\n');
  result = result.replace(/\bselect\b/gi, '\nselect\n');

  for (const keyword of clauseKeywords.sort((a, b) => b.length - a.length)) {
    const regex = new RegExp(`\\s+(${keyword.replace(/ /g, '\\s+')})\\b`, 'gi');
    result = result.replace(regex, '\n$1');
  }

  // Clean up multiple newlines
  result = result.replace(/\n{3,}/g, '\n\n');

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

  // Normalize indentation
  const indented = lines(result).map((line) => {
    const trimmed = line.trim();
    if (!trimmed) return '';
    if (/^(select|from|where|group by|order by|having|join|left join|right join|on|using|union|insert|update|delete|merge|create|truncate|with|limit|fetch)/i.test(trimmed)) {
      return trimmed;
    }
    return '  ' + trimmed;
  });

  return rejoin(indented);
}

import { FormatterOptions } from '../formatter';
import { lines, rejoin } from '../utils';

// This pass ensures that major SQL clauses start on their own lines
export function clauseStructurePass(text: string, opts: FormatterOptions): string {
  const clauseKeywords = [
    'select', 'from', 'where', 'group by', 'order by', 'having',
    'join', 'left join', 'right join', 'full join', 'inner join', 'outer join',
    'on', 'using', 'union', 'union all', 'insert into', 'update', 'delete',
    'merge', 'values', 'create', 'create or replace', 'truncate', 'with',
    'when', 'then', 'else', 'end', 'case', 'over', 'limit', 'fetch'
  ];

  let result = text;

  for (const keyword of clauseKeywords.sort((a, b) => b.length - a.length)) {
    const regex = new RegExp(`\\s+(${keyword.replace(' ', '\\s+')})\\b`, 'gi');
    result = result.replace(regex, '\n$1');
  }

  // Clean up multiple newlines
  result = result.replace(/\n{2,}/g, '\n');

  // Normalize indentation
  const indented = lines(result).map((line) => {
    const trimmed = line.trim();
    if (!trimmed) return '';
    if (/^(select|from|where|group by|order by|having|join|on|using|union|insert|update|delete|merge|create|truncate|with|limit|fetch)/i.test(trimmed)) {
      return trimmed;
    }
    return '    ' + trimmed;
  });

  return rejoin(indented);
}

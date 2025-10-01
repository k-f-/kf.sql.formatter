"use strict";
// Utility functions used throughout the formatter
Object.defineProperty(exports, "__esModule", { value: true });
exports.rejoin = exports.lines = void 0;
exports.normalizeKeywordCase = normalizeKeywordCase;
exports.splitStatementsCTESafe = splitStatementsCTESafe;
const lines = (text) => {
    return text.replace(/\r\n/g, '\n').split('\n');
};
exports.lines = lines;
const rejoin = (lines) => {
    return lines.join('\n');
};
exports.rejoin = rejoin;
function normalizeKeywordCase(text, keywordCase, functionCase) {
    if (keywordCase === 'preserve' && functionCase === 'preserve')
        return text;
    let out = text;
    const keywords = [
        'select', 'from', 'where', 'group by', 'order by', 'having', 'with',
        'join', 'left join', 'right join', 'full join', 'inner join', 'outer join',
        'on', 'using', 'union', 'union all', 'insert into', 'update', 'delete',
        'merge', 'into', 'values', 'create', 'create or replace', 'truncate', 'as',
        'when', 'then', 'else', 'end', 'case', 'over', 'partition by', 'rows between',
        'unbounded preceding', 'current row', 'distinct', 'all', 'limit', 'fetch'
    ];
    const applyCase = (word, mode) => {
        if (mode === 'lower')
            return word.toLowerCase();
        if (mode === 'upper')
            return word.toUpperCase();
        return word;
    };
    for (const kw of keywords.sort((a, b) => b.length - a.length)) {
        const re = new RegExp('\\b' + kw.replace(' ', '\\s+') + '\\b', 'gi');
        out = out.replace(re, (match) => applyCase(kw, keywordCase));
    }
    if (functionCase !== 'preserve') {
        out = out.replace(/\b([A-Za-z_][A-Za-z0-9_]*)\s*\(/g, (_, fn) => applyCase(fn, functionCase) + '(');
    }
    return out;
}
function splitStatementsCTESafe(text) {
    const src = text.replace(/\r\n/g, '\n');
    const out = [];
    let acc = '';
    const lines = src.split('\n');
    for (let i = 0; i < lines.length; i++) {
        const ln = lines[i];
        if (/^\s*;/.test(ln) && acc.trim().length > 0) {
            out.push(acc.trimEnd());
            acc = ln.replace(/^\s*;/, '').trimStart() + '\n';
            continue;
        }
        acc += ln + '\n';
    }
    if (acc.trim().length)
        out.push(acc.trimEnd());
    return out;
}
//# sourceMappingURL=utils.js.map
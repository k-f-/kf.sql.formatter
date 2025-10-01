"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.aliasAlignPass = aliasAlignPass;
exports.computeGlobalColumns = computeGlobalColumns;
const utils_1 = require("../utils");
// This pass ensures all aliases are aligned to a consistent column across the file
function aliasAlignPass(text, opts) {
    const ls = (0, utils_1.lines)(text);
    const out = [];
    const aliasLines = ls.filter(line => /\sas\s/i.test(line));
    const aliasPositions = aliasLines.map(line => line.indexOf(' as '));
    const maxAliasPos = Math.min(Math.max(...aliasPositions.map(pos => pos + opts.aliasMinGap)), opts.aliasMaxColumnCap);
    for (const line of ls) {
        const aliasMatch = line.match(/^(.*?)(\s+as\s+)(\S+)(.*)$/i);
        if (aliasMatch) {
            const [_, expr, asPart, alias, rest] = aliasMatch;
            const paddedExpr = expr.trimEnd().padEnd(maxAliasPos - asPart.length);
            const rebuilt = `${paddedExpr}${asPart}${alias}${rest}`;
            out.push(rebuilt);
        }
        else {
            out.push(line);
        }
    }
    return (0, utils_1.rejoin)(out);
}
// This pass also computes global alignment for comments after alias alignment
function computeGlobalColumns(text, opts) {
    const ls = (0, utils_1.lines)(text);
    const out = [];
    let maxCodeLength = 0;
    for (const line of ls) {
        const code = line.split('--')[0].trimEnd();
        maxCodeLength = Math.max(maxCodeLength, code.length);
    }
    for (const line of ls) {
        const [code, comment] = line.split('--');
        const paddedCode = code.trimEnd().padEnd(maxCodeLength + 2);
        if (comment !== undefined) {
            out.push(`${paddedCode}-- ${comment.trim()}`);
        }
        else {
            out.push(code);
        }
    }
    return (0, utils_1.rejoin)(out);
}
//# sourceMappingURL=05-debug-alias-align.js.map
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.joinWhereAlignPass = joinWhereAlignPass;
const utils_1 = require("../utils");
function joinWhereAlignPass(text, opts) {
    const ls = (0, utils_1.lines)(text);
    const out = [];
    let maxExprLength = 0;
    const exprLines = [];
    for (const line of ls) {
        if (/^\s*(and|or)?\s*[a-z_]+\s*=/.test(line)) {
            const code = line.split('--')[0].trimEnd();
            maxExprLength = Math.max(maxExprLength, code.length);
            exprLines.push(line);
        }
        else {
            out.push(line);
        }
    }
    for (const line of exprLines) {
        const [code, comment] = line.split('--');
        const padded = code.padEnd(maxExprLength + 2);
        out.push(comment ? `${padded}-- ${comment.trim()}` : padded);
    }
    return (0, utils_1.rejoin)(out);
}
//# sourceMappingURL=06-join-where-align.js.map
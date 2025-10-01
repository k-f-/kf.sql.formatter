"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.semicolonsPass = semicolonsPass;
const utils_1 = require("../utils");
function semicolonsPass(text, opts) {
    const stmts = (0, utils_1.splitStatementsCTESafe)(text);
    if (stmts.length <= 1) {
        return stmts[0].replace(/;\s*$/m, '').trimEnd();
    }
    const normalized = [];
    for (let i = 0; i < stmts.length; i++) {
        let s = stmts[i].replace(/;\s*$/m, '').trimEnd();
        if (i === 0) {
            normalized.push(s);
        }
        else {
            const lines = s.split('\n');
            let emitted = false;
            for (let j = 0; j < lines.length; j++) {
                const ln = lines[j];
                if (!emitted && (!opts.semicolonSkipComments || !ln.trim().startsWith('--')) && ln.trim().length > 0) {
                    lines[j] = ';' + ln.trimStart();
                    emitted = true;
                }
            }
            normalized.push(lines.join('\n'));
        }
    }
    return normalized.join('\n');
}
//# sourceMappingURL=09-semicolons.js.map
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.leadingCommasPass = leadingCommasPass;
const utils_1 = require("../utils");
function leadingCommasPass(text, opts) {
    if (!opts.leadingCommas)
        return text;
    const ls = (0, utils_1.lines)(text);
    const out = [];
    let inSelect = false;
    for (let line of ls) {
        if (/^\s*select\b/i.test(line)) {
            inSelect = true;
            out.push(line);
            continue;
        }
        if (/^\s*(from|where|group|order|having|union|;|update|insert|merge|with)\b/i.test(line)) {
            inSelect = false;
            out.push(line);
            continue;
        }
        if (inSelect && /^\s*[^,]/.test(line)) {
            line = ',' + line.trimStart();
        }
        out.push(line);
    }
    return (0, utils_1.rejoin)(out);
}
//# sourceMappingURL=02-leading-commas.js.map
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.commentWrapPass = commentWrapPass;
const utils_1 = require("../utils");
function commentWrapPass(text, opts) {
    const wrapCol = opts.commentWrapColumn || 100;
    const ls = (0, utils_1.lines)(text);
    const out = [];
    for (const line of ls) {
        if (/--/.test(line)) {
            const idx = line.indexOf('--');
            const code = line.slice(0, idx).trimEnd();
            const comment = line.slice(idx + 2).trim();
            if (code.length + 3 + comment.length <= wrapCol) {
                out.push(code + '  -- ' + comment);
            }
            else {
                const words = comment.split(' ');
                let chunk = '';
                for (const word of words) {
                    if ((chunk + ' ' + word).length + code.length + 3 <= wrapCol) {
                        chunk += (chunk ? ' ' : '') + word;
                    }
                    else {
                        out.push(code + '  -- ' + chunk);
                        chunk = word;
                    }
                }
                if (chunk)
                    out.push(code + '  -- ' + chunk);
            }
        }
        else {
            out.push(line);
        }
    }
    return (0, utils_1.rejoin)(out);
}
//# sourceMappingURL=11-comment-wrap.js.map
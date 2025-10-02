"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.trailingWhitespacePass = trailingWhitespacePass;
const utils_1 = require("../utils");
function trailingWhitespacePass(text, opts) {
    if (!opts.trimTrailingWhitespace)
        return text;
    const ls = (0, utils_1.lines)(text);
    const out = ls.map(line => line.replace(/\s+$/, ''));
    return (0, utils_1.rejoin)(out);
}
//# sourceMappingURL=10-trailing-ws.js.map
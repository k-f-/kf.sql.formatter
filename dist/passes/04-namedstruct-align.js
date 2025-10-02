"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.namedStructAlignPass = namedStructAlignPass;
const utils_1 = require("../utils");
function namedStructAlignPass(text, opts) {
    const ls = (0, utils_1.lines)(text);
    const out = [];
    let inStruct = false;
    let structLines = [];
    let maxKeyLength = 0;
    for (const line of ls) {
        if (/named_struct\s*\(/i.test(line)) {
            inStruct = true;
            structLines.push(line);
            continue;
        }
        if (inStruct) {
            if (/\)/.test(line)) {
                inStruct = false;
                structLines.push(line);
                // Align keys
                const aligned = structLines.map(l => {
                    const match = l.match(/'([^']+)'\s*,\s*(.+)/);
                    if (match) {
                        const key = `'${match[1]}'`;
                        const value = match[2].split('--')[0].trim();
                        maxKeyLength = Math.max(maxKeyLength, key.length);
                        const comment = l.includes('--') ? l.split('--')[1].trim() : '';
                        return `${key.padEnd(maxKeyLength + 2)}, ${value}${comment ? '  -- ' + comment : ''}`;
                    }
                    return l;
                });
                out.push(...aligned);
                structLines = [];
            }
            else {
                structLines.push(line);
            }
        }
        else {
            out.push(line);
        }
    }
    return (0, utils_1.rejoin)(out);
}
//# sourceMappingURL=04-namedstruct-align.js.map
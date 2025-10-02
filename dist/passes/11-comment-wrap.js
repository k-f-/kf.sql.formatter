"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.commentWrapPass = commentWrapPass;
const utils_1 = require("../utils");
function commentWrapPass(text, opts) {
    const wrapCol = opts.commentWrapColumn || 120; // Wrap at 100-120 characters
    const ls = (0, utils_1.lines)(text);
    const out = [];
    for (const line of ls) {
        const commentIdx = line.indexOf('--');
        if (commentIdx >= 0) {
            const code = line.slice(0, commentIdx).trimEnd();
            const comment = line.slice(commentIdx + 2).trim();
            const totalLength = code.length + 3 + comment.length;
            if (totalLength <= wrapCol) {
                // Comment fits on one line
                out.push(line);
            }
            else {
                // Need to wrap the comment
                const indent = ' '.repeat(commentIdx);
                const words = comment.split(' ');
                let currentLine = '';
                let isFirst = true;
                for (const word of words) {
                    const testLine = currentLine + (currentLine ? ' ' : '') + word;
                    const testLength = (isFirst ? code.length : indent.length) + 3 + testLine.length;
                    if (testLength <= wrapCol || currentLine === '') {
                        currentLine = testLine;
                    }
                    else {
                        // Output current line and start new one
                        if (isFirst) {
                            out.push(code + ' '.repeat(Math.max(1, commentIdx - code.length)) + '-- ' + currentLine);
                            isFirst = false;
                        }
                        else {
                            out.push(indent + '-- ' + currentLine);
                        }
                        currentLine = word;
                    }
                }
                // Output remaining text
                if (currentLine) {
                    if (isFirst) {
                        out.push(code + ' '.repeat(Math.max(1, commentIdx - code.length)) + '-- ' + currentLine);
                    }
                    else {
                        out.push(indent + '-- ' + currentLine);
                    }
                }
            }
        }
        else {
            out.push(line);
        }
    }
    return (0, utils_1.rejoin)(out);
}
//# sourceMappingURL=11-comment-wrap.js.map
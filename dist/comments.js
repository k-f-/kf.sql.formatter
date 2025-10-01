"use strict";
// This file handles comment-related utilities and formatting logic.
Object.defineProperty(exports, "__esModule", { value: true });
exports.alignInlineComments = alignInlineComments;
exports.wrapComment = wrapComment;
function alignInlineComments(lines, targetColumn) {
    return lines.map(line => {
        const commentIndex = line.indexOf('--');
        if (commentIndex === -1)
            return line;
        const code = line.slice(0, commentIndex).trimEnd();
        const comment = line.slice(commentIndex).trim();
        const padding = ' '.repeat(Math.max(2, targetColumn - code.length));
        return `${code}${padding}${comment}`;
    });
}
function wrapComment(comment, wrapColumn) {
    const words = comment.replace(/^--\s*/, '').split(/\s+/);
    const wrapped = [];
    let line = '--';
    for (const word of words) {
        if ((line + ' ' + word).length > wrapColumn) {
            wrapped.push(line);
            line = '-- ' + word;
        }
        else {
            line += (line === '--' ? ' ' : ' ') + word;
        }
    }
    if (line.trim())
        wrapped.push(line);
    return wrapped;
}
//# sourceMappingURL=comments.js.map
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.aliasAlignPass = aliasAlignPass;
exports.computeGlobalColumns = computeGlobalColumns;
const utils_1 = require("../utils");
function aliasAlignPass(text, opts) {
    const IDEAL_ALIAS_POSITION = 80;
    const MIN_SPACING = 8;
    const ls = (0, utils_1.lines)(text);
    // First pass: Find the global max width
    let globalMaxWidth = 0;
    const multiLineExpressions = new Set();
    for (let i = 0; i < ls.length; i++) {
        const line = ls[i];
        const asMatch = /\s+as\s+\S+/i.exec(line);
        if (asMatch) {
            // Check if this is a multi-line expression ending
            const trimmed = line.trim();
            const isMultiLineEnding = /^(END|\))\s+as\s+/i.test(trimmed);
            if (isMultiLineEnding) {
                multiLineExpressions.add(i);
            }
            // Always check the line width
            const beforeAs = line.substring(0, asMatch.index).trimEnd();
            globalMaxWidth = Math.max(globalMaxWidth, beforeAs.length);
        }
    }
    // Scan all lines to find the true max width (excluding standalone comment lines)
    for (const line of ls) {
        const trimmedLine = line.trim();
        // Skip standalone comment lines - they shouldn't affect alignment
        if (trimmedLine.startsWith('--')) {
            continue;
        }
        const trimmedEndLine = line.trimEnd();
        if (trimmedEndLine.length > 0) {
            globalMaxWidth = Math.max(globalMaxWidth, trimmedEndLine.length);
        }
    }
    // Determine global alignment position
    const alignPosition = Math.max(IDEAL_ALIAS_POSITION, globalMaxWidth + MIN_SPACING);
    // Second pass: Apply alignment
    const out = [];
    for (let i = 0; i < ls.length; i++) {
        let line = ls[i];
        const asMatch = /\s+as\s+\S+/i.exec(line);
        if (!asMatch) {
            // Skip standalone comment lines (lines that only contain comments)
            const trimmedLine = line.trim();
            if (trimmedLine.startsWith('--')) {
                out.push(line);
                continue;
            }
            // Handle inline comments (comments after code) that need alignment
            const commentMatch = /^(\s*)(.+?)(\s+)(--\s*.*)$/.exec(line);
            if (commentMatch && !line.includes(' as ')) {
                const [, indent, content, , comment] = commentMatch;
                const contentLength = (indent + content).length;
                if (contentLength < alignPosition) {
                    const padding = ' '.repeat(alignPosition - contentLength);
                    out.push(indent + content + padding + comment);
                }
                else {
                    out.push(indent + content + ' '.repeat(MIN_SPACING) + comment);
                }
            }
            else {
                out.push(line);
            }
            continue;
        }
        // Parse the line components
        const match = /^(.*?)(\s+)(as)(\s+)(\S+)(\s*)(--.*)?$/i.exec(line);
        if (match) {
            const [, expression, , asKeyword, , alias, , comment] = match;
            // Edge case: Multi-line expressions ending with ) or END
            // Position the alias at alignPosition - 1
            let targetPosition = alignPosition;
            if (multiLineExpressions.has(i)) {
                targetPosition = alignPosition - 1;
            }
            // Calculate padding
            const currentEnd = expression.length;
            const padding = ' '.repeat(Math.max(MIN_SPACING, targetPosition - currentEnd));
            // Build aligned line
            let alignedLine = expression + padding + asKeyword + ' ' + alias;
            // Add comment if present
            if (comment) {
                const currentLength = alignedLine.length;
                const commentPadding = ' '.repeat(Math.max(4, targetPosition + 20 - currentLength));
                alignedLine += commentPadding + comment;
            }
            out.push(alignedLine);
        }
        else {
            out.push(line);
        }
    }
    return (0, utils_1.rejoin)(out);
}
// Kept for backwards compatibility, but now handled in main aliasAlignPass
function computeGlobalColumns(text, opts) {
    return aliasAlignPass(text, opts);
}
//# sourceMappingURL=05-alias-align.js.map
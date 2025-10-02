"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.formatDocument = formatDocument;
const utils_1 = require("./utils");
const _01_clause_structure_1 = require("./passes/01-clause-structure");
const _02_leading_commas_1 = require("./passes/02-leading-commas");
const _03_breakers_1 = require("./passes/03-breakers");
const _04_namedstruct_align_1 = require("./passes/04-namedstruct-align");
const _05_alias_align_1 = require("./passes/05-alias-align");
const _06_join_where_align_1 = require("./passes/06-join-where-align");
const _07_group_order_align_1 = require("./passes/07-group-order-align");
const _08_update_set_align_1 = require("./passes/08-update-set-align");
const _09_semicolons_1 = require("./passes/09-semicolons");
const _10_trailing_ws_1 = require("./passes/10-trailing-ws");
const _11_comment_wrap_1 = require("./passes/11-comment-wrap");
function formatDocument(text, opts) {
    // Ensure leading commas is always enabled
    const enforceOpts = {
        ...opts,
        leadingCommas: true
    };
    // 0) Case normalization for keywords/functions (non-invasive)
    let t = (0, utils_1.normalizeKeywordCase)(text, enforceOpts.keywordCase, enforceOpts.functionCase);
    // 1) Split into statements (CTE safe: DO NOT split between with...select/insert/update/delete/merge)
    const stmts = (0, utils_1.splitStatementsCTESafe)(t);
    // 2) Format each statement independently, then rejoin (semicolon handling later)
    const formattedStatements = stmts.map((stmt) => {
        let s = stmt;
        s = (0, _01_clause_structure_1.clauseStructurePass)(s, enforceOpts); // Clause structure with keyword casing
        s = (0, _02_leading_commas_1.leadingCommasPass)(s, enforceOpts); // Leading commas (no space after comma)
        s = (0, _03_breakers_1.breakersPass)(s, enforceOpts); // CASE/OVER/long functions
        s = (0, _04_namedstruct_align_1.namedStructAlignPass)(s, enforceOpts); // named_struct alignment
        s = (0, _05_alias_align_1.aliasAlignPass)(s, enforceOpts); // File-wide alias alignment at column 80+
        s = (0, _06_join_where_align_1.joinWhereAlignPass)(s, enforceOpts); // Align comments in join/where
        s = (0, _07_group_order_align_1.groupOrderAlignPass)(s, enforceOpts); // Align comments in group/order
        s = (0, _08_update_set_align_1.updateSetAlignPass)(s, enforceOpts); // Align '=' in update set
        s = (0, _10_trailing_ws_1.trailingWhitespacePass)(s, enforceOpts); // Trim trailing whitespace
        return s;
    });
    // 3) Rejoin and apply semicolon policy across statements
    let joined = formattedStatements.join('\n');
    joined = (0, _09_semicolons_1.semicolonsPass)(joined, enforceOpts); // Inline semicolons with following statement
    // 4) Apply alias alignment again for global consistency
    joined = (0, _05_alias_align_1.aliasAlignPass)(joined, enforceOpts);
    // 5) Wrap long comments last (to avoid breaking alignment calc)
    const finalText = (0, _11_comment_wrap_1.commentWrapPass)(joined, enforceOpts);
    return finalText;
}
//# sourceMappingURL=formatter.js.map
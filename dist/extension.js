"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = activate;
exports.deactivate = deactivate;
const vscode = __importStar(require("vscode"));
const formatter_1 = require("./formatter");
const alias_1 = require("./alias");
const semicolons_1 = require("./semicolons");
function activate(context) {
    const selector = [
        { language: 'sql', scheme: 'file' },
        { language: 'sql', scheme: 'untitled' },
        { language: 'spark-sql', scheme: 'file' },
        { language: 'spark-sql', scheme: 'untitled' }
    ];
    context.subscriptions.push(vscode.languages.registerDocumentFormattingEditProvider(selector, {
        provideDocumentFormattingEdits(document) {
            const text = document.getText();
            const settings = vscode.workspace.getConfiguration('databricksSqlFormatter');
            const formatted = (0, formatter_1.formatDocument)(text, {
                keywordCase: settings.get('keywordCase', 'lower'),
                functionCase: settings.get('functionCase', 'lower'),
                indent: settings.get('indent', 4),
                leadingCommas: settings.get('leadingCommas', true),
                dialect: settings.get('dialect', 'spark'),
                aliasAlignmentScope: settings.get('aliasAlignmentScope', 'file'),
                aliasMinGap: settings.get('aliasMinGap', 8),
                aliasMaxColumnCap: settings.get('aliasMaxColumnCap', 120),
                forceAsForAliases: settings.get('forceAsForAliases', 'existingOnly'),
                joinInlineSingle: settings.get('join.inlineSingleCondition', true),
                joinInlineMaxWidth: settings.get('join.inlineMaxWidth', 100),
                usingMultiLineThreshold: settings.get('using.multiLineThreshold', 2),
                semicolonStyle: settings.get('semicolon.style', 'leading-when-multi'),
                semicolonSkipComments: settings.get('semicolon.skipCommentLines', true),
                trimTrailingWhitespace: settings.get('trimTrailingWhitespace', true),
                commentWrapColumn: settings.get('comment.wrapColumn', 100)
            });
            const fullRange = new vscode.Range(document.positionAt(0), document.positionAt(text.length));
            return [vscode.TextEdit.replace(fullRange, formatted)];
        }
    }));
    context.subscriptions.push(vscode.commands.registerCommand('databricksSqlFormatter.autoAliasAll', async () => {
        const editor = vscode.window.activeTextEditor;
        if (!editor)
            return;
        const settings = vscode.workspace.getConfiguration('databricksSqlFormatter');
        const text = editor.document.getText();
        const updated = (0, alias_1.autoAliasEverything)(text, {
            aliasMinGap: settings.get('aliasMinGap', 8),
            aliasMaxColumnCap: settings.get('aliasMaxColumnCap', 120),
            commentWrapColumn: settings.get('comment.wrapColumn', 100)
        });
        await editor.edit((edit) => {
            const fullRange = new vscode.Range(editor.document.positionAt(0), editor.document.positionAt(text.length));
            edit.replace(fullRange, updated);
        });
    }));
    context.subscriptions.push(vscode.commands.registerCommand('databricksSqlFormatter.fixSemicolons', async () => {
        const editor = vscode.window.activeTextEditor;
        if (!editor)
            return;
        const settings = vscode.workspace.getConfiguration('databricksSqlFormatter');
        const text = editor.document.getText();
        const updated = (0, semicolons_1.normalizeSemicolons)(text, {
            style: settings.get('semicolon.style', 'leading-when-multi'),
            skipCommentLines: settings.get('semicolon.skipCommentLines', true)
        });
        await editor.edit((edit) => {
            const fullRange = new vscode.Range(editor.document.positionAt(0), editor.document.positionAt(text.length));
            edit.replace(fullRange, updated);
        });
    }));
}
function deactivate() { }
//# sourceMappingURL=extension.js.map
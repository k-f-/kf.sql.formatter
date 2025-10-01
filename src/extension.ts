import * as vscode from 'vscode';
import { formatDocument } from './formatter';
import { autoAliasEverything } from './alias';
import { normalizeSemicolons } from './semicolons';

export function activate(context: vscode.ExtensionContext) {
  const selector: vscode.DocumentSelector = [
    { language: 'sql', scheme: 'file' },
    { language: 'sql', scheme: 'untitled' },
    { language: 'spark-sql', scheme: 'file' },
    { language: 'spark-sql', scheme: 'untitled' }
  ];

  context.subscriptions.push(
    vscode.languages.registerDocumentFormattingEditProvider(selector, {
      provideDocumentFormattingEdits(document) {
        const text = document.getText();
        const settings = vscode.workspace.getConfiguration('databricksSqlFormatter');
        const formatted = formatDocument(text, {
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

        const fullRange = new vscode.Range(
          document.positionAt(0),
          document.positionAt(text.length)
        );
        return [vscode.TextEdit.replace(fullRange, formatted)];
      }
    })
  );

  context.subscriptions.push(
    vscode.commands.registerCommand('databricksSqlFormatter.autoAliasAll', async () => {
      const editor = vscode.window.activeTextEditor;
      if (!editor) return;
      const settings = vscode.workspace.getConfiguration('databricksSqlFormatter');
      const text = editor.document.getText();
      const updated = autoAliasEverything(text, {
        aliasMinGap: settings.get('aliasMinGap', 8),
        aliasMaxColumnCap: settings.get('aliasMaxColumnCap', 120),
        commentWrapColumn: settings.get('comment.wrapColumn', 100)
      });
      await editor.edit((edit) => {
        const fullRange = new vscode.Range(
          editor.document.positionAt(0),
          editor.document.positionAt(text.length)
        );
        edit.replace(fullRange, updated);
      });
    })
  );

  context.subscriptions.push(
    vscode.commands.registerCommand('databricksSqlFormatter.fixSemicolons', async () => {
      const editor = vscode.window.activeTextEditor;
      if (!editor) return;
      const settings = vscode.workspace.getConfiguration('databricksSqlFormatter');
      const text = editor.document.getText();
      const updated = normalizeSemicolons(text, {
        style: settings.get('semicolon.style', 'leading-when-multi'),
        skipCommentLines: settings.get('semicolon.skipCommentLines', true)
      });
      await editor.edit((edit) => {
        const fullRange = new vscode.Range(
          editor.document.positionAt(0),
          editor.document.positionAt(text.length)
        );
        edit.replace(fullRange, updated);
      });
    })
  );
}

export function deactivate() {}

# Markdown Linting Guide

This project uses `markdownlint-cli` to ensure consistent, high-quality markdown documentation.

## 🤖 Automatic Linting (NEW!)

**Markdown files are now automatically linted on commit!**

When you commit markdown files, a Git pre-commit hook automatically:

1. Runs `markdownlint --fix` on all staged `.md` files
2. Auto-fixes common formatting issues
3. Adds the fixed files back to the commit

**You don't need to manually run `npm run lint:fix` anymore!**

Just commit normally:

```bash
git add README.md
git commit -m "docs: update readme"
# ✅ Hook automatically fixes and re-stages README.md
```

## Quick Commands

```bash
# Check all markdown files for linting errors
npm run lint

# Manually auto-fix markdown linting errors (if needed)
npm run lint:fix
```

## When to Use Manual Commands

### Before Committing (Optional)

The pre-commit hook handles this automatically, but you can still run manually:

```bash
npm run lint:fix
git add .
git commit -m "docs: your message"
```

### After Creating New Files (Optional)

The pre-commit hook will handle it, but you can preview fixes:

- `README.md`
- `CHANGELOG.md`
- `TESTING_*.md`
- `RELEASE_NOTES_*.md`
- Any other `.md` file

The pre-commit hook will automatically fix them when you commit!

## How Automatic Linting Works

### Git Pre-Commit Hook

Uses `husky` and `lint-staged` to run markdownlint automatically:

1. **You stage markdown files**: `git add README.md`
2. **You commit**: `git commit -m "docs: update"`
3. **Hook runs automatically**:
   - Detects staged `.md` files
   - Runs `markdownlint --fix` on them
   - Auto-fixes formatting issues
   - Re-stages the fixed files
   - Continues with the commit

### Configuration

**`.husky/pre-commit`**:

```bash
#!/usr/bin/env sh
npx lint-staged
```

**`package.json` - `lint-staged` section**:

```json
"lint-staged": {
  "*.md": [
    "markdownlint --fix",
    "git add"
  ]
}
```

This ensures:

- ✅ All committed markdown is properly formatted
- ✅ No manual intervention needed
- ✅ Consistent formatting across all contributors
- ✅ Clean git history without formatting-only commits

## What Gets Fixed

The linter automatically fixes:

- ✅ **Blank lines around headings** - Ensures proper spacing
- ✅ **Blank lines around lists** - Consistent list formatting
- ✅ **Blank lines around code blocks** - Clean code fence spacing
- ✅ **Trailing spaces** - Removes unnecessary whitespace
- ✅ **List indentation** - Consistent list item spacing
- ✅ **Heading styles** - Enforces ATX-style headings (`#` not underlines)

## Configuration

Rules are defined in `.markdownlint.json`:

```json
{
  "default": true,           // Enable all rules by default
  "MD013": false,           // Line length - disabled (too restrictive)
  "MD033": false,           // HTML allowed (for badges, etc.)
  "MD041": false,           // First line doesn't need to be H1
  "MD034": false,           // Bare URLs allowed
  "MD036": false            // Emphasis as heading allowed
}
```

### Disabled Rules Explanation

- **MD013** (line-length): Disabled because long URLs, code examples, and tables often exceed 80 chars
- **MD033** (no-inline-html): Disabled to allow badges, custom formatting in README
- **MD041** (first-line-heading): Disabled to allow front matter or other content before H1
- **MD034** (no-bare-urls): Disabled to allow simple URL display in release notes
- **MD036** (no-emphasis-as-heading): Disabled to allow `**Bold text**` for emphasis

## Common Issues Fixed

### Before

```markdown
# Heading
No blank line above heading

- List item
- Another item
No blank line after list

```bash
code block
```
No blank line around code block
```

### After (Auto-fixed)

```markdown
# Heading

Proper blank line above heading

- List item
- Another item

Proper blank line after list

```bash
code block
```

Proper blank lines around code block
```

## Manual Fixes Required

Some issues cannot be auto-fixed and require manual intervention:

- **MD026** - Trailing punctuation in headings (e.g., `# Title!`)
  - Fix: Remove `!` from heading
- **MD024** - Multiple headings with same content
  - Fix: Make headings unique or nest under different sections
- **MD022** - Spacing around headings (complex cases)
  - Fix: Manually add blank lines

## Integration with VS Code

Install the VS Code extension for real-time linting:

```bash
code --install-extension DavidAnson.vscode-markdownlint
```

This will show inline errors as you type.

## CI/CD Integration

The linter runs automatically in CI/CD:

```yaml
# .github/workflows/ci.yml
- name: Lint Markdown
  run: npm run lint
```

This ensures all markdown files are clean before merging.

## Examples

### Clean Release Notes

```markdown
# Release v0.0.2

## Summary

Successfully created and released version 0.0.2.

### What Was Accomplished

- Item 1
- Item 2
- Item 3

### Code Examples

```bash
npm install
npm run compile
```

## Next Steps

1. Step one
2. Step two
3. Step three
```

### Testing Your Changes

```bash
# Create or edit a markdown file
vim RELEASE_NOTES_v0.0.3.md

# Auto-fix any issues
npm run lint:fix

# Verify no errors remain
npm run lint

# If lint passes, commit
git add RELEASE_NOTES_v0.0.3.md
git commit -m "docs: add release notes for v0.0.3"
```

## Troubleshooting

### Linter Not Installed

```bash
npm install
```

### Config Not Found

Ensure `.markdownlint.json` exists in project root.

### Auto-fix Didn't Work

Some errors require manual fixes. Run `npm run lint` to see remaining issues.

### Want Stricter Rules

Edit `.markdownlint.json` to enable more rules or adjust settings.

### Pre-Commit Hook Not Running

**Check if hook is executable**:

```bash
ls -la .husky/pre-commit
# Should show -rwxr-xr-x (executable)
```

**Make executable if needed**:

```bash
chmod +x .husky/pre-commit
```

**Verify husky is installed**:

```bash
npm install
```

**Check package.json has prepare script**:

```json
"scripts": {
  "prepare": "husky"
}
```

**Test the hook manually**:

```bash
# Stage a markdown file with errors
echo "# Test" > test.md
git add test.md

# Run lint-staged manually
npx lint-staged

# Check if file was fixed
cat test.md
```

### Hook Runs But Doesn't Fix Files

**Check lint-staged configuration in package.json**:

```json
"lint-staged": {
  "*.md": [
    "markdownlint --fix",
    "git add"
  ]
}
```

**Ensure markdownlint is installed**:

```bash
npm install --save-dev markdownlint-cli
```

**Run manually to see errors**:

```bash
npx markdownlint --fix *.md
```

## Best Practices

1. **Write first, lint later** - Don't worry about formatting while writing
2. **Run lint:fix before committing** - Makes commits clean
3. **Use VS Code extension** - Get real-time feedback
4. **Keep config simple** - Only disable rules that are too restrictive
5. **Document exceptions** - If you disable a rule, explain why

## Resources

- [markdownlint rules](https://github.com/DavidAnson/markdownlint/blob/main/doc/Rules.md)
- [VS Code extension](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)
- [markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli)

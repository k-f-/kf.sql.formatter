# GitHub Copilot Instructions for Databricks SQL Formatter

## Project Overview

This repository contains a VS Code extension that provides SQL formatting for Databricks/Spark SQL with organization-specific conventions. The formatter enforces consistent coding standards across SQL files with features like:

- File-wide alias alignment
- Global inline comment alignment
- Semantic aliasing (on-demand)
- JOIN, UPDATE, and MERGE formatting
- CASE/OVER clause breaking
- ORDER BY/GROUP BY formatting
- Sophisticated semicolon handling
- Comment wrapping and whitespace trimming

## Tech Stack

- **Language**: TypeScript
- **Runtime**: Node.js (VS Code Extension Host)
- **Platform**: VS Code Extension API
- **Build**: TypeScript Compiler (tsc)
- **Package**: VSCE (VS Code Extension packaging)

## Architecture

The codebase follows a multi-pass formatting architecture:

1. **Lexer** (`src/sqlLexer.ts`): Tokenizes SQL into a structured format
2. **Passes** (`src/passes/`): Sequential formatting transformations
   - `01-clause-structure.ts`: Basic SQL clause structuring
   - `02-leading-commas.ts`: Leading comma conversion
   - `03-breakers.ts`: Breaking long expressions
   - `04-namedstruct-align.ts`: Aligning named_struct calls
   - `05-alias-align.ts`: File-wide alias alignment
   - `06-join-where-align.ts`: JOIN and WHERE clause alignment
   - `07-group-order-align.ts`: GROUP BY and ORDER BY alignment
   - `08-update-set-align.ts`: UPDATE/MERGE SET alignment
   - `09-semicolons.ts`: Semicolon normalization
   - `10-trailing-ws.ts`: Trailing whitespace removal
   - `11-comment-wrap.ts`: Comment wrapping
3. **Formatter** (`src/formatter.ts`): Orchestrates all passes
4. **Extension** (`src/extension.ts`): VS Code integration

## Development Guidelines

### Code Style

- Use **TypeScript strict mode** - all code must be type-safe
- **Indentation**: 2 spaces for TypeScript files
- **Naming conventions**:
  - camelCase for variables and functions
  - PascalCase for types and interfaces
  - UPPER_CASE for constants
- Keep functions **small and focused** - each pass should do one thing well
- **Comments**: Add comments for complex logic, especially in parsing/formatting passes
- Follow the **existing code patterns** in each module

### Testing

**CRITICAL**: See `docs/development/TESTING_PLAN.md` for comprehensive testing strategy.

#### Testing Requirements (All Changes)
1. **Aesthetic Validation**: Test against `examples/` directory
2. **Execution Safety**: Formatted SQL must remain 100% executable
3. **Idempotence**: Verify `format(format(text)) === format(text)`
4. **No Regressions**: Compare against golden files (when available)

#### Before Committing Any Formatter Changes
- [ ] Test with all files in `examples/` directory
- [ ] Verify no execution-breaking changes (syntax must remain valid)
- [ ] Check idempotence (format twice, compare results)
- [ ] Update tests if behavior changed
- [ ] Update documentation if user-facing change

#### Test Files
- `examples/01-basic-queries.sql` - Simple SELECT statements
- `examples/02-ctes-subqueries.sql` - CTEs and nested queries
- `examples/03-joins.sql` - All join types and conditions
- `examples/04-expressions.sql` - CASE, window functions, etc.
- `examples/05-spark-specific.sql` - Databricks/Spark features
- `examples/06-dml-ddl.sql` - INSERT, UPDATE, MERGE, etc.
- `examples/07-comments-strings.sql` - Comment and string handling
- `examples/08-edge-cases.sql` - Edge cases and stress tests

#### Running Tests

```bash
node tests/test-examples.js    # Main test suite (8 example files)
node tests/run-suite.js        # Full test suite runner
```

Legacy test files are archived in `tests/legacy/` for reference only.

### Building

```bash
npm install        # Install dependencies
npm run compile    # Compile TypeScript to dist/
npm run watch      # Watch mode for development
npm run package    # Create .vsix extension package
npm run lint       # Check markdown files for linting errors
npm run lint:fix   # Auto-fix markdown linting errors
```

### Documentation Quality

**When creating or editing Markdown files**:

1. **Automatic linting on commit**:
   - Pre-commit hook runs `markdownlint --fix` automatically
   - Fixes are staged and included in your commit
   - No manual intervention needed

2. **Manual linting** (optional):

   ```bash
   npm run lint:fix  # Auto-fix issues
   npm run lint      # Check for remaining errors
   ```

3. **Linter configuration**: `.markdownlint.json`

4. **What gets fixed automatically**:
   - Blank lines around headings
   - Blank lines around lists and code blocks
   - Trailing spaces
   - List indentation
   - Consistent heading styles

5. **Pre-commit hook troubleshooting**:
   - If hook doesn't run: `chmod +x .husky/pre-commit`
   - Test manually: `npx lint-staged`
   - See `docs/development/MARKDOWN_LINTING.md` for detailed troubleshooting

**Note**: The pre-commit hook ensures all committed markdown is properly formatted without manual effort.

### File Organization

- **Source code**: `src/` directory
- **Build output**: `dist/` (gitignored)
- **Configuration**: `package.json` (extension manifest and npm config)
- **TypeScript config**: `tsconfig.json`
- **Core documentation**: Root directory
  - `README.md` - User-facing documentation
  - `CHANGELOG.md` - Version history
  - `LICENSE` - Project license
- **Development docs**: `docs/development/`
  - `PROJECT_SPEC.md` - Detailed formatting specification
  - `TESTING_PLAN.md` - Comprehensive testing strategy
  - `TESTING_IN_VSCODE.md` - Manual testing guide
  - `TROUBLESHOOTING.md` - Debugging guide
  - `MARKDOWN_LINTING.md` - Linting setup and troubleshooting
- **Release docs**: `docs/releases/`
  - `RELEASE_CHECKLIST.md` - Release process checklist
  - `QUICK_RELEASE.md` - Quick release guide
  - `v0.0.X/` - Version-specific release notes and summaries
- **Archived docs**: `docs/archive/` - Historical/legacy documentation
- **Tests**: `tests/`
  - `test-examples.js` - Main test suite
  - `run-suite.js` - Full test runner
  - `legacy/` - Archived test scripts and outputs

### Configuration System

Settings are defined in `package.json` under `contributes.configuration` and accessed via VS Code's workspace configuration API. All settings use the `databricksSqlFormatter.*` namespace.

Key settings:
- `keywordCase`, `functionCase`: Case transformation
- `indent`: Spaces per indent level
- `leadingCommas`: Leading vs trailing commas
- `aliasAlignmentScope`: Scope of alias alignment (file/select/none)
- `semicolon.style`: Semicolon placement strategy

### Making Changes

#### Adding a New Pass

1. Create new file in `src/passes/` with sequential number
2. Export a function that takes text and config, returns transformed text
3. Import and call in `src/formatter.ts` in the correct sequence
4. Update `docs/development/PROJECT_SPEC.md` to document the new feature

#### Modifying Existing Pass

1. Understand the pass's purpose by reading its code and related tests
2. Make minimal changes - these passes are carefully tuned
3. Test with various SQL samples to ensure no regressions
4. Update documentation if behavior changes

#### Adding Configuration Options

1. Add to `package.json` under `contributes.configuration.properties`
2. Update TypeScript types in relevant modules
3. Document in `README.md` and `docs/development/PROJECT_SPEC.md`
4. Provide sensible defaults

### Common Pitfalls

- **Don't break idempotence**: Formatting should be stable
- **Preserve comments**: User comments must never be lost or corrupted
- **Handle edge cases**: Empty strings, single tokens, malformed SQL
- **Test CTE safety**: Never insert semicolons between WITH and its query
- **Maintain alignment**: Alignment passes depend on previous passes' output

### SQL Dialect Specifics

This formatter targets **Spark/Databricks SQL**, which includes:
- `named_struct()` function (non-standard)
- Backtick identifiers
- Spark-specific keywords (e.g., `USING` in joins)
- Table-valued functions

### Debugging Tips

- Use VS Code's built-in extension debugger (F5)
- Add console.log in passes to see intermediate states
- Test with `src/passes/05-debug-alias-align.ts` for detailed alias alignment logs
- Check the output of each pass individually

### Dependencies

Minimal dependencies by design:
- `typescript`: For compilation
- `vsce`: For packaging
- `@types/node`: TypeScript definitions
- `vscode`: VS Code API (deprecated, but used)

Avoid adding new dependencies unless absolutely necessary.

### Performance Considerations

- The formatter runs synchronously on document format
- Keep passes efficient - they run on every format operation
- Avoid regex backtracking on large files
- Cache expensive computations when possible

## Branch Strategy

### Branch Naming Conventions

Use these prefixes for all branches:

- `feature/*` - New features or enhancements (e.g., `feature/test-suite`)
- `bugfix/*` - Bug fixes (e.g., `bugfix/alias-alignment-multiline`)
- `refactor/*` - Code refactoring without behavior changes
- `docs/*` - Documentation updates only
- `test/*` - Test-related changes only

### Commit Message Conventions

**CRITICAL**: This project uses [Conventional Commits](https://www.conventionalcommits.org/) for automated changelog generation.

#### Format

```text
<type>: <description>

[optional body]
```

#### Required Types

- `feat:` - ✨ New features (e.g., `feat: Add MERGE statement formatting`)
- `fix:` - 🐛 Bug fixes (e.g., `fix: Prevent comment corruption with SQL keywords`)
- `docs:` - 📝 Documentation (e.g., `docs: Update README with new examples`)
- `test:` - 🧪 Testing (e.g., `test: Add idempotence tests for all examples`)
- `ci:` - 🤖 CI/CD changes (e.g., `ci: Add automated release workflow`)
- `refactor:` - ♻️ Code refactoring (e.g., `refactor: Extract comment parsing logic`)
- `chore:` - 🔧 Maintenance (e.g., `chore: Bump version to 0.0.4`)
- `perf:` - ⚡ Performance (e.g., `perf: Optimize regex patterns in lexer`)

#### Atomic Commits - One Logical Change Per Commit

**ALWAYS make commits atomic** - each commit should contain ONE logical change:

✅ **Good (Atomic):**

```bash
git commit -m "fix: Correct semicolon placement for first statement"
git commit -m "fix: Remove blank line after SELECT keyword"
git commit -m "docs: Update CHANGELOG for v0.0.3"
```

❌ **Bad (Multiple changes):**

```bash
git commit -m "fix: Multiple formatter issues and update docs"
```

#### Benefits of Atomic Commits

1. **Clean git history** - Easy to understand what changed and why
2. **Easy rollback** - Revert specific changes without affecting others
3. **Better code review** - Reviewers can understand each change independently
4. **Automated changelog** - Each commit becomes a clear changelog entry
5. **Easier debugging** - `git bisect` works better with focused commits

#### Commit Guidelines

1. **One logical change**: Fix one bug, add one feature, update one doc
2. **Present tense**: "Add feature" not "Added feature"
3. **Be specific**: "Fix alias alignment" not "Fix bug"
4. **Imperative mood**: "Change" not "Changes" or "Changed"
5. **No period at end**: `feat: Add feature` not `feat: Add feature.`
6. **Reference issues**: `fix: Correct indentation (#42)` when applicable

#### Examples

```bash
# Feature - one feature per commit
git commit -m "feat: Add window function formatting support"
git commit -m "feat: Implement QUALIFY clause handling"

# Bug fix - one fix per commit
git commit -m "fix: Prevent corruption of comments containing SELECT keyword"
git commit -m "fix: Correct indentation for nested CASE expressions"

# Documentation - one doc update per commit
git commit -m "docs: Add troubleshooting section to README"
git commit -m "docs: Update release checklist with new steps"

# Refactoring - one refactor per commit
git commit -m "refactor: Extract comment extraction to separate function"
git commit -m "refactor: Simplify regex pattern in clause structure pass"

# Testing - one test update per commit
git commit -m "test: Add test cases for CTE formatting"
git commit -m "test: Verify idempotence for all example files"

# Multiple related changes - use body
git commit -m "feat: Implement CASE expression breaking

- Breaks long CASE expressions across lines
- Aligns WHEN clauses consistently
- Preserves inline comments in CASE blocks"
```

#### When to Split Commits

Split commits when you've made changes to:

- ✅ Multiple formatter passes → Separate commit per pass
- ✅ Code + documentation → Separate commits
- ✅ Multiple bug fixes → Separate commit per bug
- ✅ Multiple features → Separate commit per feature
- ✅ Code + tests → Can be same commit if tightly coupled, otherwise split

#### Automated Changelog Generation

The release workflow automatically generates changelogs from commit messages:

- Collects all commits since last tag
- Groups by type (feat, fix, docs, etc.)
- Formats with emojis and sections
- Creates GitHub release notes

**Example auto-generated changelog:**

```markdown
## What's Changed

### ✨ Features
- Add window function formatting support
- Implement QUALIFY clause handling

### 🐛 Bug Fixes
- Prevent corruption of comments containing SELECT keyword
- Correct indentation for nested CASE expressions

### 📝 Documentation
- Add troubleshooting section to README
- Update release checklist with new steps
```

See `.github/COMMIT_CONVENTION.md` for complete guide.

### Workflow for New Features

```bash
# Create feature branch from main
git checkout main
git pull origin main
git checkout -b feature/<descriptive-name>

# Work incrementally with ATOMIC commits
# Each commit = one logical change
git add src/passes/06-new-feature.ts
git commit -m "feat: Add new formatting pass for feature X"

git add src/formatter.ts
git commit -m "feat: Integrate new formatting pass into pipeline"

git add examples/09-feature-test.sql
git commit -m "test: Add example file for feature X"

git add README.md
git commit -m "docs: Document new feature X in README"

# Push feature branch
git push origin feature/<descriptive-name>

# When complete, merge to main
git checkout main
git merge feature/<descriptive-name>
git push origin main

# Clean up branch
git branch -d feature/<descriptive-name>
git push origin --delete feature/<descriptive-name>
```

### Release Process (Automated)

```bash
# 1. Update version files
# Edit package.json: "version": "0.0.x"
# Edit README.md: version badge and download link
# Create docs/releases/v0.0.x/RELEASE_NOTES.md (optional)

# 2. Commit version bump
git add package.json README.md
git commit -m "chore: Bump version to 0.0.x"
git push origin main

# 3. Tag release (triggers automated workflow)
git tag -a v0.0.x -m "Release v0.0.x: Brief description"
git push origin v0.0.x

# The CI/CD workflow will automatically:
# - Run all tests
# - Verify version consistency
# - Generate changelog from conventional commits
# - Package extension
# - Create GitHub release with VSIX
```

See `docs/releases/QUICK_RELEASE.md` and `docs/releases/RELEASE_CHECKLIST.md` for details.

### Development Branches
- **`main`**: Production-ready code, tagged releases only
- **`develop`**: (Optional) Integration branch for multiple features
- **`feature/*`**: Individual feature development
- **`bugfix/*`**: Bug fixes

## Contributing

1. Create appropriate feature/bugfix branch with proper naming convention
2. Follow existing code patterns and style
3. Keep changes focused and minimal
4. **Use atomic commits** - one logical change per commit
5. **Use conventional commit messages** - `feat:`, `fix:`, `docs:`, etc.
6. **Test thoroughly** (see Testing section above)
7. Update documentation for user-facing changes
8. Ensure TypeScript compilation succeeds without errors
9. Verify all examples still format correctly
10. Run `npm run lint:fix` to ensure markdown is properly formatted

### Example Contribution Flow

```bash
# 1. Create feature branch
git checkout -b feature/add-qualify-support

# 2. Make changes with atomic commits
git add src/passes/12-qualify.ts
git commit -m "feat: Add QUALIFY clause formatting pass"

git add src/formatter.ts
git commit -m "feat: Integrate QUALIFY pass into formatter pipeline"

git add examples/10-qualify-test.sql
git commit -m "test: Add QUALIFY clause test examples"

git add README.md docs/development/PROJECT_SPEC.md
git commit -m "docs: Document QUALIFY clause support"

# 3. Test everything
npm run compile
node tests/test-examples.js

# 4. Push and create PR (if applicable)
git push origin feature/add-qualify-support

# 5. After approval, merge to main
git checkout main
git merge feature/add-qualify-support
git push origin main
```

## Testing Workflow (MANDATORY)

When making changes to formatting logic:
1. **Create feature branch**: `feature/<descriptive-name>`
2. **Make changes incrementally** with frequent commits
3. **Test against `examples/`** directory after each change
4. **Run execution safety tests** (when available)
5. **Verify idempotence** - format twice, compare
6. **Update tests** to cover new behavior
7. **Update documentation** if user-facing
8. **Merge to main** only after all tests pass

## Getting Help

- Review `docs/development/TESTING_PLAN.md` for comprehensive testing strategy
- Review `docs/development/PROJECT_SPEC.md` for detailed formatting rules
- Check `README.md` for user-facing feature documentation
- Examine existing passes in `src/passes/` for patterns
- Look at `src/formatter.ts` to understand pass orchestration
- Test with `examples/` directory for real-world cases

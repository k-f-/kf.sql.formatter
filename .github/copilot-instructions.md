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

- Currently, the project does not have automated tests
- When adding features, **manually test** with various SQL samples
- Test edge cases: empty files, single statements, multi-statement files, CTEs
- Verify formatting idempotence: format(format(text)) === format(text)

### Building

```bash
npm install        # Install dependencies
npm run compile    # Compile TypeScript to dist/
npm run watch      # Watch mode for development
npm run package    # Create .vsix extension package
```

### File Organization

- **Source code**: `src/` directory
- **Build output**: `dist/` (gitignored)
- **Configuration**: `package.json` (extension manifest and npm config)
- **TypeScript config**: `tsconfig.json`
- **Documentation**: `README.md`, `projectSpec.md`, `CHANGELOG.md`

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
4. Update `projectSpec.md` to document the new feature

#### Modifying Existing Pass

1. Understand the pass's purpose by reading its code and related tests
2. Make minimal changes - these passes are carefully tuned
3. Test with various SQL samples to ensure no regressions
4. Update documentation if behavior changes

#### Adding Configuration Options

1. Add to `package.json` under `contributes.configuration.properties`
2. Update TypeScript types in relevant modules
3. Document in `README.md` and `projectSpec.md`
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

## Contributing

1. Follow existing code patterns and style
2. Keep changes focused and minimal
3. Test thoroughly with various SQL samples
4. Update documentation for user-facing changes
5. Ensure TypeScript compilation succeeds without errors

## Getting Help

- Review `projectSpec.md` for detailed formatting rules
- Check `README.md` for user-facing feature documentation
- Examine existing passes in `src/passes/` for patterns
- Look at `src/formatter.ts` to understand pass orchestration

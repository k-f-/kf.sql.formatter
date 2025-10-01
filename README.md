
# Databricks SQL Formatter (Org Style)

A VS Code formatter for Databricks/Spark SQL that enforces your organization's formatting standards:

## ✨ Key Features

- **File-wide alias alignment**
  Aligns all `as alias` statements to a consistent column across the file (min gap: 8 spaces, smart cap: 120).

- **Global inline comment alignment**
  Aligns all inline comments (`--`) to a consistent column across the file, including:
  - SELECT lists
  - CASE blocks
  - Function argument lists
  - JOIN predicates
  - WHERE clauses
  - GROUP BY / ORDER BY clauses

- **Semantic aliasing (on-demand)**
  Adds meaningful aliases to expressions like:
  - `max(col)` → `as max_col`
  - `a + b` → `as a_plus_b`
  - `case when status = 'A' then 'Active' else 'Inactive' end` → `as case_active_inactive`

- **JOIN formatting**
  - Inline `ON` for single-condition joins (if short)
  - Multi-line `ON` for complex joins
  - `USING` clause breaks into multi-line when ≥ 2 columns

- **UPDATE / MERGE formatting**
  - Aligns `=` in `SET` lists
  - Breaks `WHEN MATCHED` / `WHEN NOT MATCHED` blocks
  - Preserves and aligns comments

- **CASE / OVER / long function breaking**
  - Multi-line CASE blocks
  - Multi-line `OVER(...)` clauses
  - Breaks long function calls into one argument per line

- **named_struct alignment**
  - Aligns keys and values inside `named_struct(...)` blocks

- **ORDER BY / GROUP BY formatting**
  - Single-item ORDER BY stays inline
  - Multi-item lists break into one-per-line with leading commas
  - Comments aligned

- **Semicolon handling**
  - Leading semicolon for statements 2..N (`;select`, `;with`)
  - No trailing semicolon on the last statement
  - CTE-safe: never inserts `;` between a `WITH` block and its attached clause

- **Whitespace and comment wrapping**
  - Trims trailing whitespace
  - Wraps long comments at 100 characters (configurable)

---

## ⚙️ Settings


{
  "databricksSqlFormatter.keywordCase": "lower",
  "databricksSqlFormatter.functionCase": "lower",
  "databricksSqlFormatter.indent": 4,
  "databricksSqlFormatter.leadingCommas": true,
  "databricksSqlFormatter.dialect": "spark",
  "databricksSqlFormatter.aliasAlignmentScope": "file",
  "databricksSqlFormatter.aliasMinGap": 8,
  "databricksSqlFormatter.aliasMaxColumnCap": 120,
  "databricksSqlFormatter.forceAsForAliases": "existingOnly",
  "databricksSqlFormatter.join.inlineSingleCondition": true,
  "databricksSqlFormatter.join.inlineMaxWidth": 100,
  "databricksSqlFormatter.using.multiLineThreshold": 2,
  "databricksSqlFormatter.semicolon.style": "leading-when-multi",
  "databricksSqlFormatter.semicolon.skipCommentLines": true,
  "databricksSqlFormatter.trimTrailingWhitespace": true,
  "databricksSqlFormatter.comment.wrapColumn": 100
}

# Folder Structure

databricks-sql-formatter/
├─ package.json
├─ tsconfig.json
├─ README.md
├─ CHANGELOG.md
├─ LICENSE
├─ .vscodeignore
├─ src/
│  ├─ extension.ts
│  ├─ formatter.ts
│  ├─ sqlLexer.ts
│  ├─ rules.ts
│  ├─ passes/
│  │  ├─ 01-clause-structure.ts
│  │  ├─ 02-leading-commas.ts
│  │  ├─ 03-breakers.ts
│  │  ├─ 04-namedstruct-align.ts
│  │  ├─ 05-alias-align.ts
│  │  ├─ 06-join-where-align.ts
│  │  ├─ 07-group-order-align.ts
│  │  ├─ 08-update-set-align.ts
│  │  ├─ 09-semicolons.ts
│  │  ├─ 10-trailing-ws.ts
│  │  ├─ 11-comment-wrap.ts
│  ├─ alias.ts
│  ├─ comments.ts
│  ├─ semicolons.ts
│  ├─ utils.ts
└─ syntaxes/
   └─ language-configuration.json

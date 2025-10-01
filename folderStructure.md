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

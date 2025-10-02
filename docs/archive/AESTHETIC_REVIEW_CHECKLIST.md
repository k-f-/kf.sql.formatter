# Example Files Aesthetic Review Checklist

## Instructions

For each example file:
1. Open in VS Code
2. Run **Format Document** (Shift+Option+F)
3. Review the formatted output
4. Check off items below
5. Document any issues found

---

## 01-basic-queries.sql (18 test cases)

### Formatting Checklist
- [ ] **Keyword casing**: All keywords in UPPER case
- [ ] **Function casing**: All functions in lower case
- [ ] **Leading commas**: Commas at start of line (`, column_name`)
- [ ] **Alias alignment**: AS keywords aligned within each SELECT
- [ ] **Indentation**: Consistent 2-space indentation
- [ ] **Comment alignment**: Inline comments aligned to right
- [ ] **Semicolons**: Leading semicolons for multi-statement blocks

### Test Cases to Review
- [ ] Single table, simple WHERE
- [ ] Multiple columns, ORDER BY
- [ ] Aggregate with GROUP BY
- [ ] WHERE clause
- [ ] DISTINCT
- [ ] Simple SELECT *
- [ ] Calculated columns
- [ ] BETWEEN predicate
- [ ] IN predicate
- [ ] LIKE predicate
- [ ] IS NULL / IS NOT NULL
- [ ] HAVING clause
- [ ] Multiple aggregates
- [ ] Short query (one-line optimization)
- [ ] Simple math in SELECT

### Issues Found
```
[Document any formatting problems here]
```

---

## 02-ctes-subqueries.sql (13 test cases)

### Formatting Checklist
- [ ] **CTE formatting**: WITH clause properly indented
- [ ] **CTE separation**: Blank line between CTEs
- [ ] **Subquery indentation**: Nested queries indented
- [ ] **Parentheses alignment**: Opening/closing parens aligned
- [ ] **No semicolons in CTEs**: Semicolon only at end

### Test Cases to Review
- [ ] Simple CTE
- [ ] Multiple CTEs
- [ ] CTE with JOIN
- [ ] Recursive CTE
- [ ] Nested subqueries
- [ ] Subquery in SELECT
- [ ] Subquery in WHERE
- [ ] Derived tables
- [ ] Correlated subqueries

### Issues Found
```
[Document any formatting problems here]
```

---

## 03-joins.sql (19 test cases)

### Formatting Checklist
- [ ] **JOIN alignment**: ON conditions aligned
- [ ] **Multiple conditions**: AND/OR aligned
- [ ] **USING clauses**: Parentheses and columns formatted
- [ ] **Join inline**: Short joins on one line (≤100 chars)
- [ ] **Join multiline**: Long joins broken properly

### Test Cases to Review
- [ ] INNER JOIN
- [ ] LEFT JOIN
- [ ] RIGHT JOIN
- [ ] FULL OUTER JOIN
- [ ] CROSS JOIN
- [ ] Multiple joins in sequence
- [ ] JOIN with USING clause
- [ ] Self-join
- [ ] JOIN with complex conditions

### Issues Found
```
[Document any formatting problems here]
```

---

## 04-expressions.sql (25+ test cases)

### Formatting Checklist
- [ ] **CASE statements**: WHEN/THEN/ELSE aligned
- [ ] **Window functions**: OVER clause formatted
- [ ] **PARTITION BY/ORDER BY**: Within OVER clause
- [ ] **Nested functions**: Properly indented
- [ ] **Long expressions**: Broken at operators

### Test Cases to Review
- [ ] Simple CASE
- [ ] Searched CASE
- [ ] Nested CASE
- [ ] Window function (ROW_NUMBER)
- [ ] Window function (SUM OVER)
- [ ] PARTITION BY
- [ ] Named window
- [ ] Nested functions
- [ ] CAST expressions
- [ ] String concatenation

### Issues Found
```
[Document any formatting problems here]
```

---

## 05-spark-specific.sql (30+ test cases)

### Formatting Checklist
- [ ] **named_struct**: Aligned key-value pairs
- [ ] **LATERAL VIEW**: Properly formatted
- [ ] **Array/Map functions**: Formatted correctly
- [ ] **Backtick identifiers**: Preserved
- [ ] **Spark keywords**: Recognized and formatted

### Test Cases to Review
- [ ] named_struct with alignment
- [ ] LATERAL VIEW EXPLODE
- [ ] Array functions
- [ ] Map functions
- [ ] Struct access
- [ ] Delta Lake syntax
- [ ] PIVOT
- [ ] UNPIVOT

### Issues Found
```
[Document any formatting problems here]
```

---

## 06-dml-ddl.sql (35+ test cases)

### Formatting Checklist
- [ ] **INSERT statements**: VALUES aligned
- [ ] **UPDATE statements**: SET clauses aligned
- [ ] **MERGE statements**: WHEN clauses formatted
- [ ] **CREATE TABLE**: Column definitions aligned
- [ ] **ALTER TABLE**: Operations formatted

### Test Cases to Review
- [ ] INSERT INTO ... VALUES
- [ ] INSERT INTO ... SELECT
- [ ] UPDATE with SET
- [ ] UPDATE with JOIN
- [ ] DELETE
- [ ] MERGE statement
- [ ] CREATE TABLE
- [ ] ALTER TABLE
- [ ] CREATE VIEW
- [ ] DROP statements

### Issues Found
```
[Document any formatting problems here]
```

---

## 07-comments-strings.sql (30+ test cases)

### Formatting Checklist
- [ ] **Block comments**: Preserved formatting
- [ ] **Inline comments**: Aligned to right
- [ ] **Comment wrapping**: Long comments wrapped at 100 chars
- [ ] **SQL in strings**: Not formatted
- [ ] **String literals**: Preserved exactly

### Test Cases to Review
- [ ] Single-line comments
- [ ] Multi-line comments
- [ ] Inline comments after code
- [ ] Comments in complex SQL
- [ ] String literals with SQL
- [ ] String literals with special chars
- [ ] Comments with special chars

### Issues Found
```
[Document any formatting problems here]
```

---

## 08-edge-cases.sql (50+ test cases)

### Formatting Checklist
- [ ] **Empty queries**: Handled gracefully
- [ ] **Very long lines**: Broken appropriately
- [ ] **Deep nesting**: Indented correctly
- [ ] **Mixed case**: Normalized to config
- [ ] **Unusual whitespace**: Cleaned up

### Test Cases to Review
- [ ] Empty SELECT
- [ ] Line >200 chars
- [ ] 10+ level nesting
- [ ] mIxEd CaSe keywords
- [ ] Tabs vs spaces
- [ ] Multiple consecutive blank lines
- [ ] Trailing whitespace
- [ ] CR/LF line endings

### Issues Found
```
[Document any formatting problems here]
```

---

## Summary

### Overall Assessment
- **Files reviewed**: __ / 8
- **Critical issues found**: __
- **Minor issues found**: __
- **Files passing all checks**: __

### Next Steps
1. [ ] Document all issues in GitHub Issues
2. [ ] Prioritize critical vs minor issues
3. [ ] Create bugfix branches for each issue
4. [ ] Re-test after fixes
5. [ ] Update TESTING_STATUS.md with results

# Clean Test Cases - Summary

## What We Created

**8 comprehensive test files** with 81 total test cases covering:

1. **01-simple-selects.sql** - Basic SELECT, WHERE, GROUP BY, ORDER BY
2. **02-joins.sql** - All JOIN types (INNER, LEFT, RIGHT, FULL, CROSS, self-join)
3. **03-ctes-subqueries.sql** - CTEs, recursive CTEs, correlated subqueries
4. **04-complex-expressions.sql** - CASE, window functions, nested functions
5. **05-dml-operations.sql** - INSERT, UPDATE, DELETE, MERGE
6. **06-spark-specific.sql** - named_struct, LATERAL VIEW, array/map functions
7. **07-comments-strings.sql** - Comment alignment, strings with SQL keywords
8. **08-edge-cases.sql** - Long lines, deep nesting, edge cases

## Test Results

✅ **All files formatted without crashes**
❌ **All files failed idempotence test**
❌ **Critical bug found: Comments are being corrupted**

## The Critical Bug

**Problem:** The formatter treats SQL keywords INSIDE COMMENTS as actual SQL code.

**Example:**
```sql
-- Input:
-- TC1.1: Basic SELECT with few columns

-- Output:
-- TC1.1: Basic
select with few columns
```

The word "SELECT" in the comment gets treated as a SQL keyword!

## Your Original Fixes ARE Working

On **simple SQL without keywords in comments**, your 4 fixes work perfectly:

✅ No unnecessary leading semicolon
✅ No blank line after SELECT
✅ Columns split with leading commas
✅ Comments aligned correctly

## The Problem

Pass `01-clause-structure.ts` uses regex patterns like:

```typescript
result.replace(/\bselect\b/gi, '\nselect ')
```

This matches "SELECT" **everywhere** - including inside comments!

## What to Do Next?

**Option 1:** Fix the comment handling
- Modify passes to skip text inside comments
- Add comment detection to regex patterns

**Option 2:** Use these test cases in VS Code
- Test with the Extension Development Host
- Format individual test cases manually
- Document which ones work vs which fail

Would you like me to help fix the comment handling issue, or would you prefer to test the working cases in VS Code first?

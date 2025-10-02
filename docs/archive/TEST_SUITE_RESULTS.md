# Test Suite Results Summary

## Date: October 2, 2025
## Branch: bugfix/formatter-core-issues

---

## 🎯 Test Execution

**Test Files Created:**
- ✅ 01-simple-selects.sql (10 test cases)
- ✅ 02-joins.sql (8 test cases)
- ✅ 03-ctes-subqueries.sql (8 test cases)
- ✅ 04-complex-expressions.sql (10 test cases)
- ✅ 05-dml-operations.sql (10 test cases)
- ✅ 06-spark-specific.sql (10 test cases)
- ✅ 07-comments-strings.sql (10 test cases)
- ✅ 08-edge-cases.sql (15 test cases)

**Total:** 81 clean test cases across 8 files

---

## 📊 Results

| Metric | Count | Status |
|--------|-------|--------|
| Total Files | 8 | ✅ |
| Successful Formatting | 8 | ✅ |
| Failed | 0 | ✅ |
| Idempotent | 0 | ❌ |
| Non-Idempotent | 8 | ❌ |

---

## 🐛 Critical Issues Found

### Issue #1: Comments Being Parsed as SQL Code

**Severity:** CRITICAL 🔴

**Description:**
The formatter treats SQL keywords **inside comments** as actual SQL keywords and breaks them onto new lines.

**Example:**

**Input:**
```sql
-- TC1.1: Basic SELECT with few columns (should split with leading commas)
SELECT user_id, first_name, last_name, email
FROM users
WHERE status = 'active';
```

**Output:**
```sql
-- TC1.1: Basic
select with few columns(should split
with leading commas)
select
  user_id
  ,first_name
  ,last_name
  ,email
from users
where status = 'active'
;
```

**Root Cause:**
Pass `01-clause-structure.ts` or another early pass is applying SQL keyword transformations to **all text**, including comment content.

**Impact:**
- Comments are corrupted
- SQL becomes syntactically invalid
- Multiple statements get merged
- Idempotence is broken

---

### Issue #2: Statements Being Merged

**Severity:** HIGH 🟠

**Description:**
Multiple SQL statements are being merged together, with semicolons appearing in unexpected locations.

**Example:**
Statements that should be separate are being combined with their preceding comments.

---

### Issue #3: Non-Idempotent Formatting

**Severity:** HIGH 🟠

**Description:**
Formatting the same SQL twice produces different results each time.

**Evidence:**
All 8 test files showed differences between first and second formatting pass.

**Example Differences:**
```
Line 3:
  1st: "select  Statements"
  2nd: "select   Statements"  (extra space added)
```

---

## ✅ What's Working

1. **Leading commas** - Working correctly when SQL is valid ✅
2. **Column splitting** - Columns are being split onto separate lines ✅
3. **No leading semicolon on first statement** - Fixed ✅
4. **Alias alignment** - Working when not disrupted by comment issues ✅

---

## 🔍 Root Cause Analysis

### Pass Execution Order

The formatter runs these passes in sequence:
1. `01-clause-structure.ts` - Puts SQL clauses on separate lines
2. `02-leading-commas.ts` - Converts to leading comma style
3. `03-breakers.ts` - Breaks CASE/OVER clauses
4. `04-namedstruct-align.ts` - Aligns named_struct calls
5. `05-alias-align.ts` - Aligns aliases and comments
6. `06-join-where-align.ts` - Aligns JOIN conditions
7. `07-group-order-align.ts` - Aligns GROUP BY/ORDER BY
8. `08-update-set-align.ts` - Aligns UPDATE SET
9. `09-semicolons.ts` - Handles semicolon placement
10. `10-trailing-ws.ts` - Removes trailing whitespace
11. `11-comment-wrap.ts` - Wraps long comments

### The Problem

**Pass 01 (clause-structure.ts)** appears to be:
- Using regex to find keywords like `SELECT`, `FROM`, `WHERE`
- Applying replacements to **the entire text** including comments
- Not preserving comment boundaries

**Evidence:**
```typescript
// Current behavior (problematic):
result = result.replace(/\bselect\b/gi, '\nselect ');

// This matches "SELECT" everywhere, even inside comments!
```

---

## 🛠️ Recommended Fixes

### Fix #1: Protect Comments Early

**Option A:** Add a "comment protection" pass before all other passes:
1. Extract all comments with placeholder tokens
2. Run formatting passes
3. Restore comments at the end

**Option B:** Make all regex patterns comment-aware:
- Skip matches inside `-- ...` (line comments)
- Skip matches inside `/* ... */` (block comments)

### Fix #2: Improve Idempotence

- Add test after each pass to ensure output is stable
- Identify which passes are non-idempotent
- Fix whitespace handling (extra spaces being added)

---

## 📋 Next Steps

### Immediate (Critical)

1. **Fix comment parsing** in `01-clause-structure.ts`
   - Option: Use proper SQL lexer instead of regex
   - Option: Add comment detection to regex patterns

2. **Test with minimal cases**
   - Create single-line SQL with comment
   - Verify comment is preserved exactly

### Short Term

3. **Fix idempotence issues**
   - Identify which pass adds extra whitespace
   - Add idempotence test to each pass

4. **Re-run test suite**
   - Verify all 81 test cases pass
   - Verify idempotence on all files

### Long Term

5. **Consider lexer-based approach**
   - Use proper SQL tokenization
   - Preserve exact token boundaries
   - Apply formatting transformations to token stream

---

## 📁 Files Generated

- `test-cases/*.sql` - 8 clean test input files (81 test cases)
- `test-cases/formatted/*.sql` - Formatted output (currently broken)
- `test-suite-results.txt` - Detailed test execution log
- `test-results.json` - Machine-readable results

---

## 🎓 Lessons Learned

1. **Regex-based SQL formatting is fragile** when comments contain SQL keywords
2. **Idempotence must be tested** after every code change
3. **Small, focused test cases** are essential for debugging
4. **Clean test data** is crucial - the existing examples were already corrupted

---

## 💡 Conclusion

The formatter **core fixes for issues #1-4 are working** when tested on simple, single-statement SQL. However, a **critical new issue** was discovered: the formatter doesn't properly handle comments containing SQL keywords.

**Priority:** Fix comment handling before continuing with additional features or testing.

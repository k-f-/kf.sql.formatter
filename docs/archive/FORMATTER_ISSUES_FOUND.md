# Formatter Issues Found - Aesthetic Review

**Date:** October 2, 2025
**Tester:** User manual review
**Method:** Extension Development Host (F5) with Format Document

---

## 🐛 Critical Issues

### Issue #1: Unnecessary Leading Semicolon on First Statement
**Severity:** Medium
**Location:** `src/passes/09-semicolons.ts`

**Current Behavior:**
```sql
-- Simple query to test formatting

;
select
```

**Expected Behavior:**
```sql
-- Simple query to test formatting
select
```

**Description:**
- First statement in file gets a leading semicolon
- Should only have leading semicolon when there are multiple statements
- Single statement files should have trailing semicolon only (or no semicolon)

**Config Setting:** `semicolonStyle: 'leading-when-multi'`

---

### Issue #2: Blank Line After SELECT Keyword
**Severity:** High
**Location:** `src/passes/01-clause-structure.ts` or `src/passes/02-leading-commas.ts`

**Current Behavior:**
```sql
select

  user_id, first_name, last_name
```

**Expected Behavior:**
```sql
select
  user_id
  , first_name
  , last_name
```

**Description:**
- There's an unwanted blank line between `select` and the column list
- Columns should start immediately on next line after SELECT
- Also note: commas aren't being converted to leading commas

---

### Issue #3: Leading Commas Not Applied
**Severity:** High
**Location:** `src/passes/02-leading-commas.ts`

**Current Behavior:**
```sql
select

  user_id, first_name, last_name, email, created_at
```

**Expected Behavior:**
```sql
select
  user_id
  , first_name
  , last_name
  , email
  , created_at
```

**Description:**
- Columns remain on one line with trailing commas
- Should break into multiple lines with leading commas
- Config setting `leadingCommas: true` not being applied

---

## ⚠️ Minor Issues

### Issue #4: Keywords Not Uppercased
**Severity:** Medium
**Location:** `src/passes/01-clause-structure.ts` or keyword casing logic

**Current Behavior:**
```sql
select
from customers
where country = 'US' and status = 'active'
order by created_at DESC
```

**Expected Behavior:**
```sql
SELECT
FROM customers
WHERE country = 'US' AND status = 'active'
ORDER BY created_at DESC
```

**Description:**
- Keywords remain lowercase instead of UPPERCASE
- Config setting: `keywordCase: 'upper'` not being applied
- Note: DESC is uppercase, but main keywords are not

**Affected Keywords:** `select`, `from`, `where`, `and`, `order by`

---

### Issue #5: Extra Blank Line at Top of File
**Severity:** Low
**Location:** Unknown - possibly `src/passes/01-clause-structure.ts`

**Current Behavior:**
```sql
-- Simple query to test formatting

;
```

**Expected Behavior:**
```sql
-- Simple query to test formatting
;
```

**Description:**
- Blank line inserted after first comment
- Minor aesthetic issue

---

## ✅ What's Working

1. **Trailing semicolon added** - Good!
2. **Keywords on separate lines** - `select`, `from`, `where`, `order by` each on own line
3. **File language detection** - Recognizes `.sql` files correctly
4. **Extension activation** - Activates properly in Extension Development Host
5. **Format Document integration** - Command Palette formatting works

---

## 🔍 Root Cause Analysis

### Hypothesis: Clause Structure Pass Issues

Looking at the expected flow:
1. ✅ Keywords normalized and split to lines (mostly working)
2. ❌ Leading commas pass not breaking columns apart
3. ❌ Semicolon logic adding leading `;` when shouldn't
4. ❌ Keyword casing not applied

**Likely culprits:**
- `src/passes/01-clause-structure.ts` - May be collapsing SELECT lists
- `src/passes/02-leading-commas.ts` - Not detecting/breaking column lists
- `src/utils.ts` - `normalizeKeywordCase()` not being called or applied correctly
- `src/passes/09-semicolons.ts` - Not detecting "first statement" correctly

---

## 📋 Testing Notes

**Test File:** `examples/test-clean.sql`

**Input:**
```sql
-- Simple query to test formatting
SELECT user_id, first_name, last_name, email, created_at
FROM customers
WHERE country = 'US' AND status = 'active'
ORDER BY created_at DESC
```

**Actual Output:**
```sql
-- Simple query to test formatting

;
select

  user_id, first_name, last_name, email, created_at
from customers
where country = 'US' and status = 'active'
order by created_at DESC
;
```

**Expected Output:**
```sql
-- Simple query to test formatting
SELECT
  user_id
  , first_name
  , last_name
  , email
  , created_at
FROM customers
WHERE country = 'US'
  AND status = 'active'
ORDER BY created_at DESC
;
```

---

## 🎯 Next Steps

1. **Fix Issue #2** (blank line after SELECT) - Highest priority
2. **Fix Issue #3** (leading commas not applied) - Highest priority
3. **Fix Issue #4** (keyword casing) - High priority
4. **Fix Issue #1** (unnecessary leading semicolon) - Medium priority
5. **Fix Issue #5** (extra blank line) - Low priority

**Recommendation:** Start by debugging `src/passes/02-leading-commas.ts` to see why columns aren't being split.

---

## 🔧 Debugging Commands

```bash
# Add console.log to passes to trace execution
# In src/formatter.ts, add logging:
console.log('After clauseStructurePass:', s);
console.log('After leadingCommasPass:', s);
console.log('After semicolonsPass:', s);

# Recompile and reload
npm run compile
# In Extension Development Host: Cmd+R
```

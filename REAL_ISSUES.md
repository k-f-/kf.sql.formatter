# Real Formatter Issues Found

**Date:** October 2, 2025
**Test File:** `examples/test-clean.sql`

## User-Reported Issues

### 1. ❌ Blank line added at top of file

- Unnecessary blank line appears after comment before semicolon

### 2. ❌ Unnecessary leading semicolon on first statement

- File starts with `;` when it's the only/first statement
- Should not have leading `;` for first statement
- Config: `semicolonStyle: 'leading-when-multi'`

### 3. ❌ Blank row after SELECT keyword

- Unwanted blank line between `select` and column list
- Columns should start immediately on next line

### 4. ❌ Columns not breaking to multiple lines

- All columns stay on one line: `user_id, first_name, last_name, email, created_at`
- Should break to one column per line with leading commas

## Test Case

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
select
  user_id
  , first_name
  , last_name
  , email
  , created_at
from customers
where country = 'US'
  and status = 'active'
order by created_at DESC
;
```

## Next Steps

Need to debug:

1. `src/passes/02-leading-commas.ts` - Why aren't columns being split?
2. `src/passes/01-clause-structure.ts` - Why is blank line added after SELECT?
3. `src/passes/09-semicolons.ts` - Why is leading `;` added to first statement?

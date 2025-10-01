# Databricks SQL Formatting Specification (Living Document)

_Last Updated: 2025-10-01_

---

## **1. Core Principles**
- **Dialect**: Spark/Databricks SQL
- **Keyword case**: `lower`
- **Function case**: `lower`
- **Identifiers**: Preserve as-is (including quotes/backticks)
- **Indentation**: 4 spaces
- **Leading commas**: Yes (SELECT lists, argument lists, IN lists)
- **Trailing whitespace**: Always trimmed
- **Comments**: Preserve text, align consistently (see section 7)

---

## **2. Alias Rules**
- Always enforce `as` for **existing aliases** (columns & sources)
- **File-wide alias alignment**:
  - Minimum gap: **8 spaces**
  - Smart cap: **120 columns**
- **On-demand auto-alias command**:
  - Adds aliases to everything missing
  - **Semantic naming**:
    - `max(col)` → `as max_col`
    - `a + b` → `as a_plus_b`
    - `case when status='A' then 'Active' else 'Inactive' end` → `as case_active_inactive`
    - `count(distinct claim_id)` → `as count_distinct_claim_id`
  - Collisions → append `_2`, `_3`
  - Reserved keywords → append `_col`

---

## **3. Statement Termination**
- **Single-statement file**: No semicolon at end
- **Multi-statement file**:
  - Leading semicolon for statements 2..N (`;select`, `;with`)
  - No space after `;`
  - No trailing semicolon on last statement
- **CTE safety**: Never insert `;` between a `with` block and its attached clause

---

## **4. SELECT Lists**
- One column per line
- Leading commas
- Align aliases to file-wide column
- Align inline comments after alias
- **CASE**: Always multi-line, comments aligned
- **Function args**: Break long calls, align comments
- **named_struct**: Internal alignment for keys and values

---

## **5. JOIN Rules**
- Always enforce `as` for table/subquery aliases
- Inline single-condition `ON` if short
- Multi-line for multiple conditions
- Align comments in predicates
- `USING`:
  - Single column → inline
  - ≥ 2 columns → multi-line, leading commas

---

## **6. WHERE / GROUP BY / ORDER BY**
- **WHERE**:
  - Multi-line for multiple conditions
  - Align comments
- **GROUP BY / ORDER BY**:
  - Multi-item → one per line, leading commas
  - Single-item ORDER BY → inline
  - Align comments in both clauses

---

## **7. Comment Alignment**
- **SELECT list**: After alias
- **CASE**: Align inside block
- **Function args**: Align after longest argument
- **JOIN / WHERE**: Align after longest condition
- **GROUP BY / ORDER BY**: Align after longest item
- Always ≥ 2 spaces before `--`

---

## **8. UPDATE / MERGE**
- `SET` list:
  - One assignment per line
  - Leading commas
  - Align `=` signs vertically
- `MERGE`:
  - Break `when matched` / `when not matched` blocks
  - Align comments in SET list

---

## **9. Examples**

### **Before**

select id -- primary key, sum(paid) as total from claims group by id order by total desc;

### **After**
select
    id                                                as id        -- primary key
   ,sum(paid)                                         as sum_paid  -- aggregated
from claims                                           as claims
group by
    id                                                -- primary key
order by sum_paid desc                                -- sort by sum

## **10. Config Options
<!-- {
  "aliasAlignmentScope": "file",
  "aliasMinGap": 8,
  "aliasMaxColumnCap": 120,
  "forceAsForAliases": "existingOnly",
  "join.inlineSingleCondition": true,
  "join.inlineMaxWidth": 100,
  "using.multiLineThreshold": 2,
  "semicolon.style": "leading-when-multi",
  "semicolon.skipCommentLines": true,
  "trimTrailingWhitespace": true
} -->

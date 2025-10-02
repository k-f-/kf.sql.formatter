# Testing the Formatter in VS Code (The Right Way!)

## Why Terminal Testing Isn't Enough

The formatter behaves differently when:
- Running as a VS Code extension (uses editor context, settings, etc.)
- Running via command line (uses default options, no editor integration)

**You MUST test in VS Code to see the real formatting behavior!**

---

## 🚀 Quick Test Guide

### Method 1: Test in Extension Development Host (Recommended)

1. **Open the project in VS Code**
   ```bash
   code /Users/kef/Documents/Code/kf.sql.formatter
   ```

2. **Press F5** to launch Extension Development Host
   - This opens a new VS Code window with your extension loaded
   - Any changes you make to the code will be reflected after recompiling

3. **In the Extension Development Host window**:
   - Open `examples/test-simple.sql`
   - Press `Shift+Option+F` (Mac) or `Shift+Alt+F` (Windows/Linux)
   - **Watch the file get formatted in the editor!**

4. **Review the formatted result** in the editor

5. **Make changes and reload**:
   - Edit formatter code in main window
   - Run `npm run compile` in terminal
   - In Extension Development Host: `Cmd+R` (Mac) or `Ctrl+R` (Windows) to reload
   - Format again to see changes

---

### Method 2: Install Extension Locally

1. **Package the extension**:
   ```bash
   npm run compile
   npm run package
   ```

2. **Install the .vsix file**:
   - In VS Code: View → Extensions
   - Click "..." menu → Install from VSIX
   - Select `kf-sql-formatter-0.0.2.vsix`

3. **Test**:
   - Open any `.sql` file
   - Right-click → Format Document
   - Or press `Shift+Option+F`

4. **Uninstall when done**:
   - Extensions → Find "KF SQL Formatter" → Uninstall

---

## 📋 What to Test

### Test Files (in order)

1. ✅ **examples/test-simple.sql** - Very basic query
2. ✅ **examples/01-basic-queries.sql** - 18 basic test cases
3. ✅ **examples/02-ctes-subqueries.sql** - CTEs and subqueries
4. ✅ **examples/03-joins.sql** - JOIN formatting
5. ✅ **examples/04-expressions.sql** - CASE, window functions
6. ✅ **examples/05-spark-specific.sql** - Spark/Databricks features
7. ✅ **examples/06-dml-ddl.sql** - INSERT, UPDATE, MERGE, etc.
8. ✅ **examples/07-comments-strings.sql** - Comment handling
9. ✅ **examples/08-edge-cases.sql** - Edge cases

### What to Look For

#### ✅ Good Formatting:
```sql
SELECT
  user_id
  , first_name
  , last_name
  , email           AS user_email
  , created_at      AS registration_date
FROM customers
WHERE country = 'US'
  AND status = 'active'
ORDER BY created_at DESC
;
```

#### ❌ Problems to Report:
- Keywords not in UPPER case
- Functions not in lower case
- Trailing commas instead of leading
- Aliases not aligned
- Inconsistent indentation
- Comments misplaced or wrapped incorrectly
- Semicolons in wrong places

---

## 🐛 Known Issue: One-Line Collapse

**Current Behavior**: Queries ≤100 characters without aliases get collapsed to one line:
```sql
SELECT id, name, email FROM users WHERE status = 'active';
```

**This may be intentional** for very short queries, but we should verify if this is the desired behavior.

**To test full formatting**: Use queries with aliases or >100 characters.

---

## 📝 Recording Your Findings

Use `AESTHETIC_REVIEW_CHECKLIST.md` to track:
- [ ] Which files you've tested
- [ ] What formatting looks good
- [ ] What issues you found
- [ ] Screenshots of problems (if helpful)

---

## 🔄 Workflow

```
┌─────────────────────────────────────┐
│ 1. Press F5 in main VS Code window  │
│    (Launches Extension Dev Host)    │
└──────────┬──────────────────────────┘
           ↓
┌─────────────────────────────────────┐
│ 2. Open SQL file in Dev Host        │
│    (e.g., examples/test-simple.sql) │
└──────────┬──────────────────────────┘
           ↓
┌─────────────────────────────────────┐
│ 3. Format: Shift+Option+F           │
│    (Watch it format in editor!)     │
└──────────┬──────────────────────────┘
           ↓
┌─────────────────────────────────────┐
│ 4. Review formatted result          │
│    (Check alignment, casing, etc.)  │
└──────────┬──────────────────────────┘
           ↓
┌─────────────────────────────────────┐
│ 5. Found an issue?                  │
│    → Document in checklist          │
│    → Optionally create GitHub issue │
└──────────┬──────────────────────────┘
           ↓
┌─────────────────────────────────────┐
│ 6. Fix code in main window          │
│    → npm run compile                │
│    → Reload Dev Host (Cmd+R)        │
│    → Test again                     │
└─────────────────────────────────────┘
```

---

## 🎯 Today's Goal

**Aesthetic Review of Example Files**

- [ ] Launch Extension Development Host (F5)
- [ ] Format each example file
- [ ] Document aesthetic quality
- [ ] List any formatting bugs
- [ ] Check idempotence (format twice, should be same)

**Expected Time**: 30-60 minutes for all 8 files

---

## Next Steps After Review

1. **Create GitHub Issues** for any bugs found
2. **Update TESTING_STATUS.md** with review results
3. **Fix critical formatting bugs** (if any)
4. **Move to Phase 2**: Execution safety testing

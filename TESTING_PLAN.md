# KF SQL Formatter - Testing & Quality Assurance Plan

## 🎯 Primary Objectives

1. **Aesthetic Validation**: Ensure formatting meets visual/organizational standards
2. **Execution Safety**: Guarantee formatted SQL remains 100% executable
3. **Idempotence**: Verify format(format(x)) === format(x)
4. **Edge Case Coverage**: Test all documented features and edge cases

---

## 📋 Testing Strategy

### Phase 1: Example Suite Development
**Branch**: `feature/test-suite`
**Status**: 🔄 In Progress

#### 1.1 Create Comprehensive SQL Examples
Create test files covering:

- **Basic Queries** (`examples/01-basic-queries.sql`)
  - Simple SELECT statements
  - Single and multi-table queries
  - WHERE, GROUP BY, ORDER BY combinations
  
- **CTEs and Subqueries** (`examples/02-ctes-subqueries.sql`)
  - Single and nested CTEs
  - Correlated subqueries
  - CTE with multiple references
  
- **Joins** (`examples/03-joins.sql`)
  - INNER, LEFT, RIGHT, FULL OUTER
  - Self-joins
  - Multiple join conditions
  - USING clause with various column counts
  
- **Complex Expressions** (`examples/04-expressions.sql`)
  - CASE statements (simple and searched)
  - Window functions (OVER clauses)
  - Nested functions
  - Arithmetic and string operations
  
- **Spark/Databricks Specific** (`examples/05-spark-specific.sql`)
  - named_struct()
  - Backtick identifiers
  - Table-valued functions
  - LATERAL VIEW
  
- **DML/DDL** (`examples/06-dml-ddl.sql`)
  - INSERT, UPDATE, DELETE
  - MERGE statements
  - CREATE TABLE
  - ALTER TABLE
  
- **Comments and Strings** (`examples/07-comments-strings.sql`)
  - Inline comments
  - Block comments
  - SQL keywords in strings
  - SQL keywords in comments
  
- **Edge Cases** (`examples/08-edge-cases.sql`)
  - Empty queries
  - Very long lines
  - Deeply nested expressions
  - Mixed case keywords
  - Unusual whitespace

#### 1.2 Manual Aesthetic Review
For each example:
- [ ] Format the SQL
- [ ] Review alignment (aliases, comments, operators)
- [ ] Check indentation consistency
- [ ] Verify leading commas
- [ ] Confirm keyword casing
- [ ] Document any aesthetic issues found

---

### Phase 2: Execution Safety Testing
**Branch**: `feature/execution-tests`
**Status**: 📅 Planned

#### 2.1 Pre/Post Execution Comparison
**Goal**: Prove formatted SQL produces identical results

**Approach**:
1. Set up test database (SQLite for compatibility, or Spark local)
2. Create test dataset with known results
3. For each example:
   - Execute original SQL → capture result
   - Format SQL with our formatter
   - Execute formatted SQL → capture result
   - Assert results are identical (row count, data, column order)

**Test Script** (`tests/execution-safety.py` or `.ts`):
```python
# Pseudocode
for sql_file in examples:
    original = read_file(sql_file)
    formatted = format_sql(original)
    
    result_original = execute_sql(original)
    result_formatted = execute_sql(formatted)
    
    assert result_original == result_formatted
    assert parse_sql(formatted) is valid  # Syntax check
```

#### 2.2 SQL Syntax Validation
- Use SQL parser library to validate syntax
- Options: 
  - `sql-parser` (JS/TS)
  - `sqlparse` (Python)
  - Spark SQL parser (if available)
- Ensure no syntax errors introduced

#### 2.3 Regression Testing
- Save formatted outputs as "golden files"
- On code changes, re-format and diff against golden files
- Flag any unexpected changes

---

### Phase 3: Idempotence Testing
**Branch**: `feature/idempotence-tests`
**Status**: 📅 Planned

#### 3.1 Double Format Test
For each example:
```typescript
const once = format(original);
const twice = format(once);
assert(once === twice, "Formatting is not idempotent");
```

#### 3.2 Multi-Pass Stability
Test up to 5 passes to ensure stability:
```typescript
let result = original;
for (let i = 0; i < 5; i++) {
    const next = format(result);
    if (i > 0) {
        assert(next === result, `Changed on pass ${i+1}`);
    }
    result = next;
}
```

---

### Phase 4: Edge Case & Error Handling
**Branch**: `feature/error-handling`
**Status**: 📅 Planned

#### 4.1 Malformed SQL Handling
Test formatter behavior with:
- Unclosed quotes
- Unclosed parentheses
- Invalid keywords
- Truncated statements

**Expected Behavior**: 
- Option A: Return original (fail gracefully)
- Option B: Format best-effort, warn user
- Option C: Throw clear error message

#### 4.2 Large File Performance
- Test with files 1MB+, 10MB+
- Measure formatting time
- Ensure no crashes or freezes

#### 4.3 Unicode and Special Characters
- Test with emoji in comments
- Non-ASCII characters in strings
- Various line endings (LF, CRLF)

---

### Phase 5: Automated Testing Infrastructure
**Branch**: `feature/test-automation`
**Status**: 📅 Planned

#### 5.1 Unit Tests for Each Pass
Create tests for individual passes:
- `tests/passes/01-clause-structure.test.ts`
- `tests/passes/02-leading-commas.test.ts`
- etc.

Each test:
- Input SQL
- Expected output
- Configuration options tested

#### 5.2 Integration Tests
Test full formatting pipeline:
- `tests/integration/format-document.test.ts`
- Test with various config combinations

#### 5.3 CI/CD Integration
Update `.github/workflows/ci.yml`:
```yaml
- name: Run Tests
  run: npm test

- name: Check Test Coverage
  run: npm run test:coverage

- name: Validate Examples
  run: npm run test:examples
```

---

## 🌿 Branch Strategy

### Main Branches
- **`main`**: Production-ready code, tagged releases
- **`develop`**: Integration branch for features

### Feature Branches
Use naming convention: `feature/<name>`
- `feature/test-suite` - Example SQL files
- `feature/execution-tests` - Execution safety validation
- `feature/idempotence-tests` - Idempotence checks
- `feature/error-handling` - Malformed SQL handling
- `feature/test-automation` - Automated test infrastructure

### Bug Fix Branches
Use naming convention: `bugfix/<issue>`
- `bugfix/alias-alignment-multiline`
- `bugfix/cte-semicolon-safety`

### Workflow
```bash
# Create feature branch from main
git checkout main
git pull origin main
git checkout -b feature/test-suite

# Work on feature, commit frequently
git add .
git commit -m "feat: add basic query examples"

# Push to remote
git push origin feature/test-suite

# When ready, merge to main (or create PR)
git checkout main
git merge feature/test-suite
git push origin main
```

---

## 🔧 Implementation Priorities

### Priority 1 (This Week): Example Suite
- [x] Create examples/ directory
- [ ] Write 01-basic-queries.sql
- [ ] Write 02-ctes-subqueries.sql
- [ ] Write 03-joins.sql
- [ ] Write 04-expressions.sql
- [ ] Write 05-spark-specific.sql
- [ ] Write 06-dml-ddl.sql
- [ ] Write 07-comments-strings.sql
- [ ] Write 08-edge-cases.sql
- [ ] Manual aesthetic review of each

### Priority 2 (Next Week): Execution Safety
- [ ] Set up test database environment
- [ ] Write execution test script
- [ ] Run all examples through execution tests
- [ ] Document any execution-breaking bugs
- [ ] Fix critical bugs

### Priority 3: Automation
- [ ] Set up Jest or Mocha test framework
- [ ] Write unit tests for each pass
- [ ] Write integration tests
- [ ] Add test commands to package.json
- [ ] Update CI/CD to run tests

### Priority 4: Documentation
- [ ] Document all test cases
- [ ] Create CONTRIBUTING.md with testing guidelines
- [ ] Update README with testing section
- [ ] Add test coverage badge

---

## 📊 Success Criteria

### Aesthetic Quality
- ✅ All aliases aligned consistently
- ✅ All inline comments aligned consistently
- ✅ Keywords cased correctly (lower/upper per config)
- ✅ Indentation consistent (4 spaces default)
- ✅ Leading commas formatted correctly
- ✅ No trailing whitespace

### Execution Safety
- ✅ 100% of examples execute successfully before formatting
- ✅ 100% of examples execute successfully after formatting
- ✅ Results identical before/after formatting
- ✅ No syntax errors introduced

### Idempotence
- ✅ format(format(x)) === format(x) for all examples
- ✅ No oscillation between formats

### Code Quality
- ✅ 80%+ test coverage
- ✅ All tests passing in CI
- ✅ No linter errors
- ✅ TypeScript strict mode compliance

---

## 🤖 AI Agent Preferences

Add to `.github/copilot-instructions.md`:

```markdown
## Testing Workflow

When making changes to formatting logic:
1. Create a feature branch: `feature/<descriptive-name>`
2. Make changes incrementally
3. Test against examples/ directory
4. Run execution safety tests (when available)
5. Verify idempotence
6. Update tests to cover new behavior
7. Update documentation
8. Create PR or merge to main

## Branch Naming Conventions
- `feature/*` - New features or enhancements
- `bugfix/*` - Bug fixes
- `refactor/*` - Code refactoring
- `docs/*` - Documentation updates
- `test/*` - Test-related changes

## Before Committing
- [ ] Run formatter on all examples/
- [ ] Check for execution-breaking changes
- [ ] Verify idempotence
- [ ] Update tests if behavior changed
- [ ] Update documentation if user-facing change
```

---

## 🎬 Next Steps

1. **Immediate**: Create comprehensive example SQL files
2. **Today**: Begin manual aesthetic review
3. **This Week**: Set up execution safety testing framework
4. **Next Week**: Implement automated testing
5. **Ongoing**: Maintain test suite as features added

Would you like me to start creating the example SQL files now?

# Release Notes - v0.0.3

## 🐛 Critical Bug Fixes

This release addresses **6 critical formatting bugs** discovered during comprehensive testing:

### 1. **Comment Corruption (CRITICAL)** 🔴
- **Problem**: Comments containing SQL keywords were being treated as actual SQL code
  - Example: `-- This SELECT statement...` would corrupt into `-- This\nSELECT statement...`
- **Solution**: Implemented comment extraction/restoration system
  - Comments are replaced with placeholders before keyword processing
  - Restored after all transformations complete
  - Preserves 100% of comment content integrity

### 2. **Leading Semicolons**
- **Problem**: First SQL statement in file had unnecessary leading semicolon
- **Solution**: Added first-statement tracking to semicolon pass
- **Result**: Clean formatting without leading `;` on first statement

### 3. **Blank Lines After SELECT**
- **Problem**: Extra blank line inserted after SELECT keyword
- **Solution**: Changed clause structure regex from `\nselect\n` to `\nselect`
- **Result**: Compact, clean SELECT statement formatting

### 4. **Column List Splitting**
- **Problem**: Comma-separated columns on same line weren't being split
- **Solution**: Added column splitting logic to leading-commas pass
- **Result**: Each column on separate line with proper leading comma

### 5. **Comment Alignment**
- **Problem**: Standalone comments affected alias alignment calculations
- **Solution**: Skip standalone comment lines when calculating max width
- **Result**: Proper alignment based on actual code, not comments

### 6. **Idempotence**
- **Problem**: Formatting was not stable (format twice ≠ same result)
- **Solution**: All above fixes combined ensure stable formatting
- **Result**: ✅ **100% idempotent** across all 8 test files

## ✅ Testing

- **8 example files** covering all SQL features tested
- **81 test cases** across various SQL scenarios
- **100% success rate** with full idempotence
- All files format correctly and remain executable

## 📦 Installation

```bash
code --install-extension kf-sql-formatter-0.0.3.vsix
```

Or manually install through VS Code:
1. Open Extensions view (Cmd+Shift+X)
2. Click "..." menu → "Install from VSIX..."
3. Select `kf-sql-formatter-0.0.3.vsix`

## 🔄 Upgrading from v0.0.2

This release is **100% backward compatible**. Simply install the new version and your existing SQL files will format correctly without corruption.

## 🎯 What's Next

- Performance optimizations for large files
- Additional SQL dialect support
- Enhanced configuration options
- VS Code marketplace publication

---

**Full Changelog**: See [CHANGELOG.md](CHANGELOG.md)

# Quick Release Guide

## 🚀 How to Release (Automated)

### 1. Prepare Release (Optional: Custom Release Notes)

```bash
# Option A: Create custom release notes (recommended for major releases)
cat > RELEASE_NOTES_vX.X.X.md << 'EOF'
## 🎯 Highlights

Brief description of major changes...

## 🐛 Bug Fixes
- Fixed issue with...

## ✨ New Features
- Added support for...
EOF

# Option B: Let automation generate changelog from commits (automatic)
# Just use conventional commit messages:
#   feat: Add new feature
#   fix: Fix bug
#   docs: Update documentation
#   chore: Maintenance work
```

### 2. Update Version Files

```bash
# Update version in package.json (REQUIRED)
# Update version badge in README.md: version-X.X.X-blue (REQUIRED)
# Update download link in README.md: /releases/download/vX.X.X/... (REQUIRED)
# Update CHANGELOG.md (recommended)
```

### 3. Commit Changes

```bash
git add package.json README.md RELEASE_NOTES_vX.X.X.md CHANGELOG.md
git commit -m "chore: Bump version to X.X.X"
git push origin main
```

### 3. Tag and Release

```bash
git tag -a vX.X.X -m "Release vX.X.X: Brief description"
git push origin vX.X.X
```

**That's it!** The GitHub Actions workflow will automatically:

- ✅ Run all tests
- ✅ Verify version consistency
- ✅ Compile TypeScript
- ✅ Package the extension
- ✅ **Generate changelog from commits** (if no RELEASE_NOTES_vX.X.X.md)
- ✅ Create GitHub release
- ✅ Attach VSIX file

### Automatic Changelog Generation

If you don't provide a `RELEASE_NOTES_vX.X.X.md` file, the workflow will automatically:

1. **Analyze commits** since the last tag
2. **Group by type** using conventional commit prefixes:
   - `feat:` → ✨ Features
   - `fix:` → 🐛 Bug Fixes
   - `docs:` → 📝 Documentation
   - `test:` → 🧪 Testing
   - `ci:` → 🤖 CI/CD
   - `chore:` → 🔧 Maintenance
   - `refactor:` → ♻️ Refactoring
3. **Generate formatted changelog** with emojis
4. **Add installation instructions**

**Example generated changelog:**

```markdown
## What's Changed

### ✨ Features
- Add support for new SQL syntax

### 🐛 Bug Fixes
- Fix comment parsing issue
- Correct indentation for nested queries

### 📝 Documentation
- Update README with new examples

## 📦 Installation
...
```

### 4. Monitor

Watch the workflow: https://github.com/k-f-/kf.sql.formatter/actions

### 5. Verify

Once complete, check: https://github.com/k-f-/kf.sql.formatter/releases/latest

---

## What the Workflow Validates

- ❌ **BLOCKS release if tests fail**
- ❌ **BLOCKS if package.json version ≠ tag version**
- ❌ **BLOCKS if README.md version badge not updated**
- ❌ **BLOCKS if README.md download link not updated**
- ❌ **BLOCKS if markdown lint fails**
- ❌ **BLOCKS if TypeScript compilation fails**

---

## Example: Releasing v0.0.4

```bash
# 1. Update files
# Edit package.json: "version": "0.0.4"
# Edit README.md: version-0.0.4-blue
# Edit README.md: /releases/download/v0.0.4/kf-sql-formatter-0.0.4.vsix
# Create RELEASE_NOTES_v0.0.4.md

# 2. Commit
git add .
git commit -m "chore: Bump version to 0.0.4"
git push origin main

# 3. Tag
git tag -a v0.0.4 -m "Release v0.0.4: New features"
git push origin v0.0.4

# 4. Wait ~2-3 minutes for workflow to complete
# 5. Check https://github.com/k-f-/kf.sql.formatter/releases/tag/v0.0.4
```

---

**For detailed checklist**: See [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md)

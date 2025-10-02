# Release Checklist

Use this checklist for every release to ensure all artifacts are properly updated.

## 🤖 Automated by CI/CD

The following items are **automatically verified** by the Release workflow (`.github/workflows/release.yml`):

- ✅ All tests passing
- ✅ TypeScript compilation successful
- ✅ Markdown linting passes
- ✅ `package.json` version matches git tag
- ✅ `README.md` version badge updated
- ✅ `README.md` download link updated
- ✅ VSIX package created
- ✅ GitHub release created with VSIX attachment

**To trigger automated release**: Just push a version tag!

```bash
git tag -a v0.0.4 -m "Release v0.0.4: Description"
git push origin v0.0.4
```

The workflow will handle the rest! 🎉

---

## 📋 Manual Pre-Release Checklist

Before pushing the tag, ensure these are done locally:

- [ ] All tests passing (`node test-examples-formatter.js`)
- [ ] All changes committed to main branch
- [ ] Branch cleanup completed (delete merged feature branches)

## Version Updates

- [ ] Update `package.json` version number
- [ ] Update `README.md`:
  - [ ] Version badge (`![Version](https://img.shields.io/badge/version-X.X.X-blue)`)
  - [ ] Download link (`Download Latest Release (vX.X.X)`)
  - [ ] Download URL (`/releases/download/vX.X.X/kf-sql-formatter-X.X.X.vsix`)
- [ ] Update `CHANGELOG.md` with release notes
- [ ] Create `RELEASE_NOTES_vX.X.X.md` with detailed notes
- [ ] Create `RELEASE_SUMMARY_vX.X.X.md` (optional, for internal tracking)

## Build & Package

- [ ] Compile TypeScript: `npm run compile`
- [ ] Run linter: `npm run lint` (fix any issues with `npm run lint:fix`)
- [ ] Package extension: `npm run package`
- [ ] Verify `.vsix` file created: `ls -lh kf-sql-formatter-X.X.X.vsix`

## Git Operations

- [ ] Commit all version updates
- [ ] Push commits: `git push origin main`
- [ ] Tag the release: `git tag -a vX.X.X -m "Release vX.X.X: <description>"`
- [ ] **Push tag to trigger automated release**: `git push origin vX.X.X`

## 🤖 Automated by Workflow

Once you push the tag, the GitHub Actions workflow will automatically:

1. ✅ Verify all tests pass
2. ✅ Verify version consistency (package.json, README.md)
3. ✅ Compile TypeScript
4. ✅ Package the extension (.vsix)
5. ✅ Create GitHub release
6. ✅ Attach VSIX file to release
7. ✅ Use RELEASE_NOTES_vX.X.X.md if available

**Monitor the workflow**: https://github.com/k-f-/kf.sql.formatter/actions

## Post-Release (Manual)

- [ ] Test installation from VSIX: `code --install-extension kf-sql-formatter-X.X.X.vsix`
- [ ] Verify extension works in VS Code
- [ ] Delete old `.vsix` files (optional, keep last 2-3 versions)
- [ ] Delete merged feature/bugfix branches:
  - [ ] Local: `git branch -d <branch-name>`
  - [ ] Remote: `git push origin --delete <branch-name>`

## Common Pitfalls to Avoid

- ❌ **Don't forget to update README.md version references**
- ❌ **Don't leave failing CI badges in README**
- ❌ **Don't package before updating package.json version**
- ❌ **Don't forget to push the git tag**
- ❌ **Don't create GitHub release without the .vsix file**

## Version Number Guide

- **Patch (0.0.X)**: Bug fixes, no new features
- **Minor (0.X.0)**: New features, backward compatible
- **Major (X.0.0)**: Breaking changes

---

**Last Updated**: October 2, 2025

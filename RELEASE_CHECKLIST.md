# Release Checklist

Use this checklist for every release to ensure all artifacts are properly updated.

## Pre-Release

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
- [ ] Tag the release: `git tag -a vX.X.X -m "Release vX.X.X: <description>"`
- [ ] Push commits: `git push origin main`
- [ ] Push tag: `git push origin vX.X.X`

## GitHub Release

- [ ] Create GitHub release:

  ```bash
  gh release create vX.X.X \
    --title "vX.X.X - <Title>" \
    --notes-file RELEASE_NOTES_vX.X.X.md \
    kf-sql-formatter-X.X.X.vsix
  ```

- [ ] Verify release on GitHub: `gh release view vX.X.X`
- [ ] Check download link works in README

## Post-Release

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

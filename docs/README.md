# Documentation Structure

This directory contains all project documentation organized by category.

## Directory Structure

### `/development/`

Development documentation for contributors and maintainers:

- **`PROJECT_SPEC.md`** - Comprehensive formatting specification
  - Detailed rules for each formatting pass
  - Configuration options and behavior
  - SQL dialect specifics (Databricks/Spark)

- **`TESTING_PLAN.md`** - Testing strategy and guidelines
  - Testing requirements for all changes
  - Test file descriptions
  - Idempotence validation approach
  - Execution safety considerations

- **`TESTING_IN_VSCODE.md`** - Manual testing guide
  - How to test the extension in VS Code
  - Extension Development Host setup
  - Debugging techniques

- **`TROUBLESHOOTING.md`** - Debugging guide
  - Common issues and solutions
  - Debugging formatter passes
  - Performance considerations

- **`MARKDOWN_LINTING.md`** - Markdown quality standards
  - Linting setup and configuration
  - Pre-commit hook details
  - Troubleshooting linting issues

### `/releases/`

Release documentation and process:

- **`RELEASE_CHECKLIST.md`** - Complete release process
  - Pre-release checklist
  - Manual steps
  - Automated workflow details
  - Post-release verification

- **`QUICK_RELEASE.md`** - Quick reference guide
  - Essential release steps
  - Auto-changelog explanation
  - Common release tasks

- **`v0.0.X/`** - Version-specific documentation
  - `RELEASE_NOTES.md` - User-facing release notes
  - `SUMMARY.md` - Technical release summary

### `/archive/`

Historical and legacy documentation:

- Planning documents
- Issue tracking (superseded by GitHub Issues)
- Temporary analysis files
- Obsolete documentation
- Templates and experiments

## Quick Reference

### For Contributors

Start here:

1. Read `README.md` (root directory) - User-facing features
2. Review `development/PROJECT_SPEC.md` - Formatting rules
3. Check `development/TESTING_PLAN.md` - Testing requirements
4. Follow `.github/copilot-instructions.md` - Development guidelines

### For Releases

Release checklist:

1. Review `releases/RELEASE_CHECKLIST.md` - Full process
2. Use `releases/QUICK_RELEASE.md` - Quick steps
3. Create `releases/v0.0.X/RELEASE_NOTES.md` - Optional custom notes
4. Tag release - Automated workflow handles the rest

### For Debugging

Troubleshooting:

1. Check `development/TROUBLESHOOTING.md` - Common issues
2. Review `development/TESTING_IN_VSCODE.md` - Manual testing
3. Examine test files in `tests/` directory
4. Look at `examples/` for test cases

## Documentation Standards

All documentation follows:

- **Markdown linting** - Automated via pre-commit hook
- **Conventional commits** - For documentation changes use `docs:` prefix
- **Clear structure** - Headings, lists, code blocks
- **Examples** - Include code samples where helpful
- **Links** - Use relative paths between docs

## Maintenance

Documentation should be:

- ✅ Updated when features change
- ✅ Kept concise and scannable
- ✅ Organized by category (development, releases, archive)
- ✅ Versioned for releases (in `releases/v0.0.X/`)
- ✅ Linted before commit (automatic)

## Archive Policy

Move to `archive/` when:

- Document is no longer actively used
- Information is superseded by newer docs
- Planning/analysis phase is complete
- Document is historical reference only

Keep in active directories when:

- Actively referenced by contributors
- Part of development workflow
- Required for releases
- Current version documentation

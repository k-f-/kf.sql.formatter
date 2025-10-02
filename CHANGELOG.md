# Changelog

## [0.0.3] - 2025-10-02

### Fixed
- **Critical**: Comments containing SQL keywords (e.g., "-- SELECT ...") are no longer corrupted during formatting
- Leading semicolons no longer added before first SQL statement
- Removed erroneous blank line after SELECT keyword
- Column lists now properly split onto separate lines
- Standalone comments no longer affect alias alignment calculations
- All formatter passes now preserve idempotence (format twice = same result)

### Added
- Comment extraction/restoration system to protect comments during keyword processing
- Comprehensive test suite with 8 example files covering all SQL features
- Test automation scripts for idempotence validation

## [0.0.2] - 2025-10-02

### Added
- Initial formatter implementation with 11 sequential passes

## [0.0.1] - 2025-10-02

### Added
- 

# Changelog

## [0.1.0] - Initial Release
- Added full support for Databricks SQL formatting
- File-wide alias and comment alignment
- Semantic aliasing (on-demand)
- CASE, OVER, and long function breaking
- JOIN and USING formatting
- UPDATE/SET alignment
- Semicolon normalization with CTE safety
- Comment wrapping and trailing whitespace trimming

# chmod +x scripts/release.sh
# # Option 1: Using the release script
# ./scripts/release.sh 1.0.1

# Option 2: Manual tag
# git tag -a v1.0.1 -m "Release version 1.0.1"
# git push origin v1.0.1

# Option 3: GitHub UI
# Go to Actions → Build and Release → Run workflow
#!/bin/bash

# Usage: ./scripts/release.sh 1.0.0

VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  echo "Example: $0 1.0.0"
  exit 1
fi

# Update version in package.json
npm version $VERSION --no-git-tag-version

# Update CHANGELOG.md
echo "## [$VERSION] - $(date +%Y-%m-%d)" >> CHANGELOG.md.tmp
echo "" >> CHANGELOG.md.tmp
echo "### Added" >> CHANGELOG.md.tmp
echo "- " >> CHANGELOG.md.tmp
echo "" >> CHANGELOG.md.tmp
cat CHANGELOG.md >> CHANGELOG.md.tmp
mv CHANGELOG.md.tmp CHANGELOG.md

# Commit changes
git add package.json package-lock.json CHANGELOG.md
git commit -m "Release version $VERSION"

# Create and push tag
git tag -a "v$VERSION" -m "Release version $VERSION"
git push origin main
git push origin "v$VERSION"

echo "Release $VERSION created and pushed!"
echo "GitHub Actions will now build and publish the release."

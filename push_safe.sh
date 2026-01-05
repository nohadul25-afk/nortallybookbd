#!/bin/bash
# Safe push script for NorTallybookBd

git add .
git commit -m "Safe auto push: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main
echo "✅ Push complete. GitHub Actions will auto-build APK using Java 11."

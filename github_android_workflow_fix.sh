#!/bin/bash
# Filename: github_android_workflow_fix.sh
# Purpose: Replace old workflow with Java 17 + Gradle 8.4 workflow and push to GitHub

# -----------------------------
# 1️⃣ Set variables
# -----------------------------
REPO_DIR="$HOME/NorTallybookBd"
WORKFLOW_DIR="$REPO_DIR/.github/workflows"
WORKFLOW_FILE="$WORKFLOW_DIR/android_build.yml"

# -----------------------------
# 2️⃣ Ensure workflow folder exists
# -----------------------------
mkdir -p "$WORKFLOW_DIR"

# -----------------------------
# 3️⃣ Replace workflow file
# -----------------------------
cat > "$WORKFLOW_FILE" << 'EOF'
name: Android APK Build

on:
  push:
    branches:
      - master
  pull_request:

jobs:
  build:
    name: Build Debug APK
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Java 17
        uses: actions/setup-java@v3
        with:
          distribution: temurin
          java-version: 17

      - name: Set up Android SDK
        uses: android-actions/setup-android@v2
        with:
          api-level: 34
          build-tools: 34.0.0

      - name: Upgrade Gradle wrapper
        run: ./gradlew wrapper --gradle-version 8.4

      - name: Cache Gradle
        uses: actions/cache@v3
        with:
          path: |
            ~/.gradle/caches
            ~/.gradle/wrapper
          key: gradle-${{ hashFiles('**/*.gradle*', '**/gradle-wrapper.properties') }}
          restore-keys: gradle-

      - name: Build Debug APK
        run: ./gradlew assembleDebug --stacktrace

      - name: Upload APK artifact
        uses: actions/upload-artifact@v4
        with:
          name: app-debug.apk
          path: app/build/outputs/apk/debug/app-debug.apk
EOF

# -----------------------------
# 4️⃣ Commit & push changes
# -----------------------------
cd "$REPO_DIR" || { echo "Repo not found"; exit 1; }

# Stage all changes
git add -A

# Commit
git commit -m "Replace old workflow with Java 17 + Gradle 8.4 workflow"

# Force push to master
git push origin master --force

echo "✅ Workflow replaced and pushed to GitHub. Check Actions tab for APK build."

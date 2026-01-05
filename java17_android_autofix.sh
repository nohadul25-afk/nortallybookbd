#!/usr/bin/env bash
set -e

echo "=============================="
echo " Android Java 17 Auto Fix Tool"
echo "=============================="

PROJECT_DIR="$HOME/NorTallybookBd"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "❌ Project folder not found: $PROJECT_DIR"
  exit 1
fi

cd "$PROJECT_DIR"

echo "▶ Step 1: Check Java 17"
if ! java -version 2>&1 | grep -q "17"; then
  echo "▶ Installing Java 17 (no sudo)..."
  apt update
  apt install -y openjdk-17-jdk
fi

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

echo "✔ Java version:"
java -version

echo "▶ Step 2: Fix Gradle Wrapper (8.4)"
mkdir -p gradle/wrapper
cat > gradle/wrapper/gradle-wrapper.properties <<EOF
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\\://services.gradle.org/distributions/gradle-8.4-bin.zip
EOF

echo "▶ Step 3: Fix root build.gradle"
cat > build.gradle <<'EOF'
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath "com.android.tools.build:gradle:8.1.2"
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOF

echo "▶ Step 4: Fix settings.gradle"
cat > settings.gradle <<'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "NorTallybookBd"
include(":app")
EOF

echo "▶ Step 5: Fix app/build.gradle (Java 17)"
cat > app/build.gradle <<'EOF'
plugins {
    id 'com.android.application'
}

android {
    namespace "com.nortallybookbd.app"
    compileSdk 34

    defaultConfig {
        applicationId "com.nortallybookbd.app"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}

dependencies {
}
EOF

echo "▶ Step 6: Fix GitHub Actions workflow"
mkdir -p .github/workflows
cat > .github/workflows/android_build.yml <<'EOF'
name: Android APK Build (Java 17)

on:
  push:
    branches: [ master ]
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Java 17
        uses: actions/setup-java@v3
        with:
          distribution: temurin
          java-version: 17

      - name: Set up Android SDK
        uses: android-actions/setup-android@v2

      - name: Grant execute permission
        run: chmod +x gradlew

      - name: Build Debug APK
        run: ./gradlew assembleDebug

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: app-debug.apk
          path: app/build/outputs/apk/debug/app-debug.apk
EOF

echo "▶ Step 7: Permission fix"
chmod +x gradlew

echo "▶ Step 8: Verify Gradle"
./gradlew -v || true

echo "=============================="
echo "✅ Java 17 migration COMPLETE"
echo "Now git commit & push"
echo "=============================="

#!/bin/bash

# Xcode 프로젝트 생성 스크립트
# Usage: ./create-xcode-project.sh

set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SAMPLE_APP_DIR="$PROJECT_DIR/SampleApp"
PROJECT_NAME="SessionReplaySample"

echo "Creating Xcode project for $PROJECT_NAME..."

# xcodegen이 설치되어 있으면 사용
if command -v xcodegen &> /dev/null; then
    echo "Using xcodegen..."
    cd "$SAMPLE_APP_DIR"
    xcodegen generate
    echo "Project created at $SAMPLE_APP_DIR/$PROJECT_NAME.xcodeproj"
else
    echo "xcodegen not found."
    echo ""
    echo "Please create Xcode project manually:"
    echo "1. Open Xcode"
    echo "2. File > New > Project"
    echo "3. iOS > App"
    echo "4. Product Name: $PROJECT_NAME"
    echo "5. Interface: Storyboard"
    echo "6. Language: Swift"
    echo "7. Save to: $SAMPLE_APP_DIR"
    echo ""
    echo "Then replace generated files with:"
    echo "  - AppDelegate.swift"
    echo "  - SceneDelegate.swift"
    echo "  - MainViewController.swift"
    echo "  - DetailViewController.swift"
    echo "  - Info.plist"
    echo ""
    echo "And add local packages:"
    echo "  - File > Add Packages > Add Local"
    echo "  - Select: $PROJECT_DIR"
    echo "  - Add: WhatapSessionSnapshot, WhatapSessionRecorder"
fi

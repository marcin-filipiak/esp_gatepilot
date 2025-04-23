#!/bin/bash

# Detect the old application name from settings.gradle.kts
SETTINGS_GRADLE="./settings.gradle.kts"
if [ -f "$SETTINGS_GRADLE" ]; then
    OLD_APP_NAME=$(grep -oP 'rootProject.name\s*=\s*"\K[^"]+' "$SETTINGS_GRADLE")
else
    echo "settings.gradle.kts file not found. Exiting."
    exit 1
fi

# Detect the old package name from build.gradle.kts
GRADLE_KTS="./app/build.gradle.kts"
if [ -f "$GRADLE_KTS" ]; then
    OLD_PACKAGE=$(grep -oP 'applicationId\s*=\s*"\K[^"]+' "$GRADLE_KTS")
else
    echo "build.gradle.kts file not found. Exiting."
    exit 1
fi

read -p "Enter new application name: " NEW_APP_NAME

if [ -z "$NEW_APP_NAME" ]; then
    echo "No new application name provided. Exiting."
    exit 1
fi

NEW_PACKAGE="com.example.$NEW_APP_NAME"

echo "Current application name: $OLD_APP_NAME"
echo "Current package: $OLD_PACKAGE"
echo "New application name: $NEW_APP_NAME"
echo "New package: $NEW_PACKAGE"

# Update Run/Debug configurations in Android Studio
echo "Updating Run/Debug configurations..."
find .idea/runConfigurations -name "*.xml" -exec sed -i "s|$OLD_APP_NAME|${NEW_APP_NAME}|g" {} +

# Update .iml files
find . -name "*.iml" -exec sed -i "s|$OLD_PACKAGE|$NEW_PACKAGE|g" {} +

# Replace texts in project files
echo "Replacing texts in project files..."
find . -type f \( -name "*.xml" -o -name "*.kt" -o -name "*.java" -o -name "*.gradle" \) \
    -exec sed -i "s|$OLD_APP_NAME|$NEW_APP_NAME|g" {} +

# Update app_name in strings.xml
STRINGS_FILE="./app/src/main/res/values/strings.xml"
if [ -f "$STRINGS_FILE" ]; then
    sed -i "s|<string name=\"app_name\">.*</string>|<string name=\"app_name\">${NEW_APP_NAME}</string>|" "$STRINGS_FILE"
fi

# Update build.gradle.kts
if [ -f "$GRADLE_KTS" ]; then
    sed -i "s|namespace = \"$OLD_PACKAGE\"|namespace = \"$NEW_PACKAGE\"|" "$GRADLE_KTS"
    sed -i "s|applicationId = \"$OLD_PACKAGE\"|applicationId = \"$NEW_PACKAGE\"|" "$GRADLE_KTS"
fi

# Update package declarations in code
echo "Updating package declarations..."
find ./app/src -type f \( -name "*.kt" -o -name "*.java" \) \
    -exec sed -i "s|^package $OLD_PACKAGE|package $NEW_PACKAGE|" {} +

# Move package folders
OLD_DIR="./app/src/main/java/$(echo $OLD_PACKAGE | tr '.' '/')"
NEW_DIR="./app/src/main/java/$(echo $NEW_PACKAGE | tr '.' '/')"

if [ -d "$OLD_DIR" ]; then
    echo "Moving folder: $OLD_DIR -> $NEW_DIR"
    mkdir -p "$(dirname "$NEW_DIR")"
    mv "$OLD_DIR" "$NEW_DIR"
fi

# Move test directories
for SUBDIR in "test" "androidTest"; do
    OLD_TEST_DIR="./app/src/$SUBDIR/java/$(echo $OLD_PACKAGE | tr '.' '/')"
    NEW_TEST_DIR="./app/src/$SUBDIR/java/$(echo $NEW_PACKAGE | tr '.' '/')"
    if [ -d "$OLD_TEST_DIR" ]; then
        echo "Moving test folder: $OLD_TEST_DIR -> $NEW_TEST_DIR"
        mkdir -p "$(dirname "$NEW_TEST_DIR")"
        mv "$OLD_TEST_DIR" "$NEW_TEST_DIR"
    fi
done

# Update settings.gradle.kts
if [ -f "$SETTINGS_GRADLE" ]; then
    sed -i "s|rootProject.name = \"$OLD_APP_NAME\"|rootProject.name = \"$NEW_APP_NAME\"|" "$SETTINGS_GRADLE"
    sed -i "s|include(\":$OLD_APP_NAME\")|include(\":$NEW_APP_NAME\")|" "$SETTINGS_GRADLE"
fi

echo "Done. In Android Studio, run Clean, Rebuild, and Sync Gradle."


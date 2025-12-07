#!/bin/bash

# Script to add all Swift files to Xcode project
# Run this from the algo/algo directory

echo "Finding all Swift files in our new folders..."

cd /Users/markbuot/GIT/algo/algo/algo

# List all Swift files that need to be added
find App CommonUI Data Domain Features -name "*.swift" -type f | while read file; do
    echo "  - $file"
done

echo ""
echo "=========================================="
echo "MANUAL STEP REQUIRED:"
echo "=========================================="
echo ""
echo "In Xcode:"
echo "1. Right-click on 'algo' folder in Project Navigator"
echo "2. Select 'Add Files to algo...'"
echo "3. Navigate to: /Users/markbuot/GIT/algo/algo/algo/"
echo "4. Hold Cmd and select these folders:"
echo "   - App"
echo "   - CommonUI"
echo "   - Data"
echo "   - Domain"
echo "   - Features"
echo "5. Ensure 'Create groups' is selected"
echo "6. Ensure 'algo' target is checked"
echo "7. Click Add"
echo ""
echo "Then press Cmd+B to build!"
echo ""

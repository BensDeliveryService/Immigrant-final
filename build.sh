#!/bin/bash

# --------- CONFIG (edit if needed) ----------
TWEEGO="$HOME/tweego/tweego"  # or wherever you install it
FORMAT="sugarcube-2-37-3"
# --------------------------------------------

# Resolve paths relative to this script
PROJECT="$(cd "$(dirname "$0")" && pwd)"
SRC="$PROJECT/src"
DIST="$PROJECT/dist"
ASSETS="$PROJECT/assets"

echo "=== Tweego build starting ==="
echo "Project  : $PROJECT"
echo "Tweego   : $TWEEGO"
echo "Source   : $SRC"
echo "Output   : $DIST/index.html"
echo "FormatId : $FORMAT"
echo

# Sanity checks
if [ ! -f "$TWEEGO" ]; then
    echo "ERROR: Tweego not found at '$TWEEGO'."
    echo "Edit TWEEGO= in build.sh and try again."
    exit 1
fi

if [ ! -d "$SRC" ]; then
    echo "ERROR: src folder not found at '$SRC'."
    exit 1
fi

# Clean dist
echo "Cleaning dist..."
rm -rf "$DIST"
mkdir -p "$DIST"

# Compile
echo "Compiling with Tweego..."
"$TWEEGO" -o "$DIST/index.html" --format "$FORMAT" --log-files "$SRC"

if [ $? -ne 0 ]; then
    echo "Build failed. See Tweego errors above."
    exit 1
fi

# Copy assets (optional)
if [ -d "$ASSETS" ]; then
    echo "Copying assets..."
    cp -R "$ASSETS" "$DIST/"
fi

# Show what we built
if [ -f "$DIST/index.html" ]; then
    echo "Built: $DIST/index.html"
    echo "Size : $(stat -f%z "$DIST/index.html") bytes"
fi

# Open the local file
echo "Opening local build..."
open "$DIST/index.html"

echo "Done."
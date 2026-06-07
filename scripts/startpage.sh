#!/bin/sh

# Startpage HTTP server
# Update the path below to point to your startpage directory

STARTPAGE_DIR="${HOME}/Repos/PersonalProjects/startpage"

# Check if directory exists, if not try alternatives
if [ ! -d "$STARTPAGE_DIR" ]; then
    # Try common alternative locations
    if [ -d "${HOME}/.config/startpage" ]; then
        STARTPAGE_DIR="${HOME}/.config/startpage"
    elif [ -d "${HOME}/.local/share/startpage" ]; then
        STARTPAGE_DIR="${HOME}/.local/share/startpage"
    else
        echo "⚠️  Startpage directory not found at:"
        echo "  - $STARTPAGE_DIR"
        echo "  - ${HOME}/.config/startpage"
        echo "  - ${HOME}/.local/share/startpage"
        echo ""
        echo "Please update this script or create the directory with your startpage files."
        exit 1
    fi
fi

cd "$STARTPAGE_DIR" || exit 1
echo "🌐 Starting HTTP server at: http://localhost:10002"
python -m http.server 10002

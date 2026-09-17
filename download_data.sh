#!/bin/bash
set -euo pipefail

# --- CONFIGURATION ---
RECORD_ID="22273077"
ARCHIVE_NAME="data_raw.tar.gz" # Exact filename uploaded to Zenodo
ZENODO_URL="https://zenodo.org/records/${RECORD_ID}/files/${ARCHIVE_NAME}?download=1"

echo "================================================================="
echo "  ACM WiNTECH '26 Artifact: Checking Raw Trace Dataset"
echo "================================================================="

# --- Helper Function to Extract based on extension ---
extract_archive() {
    local file="$1"
    echo "Extracting $file ..."
    
    case "$file" in
        *.tar.gz|*.tgz)
            tar -xzvf "$file"
            ;;
        *.zip)
            if ! command -v unzip &> /dev/null; then
                echo "[!] Error: 'unzip' is not installed. Please install it to extract .zip files."
                exit 1
            fi
            unzip -o "$file"
            ;;
        *)
            echo "[!] Error: Unsupported archive format: $file"
            exit 1
            ;;
    esac
}

# --- Case 1: Check if data_raw/ already exists and contains files ---
if [ -d "data_raw" ] && [ "$(ls -A data_raw 2>/dev/null)" ]; then
    echo "[OK] 'data_raw/' directory already exists and is not empty."
    echo "    Skipping download and extraction."
    exit 0
fi

# --- Case 2: Check for ANY existing local archive (tar.gz, zip, etc.) ---
FOUND_ARCHIVE=""
for ext in "*.tar.gz" "*.tgz" "*.zip"; do
    for f in $ext; do
        if [ -f "$f" ]; then
            FOUND_ARCHIVE="$f"
            break 2
        fi
    done
done

if [ -n "$FOUND_ARCHIVE" ]; then
    echo "[OK] Found local archive: $FOUND_ARCHIVE"
    extract_archive "$FOUND_ARCHIVE"
    echo "================================================================="
    echo " SUCCESS: Raw dataset ready in 'data_raw/'."
    echo "================================================================="
    exit 0
fi

# --- Case 3: Download from Zenodo ---
echo "[!] No local data found. Attempting to download from Zenodo..."

# Check if the URL is reachable (following redirects)
HTTP_STATUS=$(curl -s -I -L -o /dev/null -w "%{http_code}" "$ZENODO_URL")

if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "================================================================="
    echo " [ERROR] Zenodo link is unavailable (HTTP Status: $HTTP_STATUS)."
    echo " The provided URL might be incorrect or the record is not published yet."
    echo ""
    echo " Please download the dataset manually from:"
    echo " $ZENODO_URL"
    echo ""
    echo " Place the archive in this directory and re-run this script."
    echo "================================================================="
    exit 1
fi

# Perform the download
if command -v curl &> /dev/null; then
    curl -L -o "$ARCHIVE_NAME" "$ZENODO_URL"
elif command -v wget &> /dev/null; then
    wget -c -O "$ARCHIVE_NAME" "$ZENODO_URL"
else
    echo "[!] Error: Neither curl nor wget found. Please install one to proceed."
    echo " Otherwise, you can download the dataset manually from:"
    echo " $ZENODO_URL"
    exit 1
fi

# Extract the newly downloaded file
extract_archive "$ARCHIVE_NAME"

echo "================================================================="
echo " SUCCESS: Raw dataset ready in 'data_raw/'."
echo "================================================================="

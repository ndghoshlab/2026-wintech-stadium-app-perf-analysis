#!/bin/bash
set -euo pipefail

# --- CONFIGURATION ---
GDRIVE_FILE_ID="1LEDNeqPZQLZwqRFFVxXlxl29Mt_Aet0d"
ARCHIVE_NAME="data_raw.tar.gz"
# Optional: Replace with your actual hash (run `sha256sum data_raw.tar.gz` locally)
EXPECTED_SHA256="ce3ea759ef39bd02501e305822d45f8692ff1b8b454e702215dc107f30294c7b" 

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

# --- Case 2: Check for ANY existing local archive ---
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

# --- Case 3: Download from Google Drive ---
echo "[!] No local data found. Attempting to download from Google Drive..."

download_gdrive() {
    local file_id="$1"
    local output="$2"

    # Priority 1: gdown (most reliable for GDrive)
    if command -v gdown &> /dev/null; then
        echo "[+] Downloading via gdown..."
        gdown --id "$file_id" -O "$output" && return 0
    fi

    # Priority 2: Safe curl with secure temp cookie storage
    if command -v curl &> /dev/null; then
        echo "[+] Downloading via curl..."
        local tmp_cookie
        tmp_cookie=$(mktemp)
        
        # Initial request to bypass GDrive's 100MB virus scan confirmation screen
        local confirm_token
        confirm_token=$(curl -s -c "$tmp_cookie" \
            "https://drive.google.com/uc?export=download&id=${file_id}" \
            | grep -o 'confirm=[^&"]*' | sed 's/confirm=//' || true)

        if [ -n "$confirm_token" ]; then
            curl -L -b "$tmp_cookie" \
                "https://drive.google.com/uc?export=download&confirm=${confirm_token}&id=${file_id}" \
                -o "$output"
        else
            curl -L -b "$tmp_cookie" \
                "https://drive.usercontent.google.com/download?id=${file_id}&confirm=t" \
                -o "$output"
        fi
        
        rm -f "$tmp_cookie"
        return 0
    fi

    echo "[!] Error: Neither gdown nor curl is available."
    return 1
}

download_gdrive "$GDRIVE_FILE_ID" "$ARCHIVE_NAME"

# Check file size (ensure it didn't just download a 2KB HTML error page)
FILE_SIZE=$(wc -c <"$ARCHIVE_NAME" 2>/dev/null || echo 0)
if [ "$FILE_SIZE" -lt 1000000 ]; then
    echo "================================================================="
    echo " [ERROR] Downloaded file is too small ($FILE_SIZE bytes)."
    echo " Google Drive link may be restricted or link format changed."
    echo ""
    echo " Please download manually from:"
    echo " https://drive.google.com/file/d/${GDRIVE_FILE_ID}/view"
    echo " Place the archive in this folder as '$ARCHIVE_NAME' and re-run."
    echo "================================================================="
    rm -f "$ARCHIVE_NAME"
    exit 1
fi

# Optional SHA256 Verification
if [ -n "$EXPECTED_SHA256" ] && command -v sha256sum &> /dev/null; then
    ACTUAL_SHA256=$(sha256sum "$ARCHIVE_NAME" | awk '{print $1}')
    if [ "$EXPECTED_SHA256" != "$ACTUAL_SHA256" ]; then
        echo "[!] Error: SHA256 checksum mismatch."
        echo "    Expected: $EXPECTED_SHA256"
        echo "    Actual:   $ACTUAL_SHA256"
        exit 1
    fi
fi

# Extract archive
extract_archive "$ARCHIVE_NAME"

echo "================================================================="
echo " SUCCESS: Raw dataset ready in 'data_raw/'."
echo "================================================================="

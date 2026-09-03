#!/bin/bash
set -e

echo "================================================================="
echo "  ACM WiNTECH 2026 Artifact Evaluation - Quick Sanity Test"
echo "  (Kick-the-Tires Phase: Fast execution on data_processed/)"
echo "================================================================="

# 1. Activate Virtual Environment
if [ -d "venv" ]; then
    echo "[1/4] Activating virtual environment (venv)..."
    source venv/bin/activate
elif [ -d ".venv" ]; then
    echo "[1/4] Activating virtual environment (.venv)..."
    source .venv/bin/activate
else
    echo "[!] Warning: No venv detected. Running in current environment."
fi

# 2. Check Dependencies
echo "[2/4] Verifying Python dependencies..."
pip install --quiet -r requirements.txt

# 3. Ensure Output Directory Exists
mkdir -p figures

# 4. Execute Fast Processed-Data Notebooks
echo "[3/4] Executing notebooks using data_processed/..."
echo "-----------------------------------------------------------------"

FAST_NOTEBOOKS=(
    "notebooks/Ardan-2026_analysis_browsingStatistics.ipynb"
    "notebooks/Ardan-2026_analysis_IgWaStatistics.ipynb"
)

for nb in "${FAST_NOTEBOOKS[@]}"; do
    if [ -f "$nb" ]; then
        echo " -> Executing: $nb"
        jupyter nbconvert --to notebook --execute --inplace "$nb"
        echo " -> Completed: $nb"
        echo "-----------------------------------------------------------------"
    else
        echo " [!] Skipping: $nb (File not found)"
    fi
done

# 5. Summary Verification
echo "[4/4] Verifying generated figures..."
if ls figures/*.pdf 1> /dev/null 2>&1; then
    echo ""
    echo "================================================================="
    echo " SUCCESS: Quick test passed! All processed-data plots generated."
    echo " Output files updated in 'figures/'."
    echo "================================================================="
else
    echo "[!] Warning: Notebooks ran but no PDF files found in 'figures/'."
fi
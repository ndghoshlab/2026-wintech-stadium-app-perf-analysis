#!/bin/bash
set -euo pipefail

echo "================================================================="
echo "  ACM WiNTECH 2026 Artifact Evaluation - Master Pipeline"
echo "================================================================="

# 1. Detect Active or Local Virtual Environment
if [ -n "${VIRTUAL_ENV:-}" ]; then
    echo "[1/4] Using currently active environment: $VIRTUAL_ENV"
elif [ -d "venv" ]; then
    echo "[1/4] Activating virtual environment (venv)..."
    source venv/bin/activate
elif [ -d ".venv" ]; then
    echo "[1/4] Activating virtual environment (.venv)..."
    source .venv/bin/activate
else
    echo "[!] Warning: No virtual environment detected. Running in current environment."
fi

# 2. Verify Python Dependencies
echo "[2/4] Verifying Python dependencies..."
pip install --quiet -r requirements.txt

# 3. Handle Raw Dataset Procurement
echo "[3/4] Ensuring raw dataset availability..."
#bash download_data.sh
bash temp_gdrive.sh # Will change later when Zenodo is published

# 4. Execute All Analysis & Reproduction Notebooks
echo "[4/4] Executing all analysis notebooks end-to-end..."
echo "-----------------------------------------------------------------"

mkdir -p figures

NOTEBOOKS=(
    "notebooks/Ardan-2026_raw_sigcapMerging_postgame.ipynb"
    "notebooks/Ardan-2026_replicate_game5_analysis.ipynb"
    "notebooks/Ardan-2026_replicate_game6_analysis.ipynb"

    "notebooks/Muhammad-2026_paper_analysis.ipynb"
    "notebooks/Ardan-2026_analysis_browsingStatistics.ipynb"
    "notebooks/Ardan-2026_analysis_IgWaStatistics.ipynb"
    "notebooks/Ardan-2026_phy-layer_browsingBandAnalysis.ipynb"
    "notebooks/Ardan-2026_radio_PciAndRanDist.ipynb"
)

for nb in "${NOTEBOOKS[@]}"; do
    if [ -f "$nb" ]; then
        echo " -> Executing: $nb"
        jupyter nbconvert --to notebook --execute --inplace "$nb"
        echo " -> Completed: $nb"
        echo "-----------------------------------------------------------------"
    else
        echo " [!] Skipping: $nb (File not found)"
    fi
done

echo ""
echo "================================================================="
echo " SUCCESS: Full reproduction complete!"
echo " All figures exported to 'figures/'."
echo "================================================================="

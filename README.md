# App-Based Performance Characterization of Cellular and Wi-Fi Networks in Dense Stadium Deployments

This repository contains the dataset, analysis scripts, Jupyter Notebooks, and processed output figures necessary to reproduce the empirical findings, figures, and tables presented in the paper:

> **App-Based Performance Characterization of Cellular and Wi-Fi Networks in Dense Stadium Deployments**  
> Hardani Ismu Nabil, Muhammad I. Rochman, S.M. Haider Ali Shuvo, Joshua Roy Palathinkal, and Monisha Ghosh  
> *20th ACM Workshop on Wireless Network Testbeds, Experimental evaluation & Characterization (WINTECH '26)*

---

## Resource & System Requirements

- **Operating System:** Linux (Ubuntu 20.04/22.04 recommended), macOS, or Windows via WSL2
- **Python Version:** Python 3.9+
- **Storage Space:** ~2 GB free disk space (~139 MB raw tarball + extracted/processed CSVs)
- **Memory (RAM):** 8 GB recommended
- **Execution Time:**
  - **Quick Guide execution (`./run_quick.sh`):** ~2 minutes
  - **Full analysis pipeline (`./run_all.sh`):** ~10–15 minutes

---

## Repository Directory Structure

```text
.
├── download_data.sh            # Downloads and extracts data_raw.tar.gz from Zenodo
├── LICENSE                     # License file
├── README.md                   # Repository documentation
├── requirements.txt            # Python library dependencies
├── run_all.sh                  # Executes full data extraction and analysis pipeline
├── run_quick.sh                # Validates environment and runs quick test
│
├── data_processed/             # Formatted CSVs for active and passive measurements
│   ├── 20251108_sigcap_general.csv
│   ├── 20251122_sigcap_general.csv
│   ├── df_browser_merged_gd5.csv
│   ├── df_browser_merged_gd6.csv
│   ├── df_browser_merged_pg.csv
│   ├── df_instagram_merged_gd6.csv
│   ├── df_instagram_merged_pg.csv
│   ├── df_messaging_merged_pg.csv
│   └── df_whatsapp_merged_gd6.csv
│
├── figures/                    # Output PDF figures and statistical text summaries
│   ├── 1MB Posting-Game.pdf
│   ├── 1MB Posting-Non-game.pdf
│   ├── bar_plot_unique_bssid_bowl_2025.pdf
│   ├── bar_plot_unique_bssid_bowl_2026.pdf
│   ├── bar_plot_unique_bssid_bowl.pdf
│   ├── BrowsingStatistics.txt
│   ├── ecdf_chutil_5ghz_6ghz_sp_Game_1.pdf
│   ├── ecdf_chutil_5ghz_6ghz_sp_Game_2.pdf
│   ├── ecdf_chutil_5ghz_6ghz_sp_Game_5.pdf
│   ├── ecdf_chutil_5ghz_6ghz_sp_Game_6.pdf
│   ├── ecdf_chutil_5ghz_6ghz_sp.pdf
│   ├── ecdf_chutil_5ghz_6ghz_sp_Postseason.pdf
│   ├── ecdf_chutil_5ghz_6ghz_sp_Preseason.pdf
│   ├── ecdf_ookla_game_bowl_dl.pdf
│   ├── ecdf_ookla_game_bowl_lat.pdf
│   ├── ecdf_ookla_game_bowl_ul.pdf
│   ├── ecdf_ookla_pregame_bowl_dl.pdf
│   ├── ecdf_ookla_pregame_bowl_lat.pdf
│   ├── ecdf_ookla_pregame_bowl_ul.pdf
│   ├── ecdf_sta_count_2025.png
│   ├── ecdf_sta_count_5ghz_6ghz_sp_lpi.png
│   ├── ecdf_txpower_5ghz_6ghz_sp.pdf
│   ├── IgStatistics.txt
│   ├── phy_MCS-PDSCH-Operator-wise_violin.pdf
│   ├── phy_MCS-PUSCH-Operator-wise_violin.pdf
│   ├── Send 1MB Picture-Game.pdf
│   ├── Send 1MB Picture-Non-game.pdf
│   ├── Send Text-Game.pdf
│   ├── Send Text-Non-game.pdf
│   ├── stacked_bar_unique_bssid_bowl_alt.pdf
│   ├── stacked_bar_unique_bssid_bowl.pdf
│   ├── stacked_bar_wifi_conn_ratio.pdf
│   ├── testStatusCompleted_qoe_Browsing Duration_LabelWise_browsing-ecdf-v4.pdf
│   └── WaStatistics.txt
│
└── notebooks/                  # Analysis Jupyter Notebooks
    ├── Ardan-2026_analysis_browsingStatistics.ipynb
    ├── Ardan-2026_analysis_IgWaStatistics.ipynb
    ├── Ardan-2026_phy-layer_browsingBandAnalysis.ipynb
    ├── Ardan-2026_radio_PciAndRanDist.ipynb
    ├── Ardan-2026_raw_sigcapMerging_postgame.ipynb
    ├── Ardan-2026_replicate_game5_analysis.ipynb
    ├── Ardan-2026_replicate_game6_analysis.ipynb
    └── Muhammad-2026_paper_analysis.ipynb
```

---

## Quick Guide

Follow these steps to set up your environment and perform a quick verification check.

### 1. Environment Setup

```bash
# Clone the repository
git clone https://github.com/ndghoshlab/2026-wintech-stadium-app-perf-analysis.git
cd 2026-wintech-stadium-app-perf-analysis

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install required dependencies
pip install --upgrade pip
pip install -r requirements.txt
```

### 2. Execution Verification

Make the execution scripts executable and run the quick test script:

```bash
chmod +x download_data.sh run_quick.sh run_all.sh
./run_quick.sh
```

**Expected Result:**

- Environmental dependencies are verified.
- A quick sample pass executes across processed files without errors.

---

## Full Reproduction Pipeline

To execute the entire analysis pipeline and regenerate all figures and statistical text reports:

```bash
./run_all.sh
```

- `download_data.sh` fetches `data_raw.tar.gz` from Zenodo.
- This script extracts raw measurement archives, executes all Jupyter Notebooks non-interactively, and regenerates output PDFs and statistical text summaries into the `figures/` directory.

---

## Paper Results to Notebook Mapping

...

| Paper Result | Artifact Description | Primary Notebook | &nbsp; | Generated Artifact (`figures/`) |
| :--- | :--- | :--- | :--- | :--- |
| **Figure 2** | Downlink (PDSCH) & Uplink (PUSCH) MCS Distributions | `Ardan-2026_phy-layer_browsingBandAnalysis.ipynb` |    | `phy_MCS-PDSCH-Operator-wise_violin.pdf`<br>`phy_MCS-PUSCH-Operator-wise_violin.pdf` |
| **Figure 3** | Count of Unique BSSIDs (2026 Non-Game) | `Muhammad-2026_paper_analysis.ipynb` |    | `bar_plot_unique_bssid_bowl_2026.pdf` |
| **Figure 4a, b** | Count of Unique BSSIDs & Connection Ratio | `Muhammad-2026_paper_analysis.ipynb` |    | `stacked_bar_unique_bssid_bowl.pdf`<br>`stacked_bar_wifi_conn_ratio.pdf` |
| **Figure 4c** | Wi-Fi Channel Utilization ECDF | `Muhammad-2026_paper_analysis.ipynb` |    | `ecdf_chutil_5ghz_6ghz_sp.pdf` |
| **Figure 5** | Ookla Speedtest Metrics (Non-game) | `Muhammad-2026_paper_analysis.ipynb` |    | `ecdf_ookla_pregame_bowl_dl.pdf`<br>`ecdf_ookla_pregame_bowl_ul.pdf`<br>`ecdf_ookla_pregame_bowl_lat.pdf` |
| **Figure 6** | Ookla Speedtest Metrics (Game) | `Muhammad-2026_paper_analysis.ipynb` |    | `ecdf_ookla_game_bowl_dl.pdf`<br>`ecdf_ookla_game_bowl_ul.pdf`<br>`ecdf_ookla_game_bowl_lat.pdf` |
| **Figure 7** | Browsing Duration ECDF (Game vs Non-game) | `Ardan-2026_analysis_browsingStatistics.ipynb` |    | `testStatusCompleted_qoe_Browsing Duration_LabelWise_browsing-ecdf-v4.pdf` |
| **Figure 8** | App QoE ECDF (Non-Game: IG & WhatsApp) | `Ardan-2026_analysis_IgWaStatistics.ipynb` |    | `1MB Posting-Non-game.pdf`<br>`Send 1MB Picture-Non-game.pdf`<br>`Send Text-Non-game.pdf` |
| **Figure 9** | App QoE ECDF (Game: IG & WhatsApp) | `Ardan-2026_analysis_IgWaStatistics.ipynb` |    | `1MB Posting-Game.pdf`<br>`Send 1MB Picture-Game.pdf`<br>`Send Text-Game.pdf` |
| **Table 2 & 3** | LTE/5G Configurations & RAN Deployment Ratios | `Ardan-2026_radio_PciAndRanDist.ipynb` |    | Terminal summary output |
| **Table 5** | Browsing Metric Summary | `Ardan-2026_analysis_browsingStatistics.ipynb` |    | `BrowsingStatistics.txt` |
| **Section 4.4** | WhatsApp & Instagram Failure Rates & Latency | `Ardan-2026_analysis_IgWaStatistics.ipynb` |    | `IgStatistics.txt`<br>`WaStatistics.txt` |

---

## License
- **Source Code & Scripts:** Released under the [MIT License](LICENSE).
- **Measurement Data & Traces:** Released under the [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/) license.

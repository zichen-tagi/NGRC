# Optical NGRC Synthetic Temporal Lattice Code

This repository provides representative code accompanying the manuscript
"Reconfigurable optical next-generation reservoir computing with synthetic
temporal lattices".

The included scripts reproduce the manuscript's processed source-data results
for the single-lattice benchmark predictions and multi-lattice feature-fusion
analysis. They also document how the plotted Fig. 3 and Fig. 4 values are read,
checked, and visualized from the submitted source-data files.

## Repository Contents

```text
NGRC-code/
  README.md
  LICENSE
  requirements.txt
  matlab/
    demo_single_lattice_ngrc.m
    demo_multi_lattice_fusion_ngrc.m
  python/
    figures/
      plot_figure4bcd.py
      plot_supplementary_source_data.py
  data/
    source_data.zip
    figure_source_data/
      Fig3a_raw_task_sequences.csv
      Fig3b_SantaFe_single_lattice_prediction.csv
      Fig3c_NARMA10_single_lattice_prediction.csv
      Fig3d_Lorenz63_single_lattice_prediction.csv
      figure4bcd_source_data.csv
    supplementary_source_data/
      Supplementary_Fig2_peak_extraction_source.csv
      Supplementary_Fig3_ridge_only_baseline_source.csv
      Supplementary_Fig4_cumulative_spectral_energy_source.csv
```

## MATLAB Demos

The MATLAB scripts

```text
matlab/demo_single_lattice_ngrc.m
matlab/demo_multi_lattice_fusion_ngrc.m
```

read the processed source-data CSV files included in this repository. The
single-lattice script reproduces the Fig. 3b-d prediction NMSE values:

- Santa Fe: `0.0325`,
- NARMA10: `0.1099`,
- Lorenz63: `0.0379`.

The multi-lattice script reproduces the Fig. 4b-d benchmark and feature-space
diagnostic values. The fused multi-lattice NMSE values are:

- Santa Fe: `0.0252`,
- NARMA10: `0.0983`,
- Lorenz63: `0.0184`.

## Figure Source Data

The Python script

```text
python/figures/plot_figure4bcd.py
```

uses the source-data CSV file

```text
data/figure_source_data/figure4bcd_source_data.csv
```

to reproduce the Fig. 4b-d bar plots.

The Python script

```text
python/figures/plot_supplementary_source_data.py
```

uses the CSV files in `data/supplementary_source_data/` to generate lightweight
check plots for Supplementary Figs. 2-4. These plots are intended for source-data
inspection and repository-side reproducibility checks.

The compressed file

```text
data/source_data.zip
```

contains the full processed source-data package for the manuscript figures,
including main-figure and supplementary-figure source data plus metadata.

The folder

```text
data/supplementary_source_data/
```

contains the processed source data used for Supplementary Figs. 2-4. These
files include the peak-extraction example, the ridge-only baseline comparison,
and the cumulative singular-value spectral-energy curves.

## Requirements

MATLAB:

- Tested syntax is compatible with recent MATLAB releases.

Python:

- Python 3.9+
- numpy
- pandas
- matplotlib

Install Python dependencies with:

```bash
pip install numpy pandas matplotlib
```

## Data Availability Note

Raw oscilloscope waveform files are not included in this lightweight code
package because of their large file size. Processed source data required for
the provided Fig. 3 single-lattice checks, Fig. 4b-d plotting script, and
supplementary figure data are included.
Additional experimental data can be made available according to the manuscript
data-availability statement.

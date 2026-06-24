# NGRC Repository File Guide

This note records the purpose of each file in this repository. It is intended as
a memory aid for the authors and for future maintenance.

## Top-Level Files

### `README.md`

Main public-facing repository description. It explains what the repository
contains, how the MATLAB and Python source-data reproduction scripts should be
used, and why raw oscilloscope waveform files are not included.

### `FILE_GUIDE.md`

This file. It gives a file-by-file explanation of the repository contents.

### `LICENSE`

Repository license file. It defines the terms under which the public code and
source-data files can be used.

### `requirements.txt`

Python package list for the plotting script. At present it contains the basic
scientific Python dependencies needed to run the Fig. 4 plotting code:
`numpy`, `pandas`, and `matplotlib`.

### `.gitignore`

Git ignore rules. It prevents temporary files, cache files, and local generated
artifacts from being accidentally committed.

## MATLAB Source-Data Scripts

### `matlab/demo_single_lattice_ngrc.m`

MATLAB script for reproducing the Fig. 3b-d single-lattice NGRC prediction
NMSE values from processed source-data CSV files.

Main purpose:

- read the Fig. 3 single-lattice prediction source data,
- recompute NMSE from ground-truth and predicted traces,
- verify the manuscript-rounded NMSE values,
- plot short source-data prediction segments for visual checking.

### `matlab/demo_multi_lattice_fusion_ngrc.m`

MATLAB script for reproducing the Fig. 4b-d multi-lattice fusion results from
processed source-data CSV files.

Main purpose:

- read the Fig. 4b-d benchmark and feature-diagnostic source data,
- report previous-best, single-lattice, and fused multi-lattice NMSE values,
- report single-lattice and fused effective-rank values,
- report single-lattice and fused mean absolute feature-correlation values,
- plot the Fig. 4b-d grouped bar summaries.

## Python Figure Script

### `python/figures/plot_figure4bcd.py`

Python script for reproducing the Fig. 4b-d bar plots from the provided CSV
source data.

Input:

- `data/figure_source_data/figure4bcd_source_data.csv`

Outputs:

- Fig. 4b-d combined or panel-level plots, depending on the script options.

Main purpose:

- document how the Fig. 4b-d values are plotted,
- provide a lightweight reproduction path without requiring the full raw
  oscilloscope waveform files.

### `python/figures/plot_supplementary_source_data.py`

Python script for plotting lightweight check figures from the supplementary
source-data CSV files.

Input:

- `data/supplementary_source_data/Supplementary_Fig2_peak_extraction_source.csv`
- `data/supplementary_source_data/Supplementary_Fig3_ridge_only_baseline_source.csv`
- `data/supplementary_source_data/Supplementary_Fig4_cumulative_spectral_energy_source.csv`

Outputs:

- check plots under `results/supplementary/`

Main purpose:

- provide repository-side plotting code for Supplementary Figs. 2-4,
- allow readers to inspect the uploaded supplementary source data without using
  the full local manuscript folder.

## Main-Figure Source Data

### `data/source_data.zip`

Compressed copy of the full processed source-data package for the manuscript.
It includes main-figure source data, supplementary-figure source data, metadata,
and source-data mapping files.

### `data/figure_source_data/Fig3a_raw_task_sequences.csv`

Processed source data for Fig. 3a raw task sequences.

### `data/figure_source_data/Fig3b_SantaFe_single_lattice_prediction.csv`
### `data/figure_source_data/Fig3c_NARMA10_single_lattice_prediction.csv`
### `data/figure_source_data/Fig3d_Lorenz63_single_lattice_prediction.csv`

Processed source data for Fig. 3b-d single-lattice prediction traces.

Contains:

- test-sample index,
- task name,
- ground-truth target,
- single-lattice prediction,
- ridge-only prediction where available,
- single-lattice NMSE.

Important current single-lattice NMSE values include:

- Santa Fe: `0.0324936421595198`,
- NARMA10: `0.109859383433717`,
- Lorenz63: `0.0378913086942314`.

### `data/figure_source_data/figure4bcd_source_data.csv`

Processed source data for Fig. 4b-d.

Contains:

- Fig. 4b NMSE benchmark comparison values,
- Fig. 4c effective-rank values,
- Fig. 4d mean absolute pairwise feature-correlation values.

Important current values include:

- Santa Fe multi-lattice fused NMSE: `0.0252`,
- NARMA10 multi-lattice fused NMSE: `0.0983`,
- Lorenz63 multi-lattice fused NMSE: `0.0184`.

## Supplementary-Figure Source Data

### `data/supplementary_source_data.zip`

Compressed copy of all supplementary-figure source-data CSV files. This is
included for convenient download as a single file.

### `data/supplementary_source_data/Supplementary_Fig2_peak_extraction_source.csv`

Source data for Supplementary Fig. 2, the oscilloscope peak-extraction example.

Contains:

- temporal-site index,
- expected center sample index,
- detected peak sample index,
- expected center time,
- detected peak time,
- peak value,
- search-window width in samples and nanoseconds.

Main purpose:

- document how temporal-site peaks were selected from the oscilloscope trace.

### `data/supplementary_source_data/Supplementary_Fig3_ridge_only_baseline_source.csv`

Source data for Supplementary Fig. 3, the ridge-only baseline comparison.

Contains:

- task name,
- ridge-only NMSE,
- single-lattice NMSE,
- whether the trace panel includes the ridge-only prediction.

Important current values:

- Santa Fe ridge-only NMSE: `0.0661257269681587`,
- NARMA10 ridge-only NMSE: `0.749405149362341`,
- Lorenz63 ridge-only NMSE: `1.01938723706185`.

These values match the manuscript text after rounding.

### `data/supplementary_source_data/Supplementary_Fig4_cumulative_spectral_energy_source.csv`

Source data for Supplementary Fig. 4, the cumulative singular-value
spectral-energy curves.

Contains:

- task name,
- condition,
- singular-value rank index,
- cumulative spectral energy.

Main purpose:

- support the feature-rank analysis,
- show how quickly each feature matrix accumulates spectral energy,
- provide the plotted data behind the 95% and 99% rank diagnostics.

## Generated Figure Outputs

The `results/` folder contains figure files generated from the Fig. 4b-d source
data. These are useful for quick inspection and for confirming that the plotting
script works.

### `results/figure4bcd_vertical.png`
### `results/figure4bcd_vertical.pdf`
### `results/figure4bcd_vertical.svg`

Vertical combined Fig. 4b-d plot in raster, PDF, and SVG formats.

### `results/Figure4bcd_vertical_compact_column.png`
### `results/Figure4bcd_vertical_compact_column.pdf`
### `results/Figure4bcd_vertical_compact_column.svg`

Compact-column version of the combined Fig. 4b-d plot.

### `results/Figure4b_panel_NMSE.png`
### `results/Figure4b_panel_NMSE.pdf`
### `results/Figure4b_panel_NMSE.svg`

Standalone Fig. 4b NMSE comparison panel.

### `results/Figure4c_panel_effective_rank.png`
### `results/Figure4c_panel_effective_rank.pdf`
### `results/Figure4c_panel_effective_rank.svg`

Standalone Fig. 4c effective-rank panel.

### `results/Figure4d_panel_mean_corr.png`
### `results/Figure4d_panel_mean_corr.pdf`
### `results/Figure4d_panel_mean_corr.svg`

Standalone Fig. 4d mean absolute feature-correlation panel.

## Practical Notes

- The repository is a lightweight public code and processed-data package.
- The MATLAB scripts reproduce the exact processed source-data values for Fig.
  3b-d and Fig. 4b-d.
- Exact plotted source data for Fig. 3, Fig. 4b-d, and Supplementary Figs. 2-4
  are included.
- Raw oscilloscope waveform files are not included because of their large file
  size.
- For manuscript submission, the fuller source-data archive is maintained
  separately as `Source_Data.zip` in the manuscript working folder.

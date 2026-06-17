# Optical NGRC Synthetic Temporal Lattice Code

This repository provides representative code accompanying the manuscript
"Next-generation optical reservoir computing with synthetic temporal lattices".

The included scripts are intended to document the computational workflow used in
the manuscript, including optical-feature style matrix construction,
multi-lattice feature fusion, ridge-readout training, benchmark metric
calculation, feature-space diagnostics, and figure generation.

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
      figure4bcd_source_data.csv
    supplementary_source_data/
      Supplementary_Fig2_peak_extraction_source.csv
      Supplementary_Fig3_multilattice_feature_matrices_source.csv
      Supplementary_Fig4_ridge_only_baseline_source.csv
      Supplementary_Fig5_cumulative_spectral_energy_source.csv
```

## MATLAB Demos

The MATLAB scripts

```text
matlab/demo_single_lattice_ngrc.m
matlab/demo_multi_lattice_fusion_ngrc.m
```

uses synthetic placeholder sequences and synthetic optical-like feature maps to
illustrate the analysis pipeline. The single-lattice demo shows the basic
optical NGRC workflow for one temporal-lattice configuration:

1. generation of a nonlinear benchmark sequence,
2. construction of delayed input coordinates,
3. generation of a single optical-like feature matrix,
4. ridge-readout training,
5. NMSE evaluation,
6. entropy-based effective-rank calculation, and
7. mean absolute pairwise feature-correlation calculation.

The multi-lattice demo extends the same workflow by generating several
distinct optical-like feature matrices, concatenating them before readout
training, and comparing the single-lattice and fused multi-lattice results.

These demos are not intended to reproduce the exact numerical results in the
manuscript because they do not include the experimental oscilloscope waveform
files.

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
check plots for Supplementary Figs. 2-5. These plots are intended for source-data
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

contains the processed source data used for Supplementary Figs. 2-5. These
files include the peak-extraction example, the multi-lattice feature-matrix
visualization, the ridge-only baseline comparison, and the cumulative
singular-value spectral-energy curves.

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
package because of their large file size. Processed source data required for the
provided Fig. 4b-d plotting script and supplementary figure data are included.
Additional experimental data can be made available according to the manuscript
data-availability statement.

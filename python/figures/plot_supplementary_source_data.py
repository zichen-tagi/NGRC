from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "data" / "supplementary_source_data"
OUTDIR = ROOT / "results" / "supplementary"
OUTDIR.mkdir(parents=True, exist_ok=True)


BLUE = "#4A86E8"
ORANGE = "#E69138"
BLACK = "#222222"
GRAY = "#D9D9D9"


def set_style():
    plt.rcParams.update(
        {
            "font.family": "sans-serif",
            "font.sans-serif": ["Arial", "Helvetica", "DejaVu Sans"],
            "svg.fonttype": "none",
            "pdf.fonttype": 42,
            "ps.fonttype": 42,
            "axes.spines.top": False,
            "axes.spines.right": False,
            "axes.linewidth": 1.1,
            "font.size": 9,
        }
    )


def save(fig, stem):
    fig.savefig(OUTDIR / f"{stem}.png", dpi=450, bbox_inches="tight")
    fig.savefig(OUTDIR / f"{stem}.svg", bbox_inches="tight")
    fig.savefig(OUTDIR / f"{stem}.pdf", bbox_inches="tight")
    plt.close(fig)


def plot_supp_fig2():
    df = pd.read_csv(DATA / "Supplementary_Fig2_peak_extraction_source.csv")
    fig, ax = plt.subplots(figsize=(6.5, 2.5))
    temporal_site = df["TemporalSite"].to_numpy()
    peak_value = df["PeakValue"].to_numpy()
    ax.plot(temporal_site, peak_value, color=BLACK, linewidth=1.2)
    ax.scatter(temporal_site, peak_value, s=18, color=BLUE, zorder=3)
    ax.set_xlabel("Temporal site")
    ax.set_ylabel("Peak value (a.u.)")
    ax.set_title("Supplementary Fig. 2 source data: extracted peaks")
    ax.grid(axis="y", color=GRAY, linewidth=0.6)
    save(fig, "supplementary_fig2_peak_extraction_source_plot")


def plot_supp_fig3():
    df = pd.read_csv(DATA / "Supplementary_Fig3_ridge_only_baseline_source.csv")
    y = np.arange(len(df))
    width = 0.35
    fig, ax = plt.subplots(figsize=(5.5, 2.8))
    single_nmse = df["SingleLattice_NMSE"].to_numpy()
    ridge_nmse = df["RidgeOnly_NMSE"].to_numpy()
    ax.barh(y - width / 2, single_nmse, width, color=BLUE, edgecolor=BLACK, label="Single-lattice")
    ax.barh(y + width / 2, ridge_nmse, width, color=ORANGE, edgecolor=BLACK, label="Ridge-only")
    ax.set_yticks(y)
    ax.set_yticklabels(df["Task"])
    ax.invert_yaxis()
    ax.set_xlabel("NMSE")
    ax.legend(frameon=False, loc="lower right")
    ax.grid(axis="x", color=GRAY, linewidth=0.6)
    save(fig, "supplementary_fig3_ridge_only_nmse_source_plot")


def plot_supp_fig4():
    df = pd.read_csv(DATA / "Supplementary_Fig4_cumulative_spectral_energy_source.csv")
    tasks = list(df["Task"].drop_duplicates())
    fig, axes = plt.subplots(1, len(tasks), figsize=(9.0, 2.8), sharey=True)
    for ax, task in zip(axes, tasks):
        sub_task = df[df["Task"] == task]
        for condition, color in [("Single-lattice", BLUE), ("Multi-lattice fusion", ORANGE)]:
            sub = sub_task[sub_task["Configuration"] == condition]
            ax.plot(
                sub["Index"].to_numpy(),
                sub["CumulativeSpectralEnergy"].to_numpy(),
                color=color,
                linewidth=1.6,
                label=condition,
            )
        ax.axhline(0.95, color="#777777", linestyle=":", linewidth=0.8)
        ax.axhline(0.99, color="#777777", linestyle="--", linewidth=0.8)
        ax.set_title(task)
        ax.set_xlabel("Rank")
        ax.grid(axis="y", color=GRAY, linewidth=0.6)
    axes[0].set_ylabel("Cumulative spectral energy")
    axes[0].legend(frameon=False, loc="lower right")
    save(fig, "supplementary_fig4_spectral_energy_source_plot")


def main():
    set_style()
    plot_supp_fig2()
    plot_supp_fig3()
    plot_supp_fig4()


if __name__ == "__main__":
    main()

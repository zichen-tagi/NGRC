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
    ax.plot(df["TemporalSite"], df["PeakValue"], color=BLACK, linewidth=1.2)
    ax.scatter(df["TemporalSite"], df["PeakValue"], s=18, color=BLUE, zorder=3)
    ax.set_xlabel("Temporal site")
    ax.set_ylabel("Peak value (a.u.)")
    ax.set_title("Supplementary Fig. 2 source data: extracted peaks")
    ax.grid(axis="y", color=GRAY, linewidth=0.6)
    save(fig, "supplementary_fig2_peak_extraction_source_plot")


def plot_supp_fig3():
    df = pd.read_csv(DATA / "Supplementary_Fig3_multilattice_feature_matrices_source.csv")
    matrices = list(df["matrix"].drop_duplicates())
    fig, axes = plt.subplots(len(matrices), 1, figsize=(7.0, 6.0), constrained_layout=True)
    for ax, name in zip(axes, matrices):
        sub = df[df["matrix"] == name]
        mat = sub.pivot(
            index="sample_index",
            columns="feature_channel",
            values="z_score_value",
        ).to_numpy()
        im = ax.imshow(mat, aspect="auto", cmap="viridis", vmin=-2.5, vmax=2.5)
        ax.set_ylabel(name)
        ax.set_yticks([])
        if ax is not axes[-1]:
            ax.set_xticklabels([])
        else:
            ax.set_xlabel("Feature channel")
    fig.colorbar(im, ax=axes, label="z-score", shrink=0.85)
    save(fig, "supplementary_fig3_feature_matrices_source_plot")


def plot_supp_fig4():
    df = pd.read_csv(DATA / "Supplementary_Fig4_ridge_only_baseline_source.csv")
    y = np.arange(len(df))
    width = 0.35
    fig, ax = plt.subplots(figsize=(5.5, 2.8))
    ax.barh(y - width / 2, df["SingleLattice_NMSE"], width, color=BLUE, edgecolor=BLACK, label="Single-lattice")
    ax.barh(y + width / 2, df["RidgeOnly_NMSE"], width, color=ORANGE, edgecolor=BLACK, label="Ridge-only")
    ax.set_yticks(y)
    ax.set_yticklabels(df["Task"])
    ax.invert_yaxis()
    ax.set_xlabel("NMSE")
    ax.legend(frameon=False, loc="lower right")
    ax.grid(axis="x", color=GRAY, linewidth=0.6)
    save(fig, "supplementary_fig4_ridge_only_nmse_source_plot")


def plot_supp_fig5():
    df = pd.read_csv(DATA / "Supplementary_Fig5_cumulative_spectral_energy_source.csv")
    tasks = list(df["Task"].drop_duplicates())
    fig, axes = plt.subplots(1, len(tasks), figsize=(9.0, 2.8), sharey=True)
    for ax, task in zip(axes, tasks):
        sub_task = df[df["Task"] == task]
        for condition, color in [("Single-lattice", BLUE), ("Multi-lattice fusion", ORANGE)]:
            sub = sub_task[sub_task["Configuration"] == condition]
            ax.plot(sub["Index"], sub["CumulativeSpectralEnergy"], color=color, linewidth=1.6, label=condition)
        ax.axhline(0.95, color="#777777", linestyle=":", linewidth=0.8)
        ax.axhline(0.99, color="#777777", linestyle="--", linewidth=0.8)
        ax.set_title(task)
        ax.set_xlabel("Rank")
        ax.grid(axis="y", color=GRAY, linewidth=0.6)
    axes[0].set_ylabel("Cumulative spectral energy")
    axes[0].legend(frameon=False, loc="lower right")
    save(fig, "supplementary_fig5_spectral_energy_source_plot")


def main():
    set_style()
    plot_supp_fig2()
    plot_supp_fig3()
    plot_supp_fig4()
    plot_supp_fig5()


if __name__ == "__main__":
    main()

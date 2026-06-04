from pathlib import Path

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


ROOT = Path(__file__).resolve().parents[2]
SOURCE_DATA = ROOT / "data" / "figure_source_data" / "figure4bcd_source_data.csv"
OUTDIR = ROOT / "results"
OUTDIR.mkdir(exist_ok=True)

TASKS = ["Santa Fe", "NARMA10", "Lorenz63"]
COLORS = {
    "Previous Best": "#D0D3D8",
    "Single-Lattice": "#4A86E8",
    "Multi-Lattice (Fused)": "#E69138",
}


def set_style():
    plt.rcParams.update(
        {
            "font.family": "sans-serif",
            "font.sans-serif": ["Arial", "Helvetica", "DejaVu Sans"],
            "svg.fonttype": "none",
            "pdf.fonttype": 42,
            "ps.fonttype": 42,
            "font.size": 11,
            "axes.labelsize": 12,
            "axes.linewidth": 1.3,
            "axes.spines.top": False,
            "axes.spines.right": False,
            "legend.frameon": False,
        }
    )


def panel_values(data, panel, series_order):
    panel_data = data[data["panel"] == panel]
    values = []
    for series in series_order:
        series_values = []
        for task in TASKS:
            row = panel_data[
                (panel_data["task"] == task) & (panel_data["series"] == series)
            ]
            series_values.append(float(row["value"].iloc[0]))
        values.append(np.array(series_values))
    return values


def grouped_bars(ax, values, series_order, ylabel, ylim, yticks, label):
    x = np.arange(len(TASKS))
    width = 0.78 / len(values)
    offsets = (np.arange(len(values)) - (len(values) - 1) / 2) * width

    for y, series, offset in zip(values, series_order, offsets):
        ax.bar(
            x + offset,
            y,
            width,
            label=series,
            color=COLORS[series],
            edgecolor="#1F1F1F",
            linewidth=0.8,
        )

    ax.set_ylabel(ylabel, fontweight="bold")
    ax.set_xticks(x)
    ax.set_xticklabels(TASKS, fontweight="bold")
    ax.set_ylim(*ylim)
    ax.set_yticks(yticks)
    ax.grid(axis="y", color="#D6D6D6", linewidth=0.6)
    ax.set_axisbelow(True)
    ax.text(
        -0.13,
        1.09,
        f"({label})",
        transform=ax.transAxes,
        fontsize=14,
        fontweight="bold",
        ha="left",
        va="top",
    )


def main():
    set_style()
    data = pd.read_csv(SOURCE_DATA)

    fig, axes = plt.subplots(3, 1, figsize=(6.0, 9.0))

    series_b = ["Previous Best", "Single-Lattice", "Multi-Lattice (Fused)"]
    grouped_bars(
        axes[0],
        panel_values(data, "4b", series_b),
        series_b,
        "NMSE",
        (0, 0.14),
        [0, 0.04, 0.08, 0.12],
        "b",
    )
    axes[0].legend(loc="upper right", fontsize=10)

    series_cd = ["Single-Lattice", "Multi-Lattice (Fused)"]
    grouped_bars(
        axes[1],
        panel_values(data, "4c", series_cd),
        series_cd,
        "Effective rank",
        (0, 130),
        [0, 40, 80, 120],
        "c",
    )
    axes[1].legend(loc="lower left", bbox_to_anchor=(0, 1.01), ncol=2, fontsize=10)

    grouped_bars(
        axes[2],
        panel_values(data, "4d", series_cd),
        series_cd,
        "Mean |corr|",
        (0, 0.40),
        [0, 0.1, 0.2, 0.3, 0.4],
        "d",
    )
    axes[2].legend(loc="lower left", bbox_to_anchor=(0, 1.01), ncol=2, fontsize=10)

    fig.tight_layout(h_pad=1.35)
    fig.savefig(OUTDIR / "figure4bcd_vertical.png", dpi=600, bbox_inches="tight")
    fig.savefig(OUTDIR / "figure4bcd_vertical.svg", bbox_inches="tight")
    fig.savefig(OUTDIR / "figure4bcd_vertical.pdf", bbox_inches="tight")


if __name__ == "__main__":
    main()


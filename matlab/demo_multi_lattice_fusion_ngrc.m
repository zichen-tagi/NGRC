%% Fig. 4 multi-lattice optical NGRC source-data reproduction
% This script reads the processed source data used for Fig. 4b-d in the
% manuscript and reports the exact single-lattice and fused multi-lattice
% values plotted in the paper.

clear; clc; close all;

repo_root = fileparts(fileparts(mfilename('fullpath')));
source_file = fullfile(repo_root, 'data', 'figure_source_data', ...
    'figure4bcd_source_data.csv');

data = readtable(source_file, 'TextType', 'string');
tasks = ["Santa Fe", "NARMA10", "Lorenz63"];

previous_nmse = zeros(numel(tasks), 1);
single_nmse = zeros(numel(tasks), 1);
fused_nmse = zeros(numel(tasks), 1);
single_rank = zeros(numel(tasks), 1);
fused_rank = zeros(numel(tasks), 1);
single_corr = zeros(numel(tasks), 1);
fused_corr = zeros(numel(tasks), 1);

fprintf('\nFig. 4 multi-lattice optical NGRC source-data reproduction\n');
fprintf('Source file: %s\n\n', source_file);

for task_id = 1:numel(tasks)
    task_name = tasks(task_id);

    previous_nmse(task_id) = lookup_value(data, "4b", task_name, ...
        "Previous Best");
    single_nmse(task_id) = lookup_value(data, "4b", task_name, ...
        "Single-Lattice");
    fused_nmse(task_id) = lookup_value(data, "4b", task_name, ...
        "Multi-Lattice (Fused)");
    single_rank(task_id) = lookup_value(data, "4c", task_name, ...
        "Single-Lattice");
    fused_rank(task_id) = lookup_value(data, "4c", task_name, ...
        "Multi-Lattice (Fused)");
    single_corr(task_id) = lookup_value(data, "4d", task_name, ...
        "Single-Lattice");
    fused_corr(task_id) = lookup_value(data, "4d", task_name, ...
        "Multi-Lattice (Fused)");

    fprintf('%-8s NMSE: previous best %.4f | single %.4f | fused %.4f', ...
        task_name, previous_nmse(task_id), single_nmse(task_id), ...
        fused_nmse(task_id));
    fprintf(' | fused vs single: %.2f%%\n', ...
        100 * (fused_nmse(task_id) - single_nmse(task_id)) ...
        / single_nmse(task_id));
    fprintf('         effective rank: single %.2f | fused %.2f\n', ...
        single_rank(task_id), fused_rank(task_id));
    fprintf('         mean |corr|:    single %.4f | fused %.4f\n\n', ...
        single_corr(task_id), fused_corr(task_id));
end

figure('Color', 'w', 'Position', [100, 100, 900, 780]);
tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile;
plot_grouped_bars([previous_nmse, single_nmse, fused_nmse], tasks, ...
    {'Previous Best', 'Single-Lattice', 'Multi-Lattice (Fused)'}, ...
    'NMSE', [0 0.14], 'Fig. 4b');

nexttile;
plot_grouped_bars([single_rank, fused_rank], tasks, ...
    {'Single-Lattice', 'Multi-Lattice (Fused)'}, ...
    'Effective rank', [0 130], 'Fig. 4c');

nexttile;
plot_grouped_bars([single_corr, fused_corr], tasks, ...
    {'Single-Lattice', 'Multi-Lattice (Fused)'}, ...
    'Mean |corr|', [0 0.40], 'Fig. 4d');

function value = lookup_value(data, panel, task_name, series_name)
    row = data.panel == panel ...
        & data.task == task_name ...
        & data.series == series_name;
    assert(nnz(row) == 1, ...
        'Expected one row for panel %s, task %s, series %s.', ...
        panel, task_name, series_name);
    value = data.value(row);
end

function plot_grouped_bars(values, tasks, legend_labels, ylabel_text, ...
        ylim_values, title_text)
    bars = bar(values, 'grouped');
    for bar_id = 1:numel(bars)
        bars(bar_id).FaceColor = color_for_series(legend_labels{bar_id});
        bars(bar_id).EdgeColor = [0.12 0.12 0.12];
        bars(bar_id).LineWidth = 0.8;
    end
    set(gca, 'XTickLabel', cellstr(tasks), 'LineWidth', 1.1);
    ylabel(ylabel_text, 'FontWeight', 'bold');
    title(title_text);
    ylim(ylim_values);
    legend(legend_labels, 'Box', 'off', 'Location', 'best');
    grid on;
end

function color = color_for_series(series_name)
    switch series_name
        case 'Previous Best'
            color = [0.82 0.83 0.85];
        case 'Single-Lattice'
            color = [0.29 0.53 0.91];
        case 'Multi-Lattice (Fused)'
            color = [0.90 0.57 0.22];
        otherwise
            color = [0.40 0.40 0.40];
    end
end

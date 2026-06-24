%% Fig. 3 single-lattice optical NGRC source-data reproduction
% This script reads the processed source data used for Fig. 3b-d in the
% manuscript and recomputes the reported single-lattice NMSE values.

clear; clc; close all;

repo_root = fileparts(fileparts(mfilename('fullpath')));
source_dir = fullfile(repo_root, 'data', 'figure_source_data');

prediction_files = [
    "Fig3b_SantaFe_single_lattice_prediction.csv"
    "Fig3c_NARMA10_single_lattice_prediction.csv"
    "Fig3d_Lorenz63_single_lattice_prediction.csv"
];

fprintf('\nFig. 3 single-lattice optical NGRC source-data reproduction\n');
fprintf('Source folder: %s\n\n', source_dir);

figure('Color', 'w', 'Position', [100, 100, 900, 720]);
tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');

for file_id = 1:numel(prediction_files)
    source_file = fullfile(source_dir, prediction_files(file_id));
    data = readtable(source_file, 'TextType', 'string');

    task_name = data.task(1);
    stored_nmse = first_finite_value(data.NMSE);
    recomputed_nmse = mean((data.ground_truth - data.prediction) .^ 2) ...
        / var(data.ground_truth);

    fprintf('%-8s stored NMSE: %.12f | recomputed NMSE: %.12f | rounded: %.4f\n', ...
        task_name, stored_nmse, recomputed_nmse, recomputed_nmse);

    nexttile;
    segment = 1:min(250, height(data));
    plot(data.sample_index(segment), data.ground_truth(segment), ...
        'k-', 'LineWidth', 1.4); hold on;
    plot(data.sample_index(segment), data.prediction(segment), ...
        '-', 'LineWidth', 1.1);
    title(sprintf('%s single-lattice prediction, NMSE = %.4f', ...
        task_name, recomputed_nmse));
    xlabel('Test sample');
    ylabel('Normalized target');
    legend({'Ground truth', 'Single lattice'}, 'Box', 'off', 'Location', 'best');
    grid on;
end

function value = first_finite_value(values)
    idx = find(isfinite(values), 1, 'first');
    assert(~isempty(idx), 'No finite NMSE value found in source data.');
    value = values(idx);
end

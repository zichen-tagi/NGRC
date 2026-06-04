%% Representative optical NGRC workflow demo
% This script demonstrates the computational workflow used in the manuscript.
% It uses synthetic placeholder data and does not reproduce the experimental
% numerical results reported in the paper.

clear; clc; close all;
rng(7);

%% Generate a synthetic nonlinear sequence
num_samples = 1800;
train_len = 1200;
memory_depth = 10;
ridge_alpha = 1e-4;

u = 0.5 + 0.5 * sin((1:num_samples + memory_depth)' * 0.037);
u = u + 0.08 * randn(size(u));
u = (u - min(u)) / (max(u) - min(u));

y = zeros(num_samples + memory_depth, 1);
for n = memory_depth + 1:num_samples + memory_depth
    delayed_sum = sum(y(n-memory_depth:n-1));
    y(n) = 0.25 * y(n-1) + 0.05 * y(n-1) * delayed_sum ...
        + 1.5 * u(n-memory_depth) * u(n-1) + 0.1;
end
y = y(memory_depth + 1:end);
y = (y - min(y)) / (max(y) - min(y));

%% Construct delayed input coordinates
delayed_inputs = zeros(num_samples, memory_depth);
for n = 1:num_samples
    idx = n + memory_depth;
    delayed_inputs(n, :) = u(idx:-1:idx-memory_depth+1);
end

%% Generate synthetic optical-like lattice feature matrices
% In the experiment, these matrices are measured from the temporal lattice.
% Here, deterministic random mixing and square-law detection mimic the role of
% lattice interference followed by photodetection.
num_features_single = 60;
num_lattices = 3;

single_feature_matrix = make_lattice_features(delayed_inputs, num_features_single, 1);

feature_blocks = cell(1, num_lattices);
for ell = 1:num_lattices
    feature_blocks{ell} = make_lattice_features(delayed_inputs, num_features_single, ell);
end
fused_feature_matrix = [feature_blocks{:}];

%% Train ridge readouts and evaluate NMSE
target_train = y(1:train_len);
target_test = y(train_len+1:end);

single_train = single_feature_matrix(1:train_len, :);
single_test = single_feature_matrix(train_len+1:end, :);
fused_train = fused_feature_matrix(1:train_len, :);
fused_test = fused_feature_matrix(train_len+1:end, :);

[single_prediction, single_nmse] = ridge_predict(single_train, target_train, ...
    single_test, target_test, ridge_alpha);
[fused_prediction, fused_nmse] = ridge_predict(fused_train, target_train, ...
    fused_test, target_test, ridge_alpha);

%% Feature-space diagnostics
single_stats = feature_space_diagnostics(single_train);
fused_stats = feature_space_diagnostics(fused_train);

fprintf('\nRepresentative optical NGRC workflow demo\n');
fprintf('Single-lattice NMSE: %.4f\n', single_nmse);
fprintf('Multi-lattice fused NMSE: %.4f\n', fused_nmse);
fprintf('\nSingle lattice:\n');
fprintf('D = %d\n', single_stats.D);
fprintf('effective rank = %.4f\n', single_stats.effective_rank);
fprintf('mean |corr| = %.4f\n', single_stats.mean_abs_corr);
fprintf('\nMulti-lattice:\n');
fprintf('D = %d\n', fused_stats.D);
fprintf('effective rank = %.4f\n', fused_stats.effective_rank);
fprintf('mean |corr| = %.4f\n', fused_stats.mean_abs_corr);

%% Plot a short prediction segment
figure('Color', 'w', 'Position', [100, 100, 900, 360]);
plot(target_test(1:250), 'k-', 'LineWidth', 1.5); hold on;
plot(single_prediction(1:250), '-', 'LineWidth', 1.2);
plot(fused_prediction(1:250), '-', 'LineWidth', 1.2);
legend({'Ground truth', 'Single lattice', 'Multi-lattice'}, 'Box', 'off');
xlabel('Test sample');
ylabel('Normalized target');
title('Representative prediction trace');
grid on;

%% Local functions
function features = make_lattice_features(delayed_inputs, num_features, lattice_id)
    rng(100 + lattice_id);
    input_dim = size(delayed_inputs, 2);
    linear_mixer = randn(input_dim, num_features);
    phase_bias = 0.4 * randn(1, num_features);
    mixed_field = delayed_inputs * linear_mixer + phase_bias;
    interference = sin(mixed_field + 0.25 * lattice_id) ...
        + 0.35 * cos(0.7 * mixed_field - 0.15 * lattice_id);
    features = interference .^ 2;
    features = features / max(abs(features(:)));
end

function [prediction, nmse] = ridge_predict(train_features, train_target, ...
        test_features, test_target, alpha)
    mu = mean(train_features, 1);
    sigma = std(train_features, 0, 1);
    sigma(sigma == 0) = 1;
    train_features = (train_features - mu) ./ sigma;
    test_features = (test_features - mu) ./ sigma;

    train_design = [ones(size(train_features, 1), 1), train_features];
    test_design = [ones(size(test_features, 1), 1), test_features];
    identity_matrix = eye(size(train_design, 2));
    identity_matrix(1, 1) = 0;

    weights = (train_design' * train_design + alpha * identity_matrix) ...
        \ (train_design' * train_target);
    prediction = test_design * weights;
    nmse = mean((test_target - prediction).^2) / var(test_target);
end

function stats = feature_space_diagnostics(feature_matrix)
    feature_matrix = feature_matrix - mean(feature_matrix, 1);
    sigma = std(feature_matrix, 0, 1);
    valid_columns = sigma > 0 & isfinite(sigma);
    feature_matrix = feature_matrix(:, valid_columns);
    sigma = sigma(valid_columns);
    feature_matrix = feature_matrix ./ sigma;

    stats.D = size(feature_matrix, 2);
    singular_values = svd(feature_matrix, 'econ');
    probabilities = singular_values / sum(singular_values);
    stats.effective_rank = exp(-sum(probabilities .* log(probabilities + eps)));

    correlation_matrix = corrcoef(feature_matrix);
    off_diagonal = ~eye(size(correlation_matrix));
    correlation_values = abs(correlation_matrix(off_diagonal));
    stats.mean_abs_corr = mean(correlation_values(isfinite(correlation_values)));
end


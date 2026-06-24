%% Representative single-lattice optical NGRC demo
% This script demonstrates the single-lattice branch of the optical NGRC
% workflow using synthetic placeholder data. It does not reproduce the
% experimental numerical results reported in the manuscript.

clear; clc; close all;
rng(7);

%% Generate a synthetic nonlinear sequence
num_samples = 1800;
train_len = 1200;
memory_depth = 10;
ridge_alpha = 1;

[input_sequence, target_sequence] = make_synthetic_sequence(num_samples, memory_depth);
delayed_inputs = make_delayed_inputs(input_sequence, num_samples, memory_depth);

%% Generate one optical-like lattice feature matrix
% In the experiment, this feature matrix is measured from one temporal-lattice
% configuration. Here, deterministic random mixing and square-law detection
% mimic interference in the lattice followed by photodetection.
num_features = 15;
single_feature_matrix = make_lattice_features(delayed_inputs, num_features, 1);

%% Train the ridge readout and evaluate prediction error
target_train = target_sequence(1:train_len);
target_test = target_sequence(train_len+1:end);
single_train = single_feature_matrix(1:train_len, :);
single_test = single_feature_matrix(train_len+1:end, :);

[single_prediction, single_nmse] = ridge_predict(single_train, target_train, ...
    single_test, target_test, ridge_alpha);

single_stats = feature_space_diagnostics(single_train);

fprintf('\nSingle-lattice optical NGRC demo\n');
fprintf('Single-lattice NMSE: %.4f\n', single_nmse);
fprintf('D = %d\n', single_stats.D);
fprintf('effective rank = %.4f\n', single_stats.effective_rank);
fprintf('mean |corr| = %.4f\n', single_stats.mean_abs_corr);

%% Plot a short prediction segment
figure('Color', 'w', 'Position', [100, 100, 900, 360]);
plot(target_test(1:250), 'k-', 'LineWidth', 1.5); hold on;
plot(single_prediction(1:250), '-', 'LineWidth', 1.2);
legend({'Ground truth', 'Single lattice'}, 'Box', 'off');
xlabel('Test sample');
ylabel('Normalized target');
title('Single-lattice prediction trace');
grid on;

%% Local functions
function [input_sequence, target_sequence] = make_synthetic_sequence(num_samples, memory_depth)
    input_sequence = 0.5 + 0.5 * sin((1:num_samples + memory_depth)' * 0.037);
    input_sequence = input_sequence + 0.08 * randn(size(input_sequence));
    input_sequence = 0.35 * (input_sequence - min(input_sequence)) ...
        / (max(input_sequence) - min(input_sequence));

    target_full = zeros(num_samples + memory_depth, 1);
    for n = memory_depth + 1:num_samples + memory_depth
        delayed_sum = sum(target_full(n-memory_depth:n-1));
        target_full(n) = 0.25 * target_full(n-1) ...
            + 0.05 * target_full(n-1) * delayed_sum ...
            + 1.5 * input_sequence(n-memory_depth) * input_sequence(n-1) + 0.1;
    end
    target_sequence = target_full(memory_depth + 1:end);
    target_sequence = (target_sequence - min(target_sequence)) ...
        / (max(target_sequence) - min(target_sequence));
end

function delayed_inputs = make_delayed_inputs(input_sequence, num_samples, memory_depth)
    delayed_inputs = zeros(num_samples, memory_depth);
    for n = 1:num_samples
        idx = n + memory_depth;
        delayed_inputs(n, :) = input_sequence(idx:-1:idx-memory_depth+1);
    end
end

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

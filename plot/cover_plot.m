% MATLAB Code for SystemVerilog Coverage Analysis
% Load and analyze coverage data with penalty-based skewing

%% Load and Parse Data

% Read the CSV file (assuming format: CoverpointA, CoverpointB, TestCase, Penalty)
filename = 'csv cover data.txt'; % Update with your file path
data = readmatrix(filename);

% Extract columns (adjust based on your actual file format)
coverpointA = data(:,1);
coverpointB = data(:,2);
testcases = data(:,3);
penalty = data(:,4);

% Get unique penalty values
unique_penalties = unique(penalty);
num_penalties = length(unique_penalties);

%% Define colors for consistent plotting
colors = [
    0.4940, 0.1840, 0.5560;  % Purple (Penalty 0)
    0.4660, 0.6740, 0.1880;  % Green (Penalty 5)
    1.0000, 0.8431, 0.0000;  % Gold (Penalty 10)
    1.0000, 0.4706, 0.0000;  % Orange (Penalty 25)
    0.5294, 0.8078, 0.9216;  % Light Blue (Penalty 50)
    0.9412, 0.5882, 0.6471;  
];

%% Plot 1: Coverage vs Test Cases by Penalty
figure('Position', [100, 100, 1200, 800]);

% Subplot 1: Coverpoint A
subplot(1,2,1);
hold on;
for i = 1:num_penalties
    idx = penalty == unique_penalties(i);
    plot(testcases(idx), coverpointA(idx), 'LineWidth', 2, 'Color', colors(i,:), ...
         'DisplayName', sprintf('Penalty %d', unique_penalties(i)));
end
xlabel('Test Cases');
ylabel('Coverage %');
title('Coverpoint A vs Test Cases');
legend('Location', 'southeast');
grid on;
ylim([0 105]);

% Subplot 2: Coverpoint B
subplot(1,2,2);
hold on;
for i = 1:num_penalties
    idx = penalty == unique_penalties(i);
    plot(testcases(idx), coverpointB(idx), 'LineWidth', 2, 'Color', colors(i,:), ...
         'DisplayName', sprintf('Penalty %d', unique_penalties(i)));
end
xlabel('Test Cases');
ylabel('Coverage %');
title('Coverpoint B vs Test Cases');
legend('Location', 'southeast');
grid on;
ylim([0 105]);

sgtitle('SystemVerilog Coverage Analysis by Penalty Values', 'FontSize', 16, 'FontWeight', 'bold');

%% Plot 2: Coverage Efficiency Analysis
% % Calculate AUC Efficiency for each penalty
auc_efficiency = zeros(num_penalties, 3); % [penalty, auc_efficiency_A, auc_efficiency_B]

for i = 1:num_penalties
    idx = penalty == unique_penalties(i);
    penalty_data_a = coverpointA(idx);
    penalty_data_b = coverpointB(idx);
    penalty_testcases = testcases(idx);
    
    auc_efficiency(i,1) = unique_penalties(i);
    
    % Calculate Area Under Curve for Coverpoint A
    max_testcases = max(penalty_testcases);
    auc_a = trapz(penalty_testcases, penalty_data_a);
    max_possible_auc = max_testcases * 100;
    auc_efficiency(i,2) = (auc_a / max_possible_auc) * 100; % Normalized AUC percentage for A
    
    % Calculate Area Under Curve for Coverpoint B
    auc_b = trapz(penalty_testcases, penalty_data_b);
    auc_efficiency(i,3) = (auc_b / max_possible_auc) * 100; % Normalized AUC percentage for B
end

figure;

plot(auc_efficiency(:,1), auc_efficiency(:,2), 'o-', 'LineWidth', 2, 'MarkerSize', 8, ...
     'DisplayName', 'Coverpoint A');
hold on;
plot(auc_efficiency(:,1), auc_efficiency(:,3), 's-', 'LineWidth', 2, 'MarkerSize', 8, ...
     'DisplayName', 'Coverpoint B');

xlabel('Penalty Value');
ylabel('Coverage Efficiency');
title('Coverage Efficiency vs Penalty (Separate for A and B)');
grid on;

%% Plot 3: Saturation Point Analysis
saturation_threshold = 100; % Adjust as needed

saturation_data = zeros(num_penalties, 3); % [penalty, saturation_testcases_A, saturation_testcases_B]

for i = 1:num_penalties
    idx = penalty == unique_penalties(i);
    penalty_data_a = coverpointA(idx);
    penalty_data_b = coverpointB(idx);
    penalty_testcases = testcases(idx);
    
    saturation_data(i,1) = unique_penalties(i);
    
    % Find saturation point for Coverpoint A
    sat_idx_a = find(penalty_data_a >= saturation_threshold, 1, 'first');
    if ~isempty(sat_idx_a)
        saturation_data(i,2) = penalty_testcases(sat_idx_a);
    else
        saturation_data(i,2) = NaN; % Didn't reach saturation
    end
    
    % Find saturation point for Coverpoint B
    sat_idx_b = find(penalty_data_b >= saturation_threshold, 1, 'first');
    if ~isempty(sat_idx_b)
        saturation_data(i,3) = penalty_testcases(sat_idx_b);
    else
        saturation_data(i,3) = NaN; % Didn't reach saturation
    end
end

figure('Position', [200, 200, 1000, 600]);
plot(saturation_data(:,1), saturation_data(:,2), 'o-', 'LineWidth', 2, 'MarkerSize', 8, ...
     'Color', [0.2, 0.6, 0.8], 'MarkerFaceColor', [0.2, 0.6, 0.8], 'DisplayName', 'Coverpoint A');
hold on;
plot(saturation_data(:,1), saturation_data(:,3), 's-', 'LineWidth', 2, 'MarkerSize', 8, ...
     'Color', [0.8, 0.4, 0.2], 'MarkerFaceColor', [0.8, 0.4, 0.2], 'DisplayName', 'Coverpoint B');

xlabel('Penalty Value');
ylabel('Test Cases to Saturation');
title('Saturation Convergence Analysis');
legend('Location', 'best');
grid on;


%% Save plots

print(figure(1), 'coverage_curves', '-dpng', '-r300');
print(figure(2), 'penalty_effectiveness', '-dpng', '-r300');
print(figure(3), 'saturation_analysis', '-dpng', '-r300');
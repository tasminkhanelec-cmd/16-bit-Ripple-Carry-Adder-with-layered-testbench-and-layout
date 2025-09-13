% Directory containing the files
baseDir = 'E:\OneDrive - BUET\4-2\VLSI\project\reports';
filePattern = fullfile(baseDir, '*.txt');
files = dir(filePattern); % Get all files in the directory

% Initialize arrays to store results
clk = [];
in_delay = [];
out_delay = [];
power = [];
area = [];
time = [];

% Extract all unique combinations of clk, ipd, and opd from the filenames
combinations = struct(); % Use a structure to group by clk, ipd, opd
for k = 1:length(files)
    tokens = regexp(files(k).name, '^(area|power|time)_clk_(\d+)_ipd_(\d+\.?\d*)_opd_(\d+\.?\d*)\.txt$', 'tokens');
    if ~isempty(tokens)
        prefix = tokens{1}{1};
        clk_val = str2double(tokens{1}{2});
        ipd_val = str2double(tokens{1}{3});
        opd_val = str2double(tokens{1}{4});

        % Create a unique key for each combination
        key = sprintf('clk_%d_ipd_%g_opd_%g', clk_val, ipd_val, opd_val);
        % Replace periods in the key with 'p' to make it a valid field name
        key = strrep(key, '.', 'p');    
        
        % Group files by their unique combination
        if ~isfield(combinations, key)
            combinations.(key) = struct('clk', clk_val, 'ipd', ipd_val, 'opd', opd_val, ...
                                        'areaFile', '', 'powerFile', '', 'timeFile', '');
        end
        
        % Assign the file to the appropriate field
        if strcmp(prefix, 'area')
            combinations.(key).areaFile = fullfile(baseDir, files(k).name);
        elseif strcmp(prefix, 'power')
            combinations.(key).powerFile = fullfile(baseDir, files(k).name);
        elseif strcmp(prefix, 'time')
            combinations.(key).timeFile = fullfile(baseDir, files(k).name);
        end
    end
end

% Process each unique combination
fields = fieldnames(combinations);
for i = 1:length(fields)
    combo = combinations.(fields{i});
    
    % Extract values for the combination
    clk_val = combo.clk;
    ipd_val = combo.ipd;
    opd_val = combo.opd;
    
    % Initialize default values
    area_val = NaN;
    power_val = NaN;
    time_val = NaN;

    % Read area file
    if ~isempty(combo.areaFile)
        fileData = fileread(combo.areaFile);
        areaMatch = regexp(fileData, 'RippleCarryAdder\s+\d+\s+\d+\s+\d+\s+(\d+)\s+<none>', 'tokens');
        if ~isempty(areaMatch)
            area_val = str2double(areaMatch{1}{1});
        end
    end

    % Read power file
    if ~isempty(combo.powerFile)
        fileData = fileread(combo.powerFile);
        powerMatch = regexp(fileData, 'RippleCarryAdder\s+\d+\s+\d+\.\d+\s+\d+\.\d+\s+\d+\.\d+\s+\d+\.\d+\s+(\d+\.\d+)', 'tokens');
        if ~isempty(powerMatch)
            power_val = str2double(powerMatch{1}{1});
        end
    end

    % Read time file
    if ~isempty(combo.timeFile)
        fileData = fileread(combo.timeFile);
        timeMatches = regexp(fileData, 'Arrival Time\s+(\d+)', 'tokens');
        if ~isempty(timeMatches) % Ensure at least one match exists
            time_val = str2double(timeMatches{1}{1}); % Use the first occurrence
        end
    end


    % Store the values
    clk = [clk; clk_val];
    in_delay = [in_delay; ipd_val];
    out_delay = [out_delay; opd_val];
    area = [area; area_val];
    power = [power; power_val];
    time = [time; time_val];
end

% Combine results into a table
resultsTable = table(clk, in_delay, out_delay, area, power, time, ...
    'VariableNames', {'ClockPeriod', 'InputDelay', 'OutputDelay', 'Area', 'Power', 'Time'});

% Compute the parent directory of the reports folder
parentDir = fileparts(baseDir);

% Save the table to the parent directory
outputFile = fullfile(parentDir, 'extracted_results.csv');
writetable(resultsTable, outputFile);

disp(['Data extraction complete. Results saved to ', outputFile]);


%%

% Load data from the file
file_name = 'E:\OneDrive - BUET\4-2\VLSI\project\extracted_results.csv';
data = readtable(file_name);

% Add frequency column in MHz (Clock Period is in nanoseconds)
data.Frequency_MHz = 1 ./ (data.ClockPeriod * 1e-3);

% Normalize the last three columns (assuming columns are: Time, Power, Area)
normalized_time = (data.Time - min(data.Time)) / (max(data.Time) - min(data.Time));
normalized_power = (data.Power - min(data.Power)) / (max(data.Power) - min(data.Power));
normalized_area = (data.Area) / max(data.Area);

% Add normalized columns back to the table
data.Normalized_Time = normalized_time;
data.Normalized_Power = normalized_power;
data.Normalized_Area = normalized_area;

% Calculate the weighted sum (60% Time, 20% Power, 20% Area)
data.Weighted_Sum = 0.6 * data.Normalized_Time + 0.2 * data.Normalized_Power + 0.2 * data.Normalized_Area;

% Save the updated table with normalized values and weighted sum back to the file
updated_file_name = 'E:\OneDrive - BUET\4-2\VLSI\project\normalized_results.xlsx';
writetable(data, updated_file_name);

% Find the row corresponding to the minimum weighted sum
[min_weighted_sum, min_index] = min(data.Weighted_Sum);
min_frequency = data.Frequency_MHz(min_index);
min_input_delay = data.InputDelay(min_index);
min_output_delay = data.OutputDelay(min_index);

% Display the results
fprintf('Minimum Weighted Sum: %f\n', min_weighted_sum);
fprintf('Corresponding Frequency (MHz): %f\n', min_frequency);
fprintf('Corresponding Input Delay (ns): %f\n', min_input_delay);
fprintf('Corresponding Output Delay (ns): %f\n', min_output_delay);


%%
% Load data from the file
file_name = 'E:\OneDrive - BUET\4-2\VLSI\project\normalized_results.xlsx';
data = readtable(file_name);

% Extract the necessary columns
frequency = data.Frequency_MHz;
input_delay = data.InputDelay;
output_delay = data.OutputDelay;
weighted_sum = data.Weighted_Sum;

% Create a 3D scatter plot with log-transformed frequency
scatter3(log10(frequency), input_delay, output_delay, 50, weighted_sum, 'filled', 'MarkerFaceAlpha', 0.8);
ax = gca;
ax.Position(3) = ax.Position(3) - 0.1; % Reduce width
ax.Position(4) = ax.Position(4) - 0.1; % Reduce height
ax.Position(1) = ax.Position(1) + 0.05; % Shift left for balance % Reduce the width of the 3D plot
colormap(jet);
cb = colorbar;
cb.Position(1) = cb.Position(1) + 0.15; % Adjust gap to ensure colorbar stays within figure window % Add gap between plot and colorbar
cb.Label.String = 'Weighted Sum';


% Label axes
xlabel('Frequency (MHz)');
ylabel('Input Delay (ns)');
zlabel('Output Delay (ns)');

% Update x-axis ticks and labels to show actual frequencies
xticks([0, 1, 2, 3]); % Log10 values for 1, 10, 100, 1000
xticklabels({'1 MHz', '10 MHz', '100 MHz', '1000 MHz'});

title({'3D Scatter Plot: Frequency vs Input/Output Delays', ...
       'Weighted Sum = 0.6 * Normalized Time + 0.2 * Normalized Power + 0.2 * Normalized Area'}, 'FontSize', 12, 'Units', 'normalized', 'Position', [0.5, 1.05, 0]);


%%

clc;
clear all;

% Load data from the file
file_name = 'E:\OneDrive - BUET\4-2\VLSI\project\normalized_results.xlsx';
data = readtable(file_name);

% Extract the necessary columns
frequency = data.Frequency_MHz;
input_delay = data.InputDelay;
output_delay = data.OutputDelay;
power = data.Power;
time = data.Time;
area = data.Area;

% Find unique values and sort them
unique_ipd = sort(unique(input_delay));
unique_opd = sort(unique(output_delay));
unique_freq = sort(unique(frequency));

% Determine middle values based on index
middle_ipd_index = ceil(length(unique_ipd) / 2);
middle_opd_index = ceil(length(unique_opd) / 2);
middle_freq_index = ceil(length(unique_freq) / 2);

middle_ipd = unique_ipd(middle_ipd_index);
middle_opd = unique_opd(middle_opd_index);
middle_freq = unique_freq(middle_freq_index);

% Filter data for Frequency plots (keeping Input Delay and Output Delay fixed)
filtered_freq_data = data(input_delay == middle_ipd & output_delay == middle_opd, :);

% Extract filtered values
filtered_frequency = filtered_freq_data.Frequency_MHz;
filtered_power_freq = filtered_freq_data.Power;
filtered_time_freq = filtered_freq_data.Time;
filtered_area_freq = filtered_freq_data.Area;

% Filter data for Input Delay plots (keeping Frequency and Output Delay fixed)
filtered_ipd_data = data(frequency == middle_freq & output_delay == middle_opd, :);

% Extract filtered values
filtered_ipd = filtered_ipd_data.InputDelay;
filtered_power_ipd = filtered_ipd_data.Power;
filtered_time_ipd = filtered_ipd_data.Time;
filtered_area_ipd = filtered_ipd_data.Area;

% Filter data for Output Delay plots (keeping Frequency and Input Delay fixed)
filtered_opd_data = data(frequency == middle_freq & input_delay == middle_ipd, :);

% Extract filtered values
filtered_opd = filtered_opd_data.OutputDelay;
filtered_power_opd = filtered_opd_data.Power;
filtered_time_opd = filtered_opd_data.Time;
filtered_area_opd = filtered_opd_data.Area;

%Plot against Frequency (Fixed Input Delay and Output Delay)
figure;

% Add overall title for the figure
sgtitle(sprintf('Plots for Fixed Input Delay = %.2f ns and Output Delay = %.2f ns', middle_ipd, middle_opd));

% Subplot 1: Power vs Frequency
subplot(1, 3, 1);
scatter(log10(filtered_frequency), filtered_power_freq, 'filled'); % Filled circles
xlabel('Frequency (MHz)');
ylabel('Power');
xticks([0, 1, 2, 3]); % Log10 values for 1, 10, 100, 1000
xticklabels({'1 MHz', '10 MHz', '100 MHz', '1000 MHz'});
title('Power vs Frequency');
grid on;

% Subplot 2: Delay Time vs Frequency
subplot(1, 3, 2);
scatter(log10(filtered_frequency), filtered_time_freq, 'filled'); % Filled circles
xlabel('Frequency (MHz)');
ylabel('Delay Time (ns)');
xticks([0, 1, 2, 3]); % Log10 values for 1, 10, 100, 1000
xticklabels({'1 MHz', '10 MHz', '100 MHz', '1000 MHz'});
title('Delay Time vs Frequency');
grid on;

% Subplot 3: Area vs Frequency
subplot(1, 3, 3);
scatter(log10(filtered_frequency), filtered_area_freq, 'filled'); % Filled circles
xlabel('Frequency (MHz)');
ylabel('Area');
xticks([0, 1, 2, 3]); % Log10 values for 1, 10, 100, 1000
xticklabels({'1 MHz', '10 MHz', '100 MHz', '1000 MHz'});
title('Area vs Frequency');
grid on;

%Plot against Input Delay (Fixed Frequency and Output Delay)
figure;

% Add overall title for the figure
sgtitle(sprintf('Plots for Fixed Frequency = %.2f MHz and Output Delay = %.2f ns', middle_freq, middle_opd));

% Subplot 1: Power vs Input Delay
subplot(1, 3, 1);
scatter(filtered_ipd, filtered_power_ipd, 'filled'); % Filled circles
xlabel('Input Delay (ns)');
ylabel('Power');
title('Power vs Input Delay');
grid on;

% Subplot 2: Delay Time vs Input Delay
subplot(1, 3, 2);
scatter(filtered_ipd, filtered_time_ipd, 'filled'); % Filled circles
xlabel('Input Delay (ns)');
ylabel('Delay Time (ns)');
title('Delay Time vs Input Delay');
grid on;

% Subplot 3: Area vs Input Delay
subplot(1, 3, 3);
scatter(filtered_ipd, filtered_area_ipd, 'filled'); % Filled circles
xlabel('Input Delay (ns)');
ylabel('Area');
title('Area vs Input Delay');
grid on;

% Plot against Output Delay (Fixed Frequency and Input Delay)
figure;

% Add overall title for the figure
sgtitle(sprintf('Plots for Fixed Frequency = %.2f MHz and Input Delay = %.2f ns', middle_freq, middle_ipd));

% Subplot 1: Power vs Output Delay
subplot(1, 3, 1);
scatter(filtered_opd, filtered_power_opd, 'filled'); % Filled circles
xlabel('Output Delay (ns)');
ylabel('Power');
title('Power vs Output Delay');
grid on;

% Subplot 2: Delay Time vs Output Delay
subplot(1, 3, 2);
scatter(filtered_opd, filtered_time_opd, 'filled'); % Filled circles
xlabel('Output Delay (ns)');
ylabel('Delay Time (ns)');
title('Delay Time vs Output Delay');
grid on;

% Subplot 3: Area vs Output Delay
subplot(1, 3, 3);
scatter(filtered_opd, filtered_area_opd, 'filled'); % Filled circles
xlabel('Output Delay (ns)');
ylabel('Area');
title('Area vs Output Delay');
grid on;

%%

% Data
testcase = [100, 500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 11000, 12000];
A = [9.47, 39.94, 62.7, 86.62, 95.51, 98.24, 99.71, 99.9, 100, 100, 100, 100, 100, 100];
B = [9.28, 38.48, 63.67, 84.86, 95.12, 98.14, 99.21, 99.8, 100, 100, 100, 100, 100, 100];
Cin = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100];
total = [54.415, 69.1894, 76.845, 84.73, 88.74, 90.72, 92.04, 93.07, 93.89, 94.58, 95.18, 95.69, 96.19, 96.6];

% Plot A coverage percentage
figure;
plot(testcase, A, '-o');
xlabel('Testcase Number');
ylabel('A Coverage Percentage');
title('A Coverage vs Testcase Number');
grid on;

% Plot B coverage percentage
figure;
plot(testcase, B, '-o');
xlabel('Testcase Number');
ylabel('B Coverage Percentage');
title('B Coverage vs Testcase Number');
grid on;

% Plot Cin coverage percentage
figure;
plot(testcase, Cin, '-o');
xlabel('Testcase Number');
ylabel('Cin Coverage Percentage');
title('Cin Coverage vs Testcase Number');
grid on;

% Plot Total coverage percentage
figure;
plot(testcase, total, '-o');
xlabel('Testcase Number');
ylabel('Total functional Coverage Percentage');
title('Total functional Coverage vs Testcase Number');
grid on;

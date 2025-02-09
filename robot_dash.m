%% Nuclear Hazard Monitoring Dashboard
% Create UI Figure
fig = uifigure('Name', 'Nuclear Hazard Monitoring', 'Position', [100, 100, 1000, 600]);
%% 📌 Battery Indicator
batteryLabel = uilabel(fig, 'Text', 'Battery Level:', 'Position', [10, 560, 100, 25]);
batteryBar = uibutton(fig, 'Position', [120, 560, 150, 25], 'BackgroundColor', 'g', 'Text', '');
%% 📊 Radiation Level Plot
radiationAxes = uiaxes(fig, 'Position', [50, 350, 300, 150]);
title(radiationAxes, 'Radiation Levels');
xlabel(radiationAxes, 'Time (s)');
ylabel(radiationAxes, 'Radiation (mSv)');
hold(radiationAxes, 'on');
%% 🌡️ Temperature & Pressure Graph
tempPresAxes = uiaxes(fig, 'Position', [400, 350, 250, 150]);
yyaxis(tempPresAxes, 'left');
ylabel(tempPresAxes, 'Temperature (°C)');
yyaxis(tempPresAxes, 'right');
ylabel(tempPresAxes, 'Pressure (bar)');
xlabel(tempPresAxes, 'Time (s)');
title(tempPresAxes, 'Temp & Pressure');
hold(tempPresAxes, 'on');
%% 🏭 Gas Leak Detection
gasAxes = uiaxes(fig, 'Position', [50, 120, 300, 150]);
title(gasAxes, 'Gas Leak Levels');
xlabel(gasAxes, 'Plant Sections');
ylabel(gasAxes, 'Concentration (ppm)');
xticklabels(gasAxes, {'Core', 'Turbine', 'Cooling', 'Storage', 'Vent'});
%% 📡 Vibration Analysis (FFT)
vibAxes = uiaxes(fig, 'Position', [400, 120, 250, 150]);
title(vibAxes, 'Vibration Analysis');
xlabel(vibAxes, 'Frequency (Hz)');
ylabel(vibAxes, 'Amplitude');
hold(vibAxes, 'on');
%% ⚠️ Hazard Alerts
alertLabel = uilabel(fig, 'Text', 'Hazard Alerts:', 'Position', [10, 80, 100, 25]);
alertText = uilabel(fig, 'Position', [120, 80, 250, 25], 'Text', 'No hazards detected.');
%% 🔄 Real-Time Data Simulation
radiationData = zeros(1, 100);
tempData = zeros(1, 100);
pressureData = zeros(1, 100);
for t = 1:100
    % 🛠️ Battery Level Update
    batteryLevel = max(80 - t * 0.5, 5);
    batteryBar.BackgroundColor = [batteryLevel/100, (100-batteryLevel)/100, 0];
    % ☢️ Radiation Level
    radiationData(t) = rand() * 5 + 2; % Radiation 2-7 mSv
    plot(radiationAxes, 1:t, radiationData(1:t), '-b', 'LineWidth', 2);
    ylim(radiationAxes, [0, 10]);
    % 🌡️ Temperature & Pressure
    tempData(t) = 150 + rand() * 20; % 150-170°C
    pressureData(t) = 2.5 + rand() * 0.5; % 2.5-3.0 bar
    yyaxis(tempPresAxes, 'left');
    plot(tempPresAxes, 1:t, tempData(1:t), '-r', 'LineWidth', 2);
    yyaxis(tempPresAxes, 'right');
    plot(tempPresAxes, 1:t, pressureData(1:t), '-b', 'LineWidth', 2);
    
    % 🏭 Gas Leak
    gasLevels = rand(1, 5) * 30; % 0-30 ppm
    bar(gasAxes, gasLevels, 'r');
    
    % 📡 Vibration Analysis (FFT)
    vibData = randn(1, 50); % Simulated vibration
    freqData = abs(fft(vibData));
    plot(vibAxes, freqData, '-k', 'LineWidth', 2);
    ylim(vibAxes, [0, 10]);
    
    % ⚠️ Hazard Alerts
    if max(gasLevels) > 20
        alertText.Text = '⚠️ High Gas Concentration!';
        alertText.FontColor = 'r';
    elseif tempData(t) > 165
        alertText.Text = '⚠️ High Temperature!';
        alertText.FontColor = 'r';
    elseif radiationData(t) > 6
        alertText.Text = '⚠️ Radiation Warning!';
        alertText.FontColor = 'r';
    else
        alertText.Text = '✅ No hazards detected.';
        alertText.FontColor = 'g';
    end
    pause(0.5);
end
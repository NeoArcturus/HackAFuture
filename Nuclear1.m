clear; close all; clc;

% Initialize MATLAB UI - Robotic Console Style
fig = uifigure('Name', 'Nuclear SLAM Hazard Detection', 'Position', [100, 100, 1000, 700], 'Color', [0.1 0.1 0.1]);

% Live Feed Section (Left Side)
liveFeedPanel = uipanel(fig, 'Title', 'Live Feed', 'FontSize', 14, 'ForegroundColor', 'w', ...
    'Position', [20 400 450 225], 'BackgroundColor', [0.2 0.2 0.2]);
ax = axes(liveFeedPanel, 'Position', [0.05 0.05 0.9 0.9]);

% Mock LIDAR Greyscale Image Section (Below Live Feed)
lidarPanel = uipanel(fig, 'Title', 'LIDAR Greyscale Image', 'FontSize', 14, 'ForegroundColor', 'w', ...
    'Position', [20 120 450 225], 'BackgroundColor', [0.2 0.2 0.2]);
axLidar = axes(lidarPanel, 'Position', [0.05 0.05 0.9 0.9]);

% Robot Stats & Hazard Detection Console (Right Side)
consolePanel = uipanel(fig, 'Title', 'Robot Status Console', 'FontSize', 14, 'ForegroundColor', 'w', ...
    'Position', [500 120 450 500], 'BackgroundColor', [0.2 0.2 0.2]); % Resized the console panel to match others

% Console Labels & Fields (Monospace font)
robotStatsLabel = uilabel(consolePanel, 'Text', 'Robot Status:', ...
    'Position', [20 460 150 20], 'FontSize', 14, 'FontColor', 'w', 'FontWeight', 'bold');
robotStats = uilabel(consolePanel, 'Text', 'Active', ...
    'Position', [180 460 150 20], 'FontSize', 14, 'FontColor', 'g', 'FontWeight', 'bold');

hazardLabel = uilabel(consolePanel, 'Text', 'Hazard Alerts:', ...
    'Position', [20 420 150 20], 'FontSize', 14, 'FontColor', 'w', 'FontWeight', 'bold');
hazardText = uilabel(consolePanel, 'Text', 'No hazards detected.', ...
    'Position', [20 400 400 20], 'FontSize', 14, 'FontColor', 'g', 'FontWeight', 'bold', 'FontName', 'Courier');

motionLabel = uilabel(consolePanel, 'Text', 'Motion Vectors (x, y, z):', ...
    'Position', [20 360 150 20], 'FontSize', 14, 'FontColor', 'w', 'FontWeight', 'bold');
motionText = uilabel(consolePanel, 'Text', '(0.00, 0.00, 0.00)', ...
    'Position', [180 360 250 20], 'FontSize', 14, 'FontColor', 'c', 'FontWeight', 'bold', 'FontName', 'Courier');

% Mock Robot Data in Console
robotMockDataLabel = uilabel(consolePanel, 'Text', 'Mock Robot Data:', ...
    'Position', [20 320 150 20], 'FontSize', 14, 'FontColor', 'w', 'FontWeight', 'bold');
robotMockData = uilabel(consolePanel, 'Text', 'Speed: 0.5 m/s, Direction: North', ...
    'Position', [180 320 250 20], 'FontSize', 14, 'FontColor', 'b', 'FontWeight', 'bold', 'FontName', 'Courier');

% Additional Robot Stats
tempLabel = uilabel(consolePanel, 'Text', 'Temperature:', ...
    'Position', [20 280 150 20], 'FontSize', 14, 'FontColor', 'w', 'FontWeight', 'bold');
temperature = uilabel(consolePanel, 'Text', '35°C', ...
    'Position', [180 280 250 20], 'FontSize', 14, 'FontColor', 'y', 'FontWeight', 'bold', 'FontName', 'Courier');

batteryLabel = uilabel(consolePanel, 'Text', 'Battery:', ...
    'Position', [20 240 150 20], 'FontSize', 14, 'FontColor', 'w', 'FontWeight', 'bold');
batteryPercentage = uilabel(consolePanel, 'Text', '85%', ...
    'Position', [180 240 250 20], 'FontSize', 14, 'FontColor', 'g', 'FontWeight', 'bold', 'FontName', 'Courier');

memoryLabel = uilabel(consolePanel, 'Text', 'Memory Usage:', ...
    'Position', [20 200 150 20], 'FontSize', 14, 'FontColor', 'w', 'FontWeight', 'bold');
memoryUsage = uilabel(consolePanel, 'Text', '3.4 GB / 8 GB', ...
    'Position', [180 200 250 20], 'FontSize', 14, 'FontColor', 'c', 'FontWeight', 'bold', 'FontName', 'Courier');

% Thermal Sensor Graph Section (Right Panel, Below Robot Stats)
thermalPanel = uipanel(fig, 'Title', 'Thermal Sensor Graph', 'FontSize', 14, 'ForegroundColor', 'w', ...
    'Position', [500 120 450 225], 'BackgroundColor', [0.2 0.2 0.2]);
axThermal = axes(thermalPanel, 'Position', [0.05 0.05 0.9 0.9]);

% Initialize Camera for Live Feed
cam = webcam; 
disp('Camera initialized.');

% Node.js API URL for hazard detection
apiUrl = 'http://localhost:3000/api/detect-hazard'; % Replace with your Node.js server URL

% Image Save Path (for Overwriting)
imageFilename = 'real_image.jpg';
imagePath = fullfile(pwd, 'uploads', imageFilename);
if ~exist(fullfile(pwd, 'uploads'), 'dir')
    mkdir(fullfile(pwd, 'uploads'));
end

% Run Detection Loop
for t = 1:100
    % Simulate Motion (for visualization)
    deltaPose = [randn * 0.2; randn * 0.2; randn * 0.05];
    motionText.Text = sprintf('(%.2f, %.2f, %.2f)', deltaPose(1), deltaPose(2), deltaPose(3));

    % Mock Robot Data Update
    robotMockData.Text = sprintf('Speed: %.2f m/s, Direction: %s', rand * 1.5, getRandomDirection());

    % Mock Robot Stats Update (Temperature, Battery, Memory)
    temperature.Text = sprintf('%.1f°C', 30 + rand * 10);  % Simulate random temperature (30-40°C)
    batteryPercentage.Text = sprintf('%d%%', randi([60, 100]));  % Simulate random battery percentage (60-100%)
    memoryUsage.Text = sprintf('%.1f GB / 8 GB', rand * 8);  % Simulate random memory usage

    % Capture Image
    realImage = snapshot(cam);

    % Save Image
    try
        imwrite(realImage, imagePath, 'JPEG');
        disp(['Captured image: ', imagePath]);
    catch
        error('Failed to save image.');
    end

    % Mock LIDAR Data: Convert live feed image to greyscale for LIDAR simulation
    mockLidarImage = rgb2gray(realImage);  % Convert the live feed image to greyscale
    
    % Resize the greyscale image to match the live feed's size
    mockLidarImage = imresize(mockLidarImage, [size(realImage, 1), size(realImage, 2)]);  % Ensure same dimensions

    % Mock Thermal Sensor Data: Generate a simulated thermal graph (e.g., temperature readings)
    mockThermalData = rand(1, 100) * 100;  % Simulate 100 temperature readings (0-100°C)

    % Send Image to Node.js API
    try
        data = struct('image_path', imagePath);
        options = weboptions('MediaType', 'application/json', 'ContentType', 'json', 'Timeout', 100);
        response = webwrite(apiUrl, data, options);
        disp(response);

        % Extract hazard information
        fireConfidence = response.fire_confidence_level;
        crackConfidence = response.crack_confidence_level;
        firePosition = response.fire_positions;
        crackPosition = response.crack_positions;

        % Hazard Display Logic
        if fireConfidence > 0.5
            hazardText.Text = sprintf('🔥 Fire Risk of %.2f' + '%' + ' at (%s)', fireConfidence, formatPosition(firePosition));
            hazardText.FontColor = 'r';
        elseif crackConfidence > 0.5
            hazardText.Text = sprintf('⚠️ Crack Detected (%.2f) at (%s)', crackConfidence, formatPosition(crackPosition));
            hazardText.FontColor = 'y';
        else
            hazardText.Text = '✅ No hazards detected.';
            hazardText.FontColor = 'g';
        end
        
        % Update Live Feed
        imshow(realImage, 'Parent', ax);

        % Update LIDAR Greyscale Image (same size as live feed)
        imshow(mockLidarImage, 'Parent', axLidar);

        % Update Thermal Sensor Graph
        plot(axThermal, mockThermalData, 'r-', 'LineWidth', 2);
        axThermal.XLim = [0 100];
        axThermal.YLim = [0 100];
        title(axThermal, 'Mock Thermal Sensor Data');
        xlabel(axThermal, 'Sensor Readings');
        ylabel(axThermal, 'Temperature (°C)');
        
    catch ME
        disp(['Error in API: ', ME.message]);
        hazardText.Text = '❌ API Error';
        hazardText.FontColor = 'b';
        clear cam;
        break;
    end
    
    pause(1);
end

clear cam;
disp('SLAM simulation complete.');

% Helper Function to Format Position
function posStr = formatPosition(position)
    if isstruct(position) && isfield(position, 'x') && isfield(position, 'y')
        posStr = sprintf('%.2f, %.2f', position.x, position.y);
    else
        posStr = 'unknown';
    end
end

% Helper Function to Get Random Direction for Mock Robot Data
function direction = getRandomDirection()
    directions = {'North', 'East', 'South', 'West'};
    direction = directions{randi(numel(directions))};
end
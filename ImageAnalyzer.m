clc; clear all; close all;

path                = 'E:\Lab_5\images\';

%Create image for the backdrop
backdropFolder      = 'Backdrop_C001H001S0001\';
directoryBackdrop   = dir([path backdropFolder '\*.tif']);
backdrop            = imread([path backdropFolder directoryBackdrop(1).name]);

%Create image for the meter stick
meterStickFolder    = 'Meter Stick_C001H001S0001\';
directoryMeterStick = dir([path meterStickFolder '\*.tif']);
meterStick          = imread([path meterStickFolder directoryMeterStick(1).name]);
meterStick          = backdrop - meterStick;
%Upon visual analysis of meterStick file, bottom of first  tape is at row 312
%                                  bottom of second tape is at row 859;

halfMeterPixels = 859-312; % Height of pixels for 0.5 meters = pixel of first tape - pixel of second tape;
pixel2Meter = .5/halfMeterPixels; %m

posData(1).time(1) = 0;
posData(1).pos(1) = 0;

velocity = zeros(15,1);

% CONSTANTS FOR CALCS
g = 9.81; % [m/s] -acceleration due to gravity
m = [2 2 2.4 2.6 1.9 2.3 2.4 2.3 2 2.1 2.6 2.4 2.2 2.3 1.9]; % [g] - mass of each ping pong ball
d = [39.23 39.27 39.42 39.05 38.78 39.05 39.55 39.73 39.78 39.29 39.65 39.29 39.42 39.4 39.3]; % [mm] - diameter of each ping pong ball


%Create matrix to store values for each pictures
for i=1 : 15 % i is the ball number
    folder  = strcat(num2str(i), '_C001H001S0001\');
    directoryTemp = dir([path folder '*.tif']);
    thresh  = 100; 
%     for j=1 :1: size(directoryTemp) % j is the frame number    
%         temp = [path folder directoryTemp(j).name];
%         pic1 = imread(temp);
%         pic1 = (backdrop - pic1) > thresh;
%         [row, column] = find(pic1 > 0);
%         temp = 0;
%         if min(row)
%             temp = min(row);
%         end %if
%         %imshow(pic1);
%        posData(i).time(j) = (j-1)/1000;
%        posData(i).pos(j) = temp;
% 
%       
%     end%for
%     
%     j = figure;
%     plot(posData(1).time(:), posData(1).pos(:)*pixel2Meter);
%     hold on
%     xlabel('Time (s)');
%     ylabel('Position (m)');
%     title("Ball" + i);
%     hold off
%     [xi, yi] = ginput(2);
%     indx = find((posData(1).time(:) > xi(1)) .* (posData(1).time(:) < xi(2)));
%     
%      h = figure;
%      plot((posData(1).time(indx) - posData(1).time(indx(1))), posData(1).pos(indx)*pixel2Meter);
%      hold on
%      xlabel('Time (s)');
%      ylabel('Position (m)');
%      title("Ball" + i);
%      hold off
%      
%     savefig(h,"Ball" + string(i));
% 
%     close(j); close (h);
    % Take a derivative of the position data to get velocity and plot it.
    open("Ball" + string(i) + ".fig");
    h = gcf;
    axesObjs = get(h, 'Children');
    dataObjs = get(axesObjs, 'Children');
    timeData = get(dataObjs, 'XData');
    posData  = get(dataObjs, 'YData');

    [fitObj, gof] = fit(timeData',posData','poly1');
    velData  = differentiate(fitObj, timeData);

    close(h);
    h = figure;
    plot(timeData,velData);
    xlabel('Time [s]');
    ylabel('Velocity [m/s]');
    title("Ball" + i)
    savefig(h,"Ball" + string(i) + "Velocity");
    close(h);

    velocity(i) = velData(1);

    % Cd = 2Fd/p/V^2/A

end%for 









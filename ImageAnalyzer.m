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
%Upon analysis of meterStick file, bottom of first  tape is at row 312
%                                  bottom of second tape is at row 859;

halfMeterPixels = 859-312; % Height of pixels for 0.5 meters = pixel of first tape - pixel of second tape;
posData(1).time(1) = 0;
posData(1).pos(1) = 0;


%Create matrix to store values for each pictures
for i=1 : 1 % i is the ball number
    h       = figure;
    folder  = strcat(num2str(i), '_C001H001S0001\');
    directoryTemp = dir([path folder '*.tif']);
    thresh  = 100; 
    for j=1 :1: size(directoryTemp) % j is the frame number    
        temp = [path folder directoryTemp(j).name];
        pic1 = imread(temp);
        pic1 = (backdrop - pic1) > thresh;
        [row, column] = find(pic1 > 0);
        temp = 0;
        if min(row)
            temp = min(row);
        end %if
        %imshow(pic1);
       posData(i).time(j) = (j-1)/1000;
       posData(i).pos(j) = temp;

    end%for
end%for 


plot(posData(1).time(:), posData(1).pos(:));



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


%Create matrix to store values for each pictures
for i=1 : 15
    h       = figure;
    folder  = strcat(num2str(i), '_C001H001S0001\');
    directoryTemp = dir([path folder '*.tif']);
    thresh  = 100; 
    for j=20 :2: size(directoryTemp)    
        temp = [path folder directoryTemp(j).name];
        pic1 = imread(temp);
        pic1 = (backdrop - pic1) > thresh;
        [row, column] = find(pic1 > 0);
        temp = min(row)
       %imshow(pic1);

        
        
        %imshow(pic1);
    end%for
end%for 


%blblblblblblbblbllb



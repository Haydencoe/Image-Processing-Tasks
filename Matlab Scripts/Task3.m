% Hayden Coe 15595332
% MATLAB script for Assessment Item-1
% Task-3
clear; close all; clc;

% Step-1: Load the provided input image of a beach.
% Reads the image file for processing
im = imread('Starfish.jpg');
subplot(2,4,1);
imshow(im);
title('Step-1: Load Starfish');

% Step-2: Conversion of input image to greyscale
img = rgb2gray(im);
subplot(2,4,2);
imshow(img); 
title('Step-2: Starfish to greyscale');

% Step-3: Noise removal
% Median filtering is more effective than convolution when the goal is to simultaneously reduce noise and preserve edges.
% The medfilt is a median filter which brings the best results. 
imgf = medfilt2(img);
subplot(2,4,3);
imshow(imgf); 
title('Step-3: Noise removal');

% Step-4: Image Enhancement
% Maps the intensity values in grayscale image imgf to new values in imga. 
% By default, imadjust saturates the bottom 1% and the top 1% of all pixel values. 
% This operation increases the contrast of the output image imga.
imga = imadjust(imgf); %Image will then become more clear.
% localcontrast(imga) enhances the local contrast of the image.
imgl = localcontrast(imga);
subplot(2,4,4);
imshow(imgl);
title('Step-4: Image Enhance');

% Step-5: Image Segmentation
% Sensitivity factor of 0.7 yields the best results, range 0-1
imgi = imbinarize(imgl, 'adaptive','Sensitivity',0.7); %This turns the image into binary by replacing all of the pixels with 0/1
% Reverse Black and White in a Binary Image
imgim = imcomplement(imgi); % Changes values around to bring the output as seen in the provided assignment image of white stars on black background.
% ~ would alos have worked
subplot(2,4,5);            
imshow(imgim); 
title('Step-5: Image Segmentation');

% Step-6: Morphological Processing
% Remove Objects in Image Containing Fewer Than 40 Pixels
imgib = bwareaopen(imgim, 40); %Remove unwanted specs that are not part of our object we are looking for.
subplot(2,4,6);               
imshow(imgib); 
title('Step-6: Morph Processing');

% We can look at the stats and get the range of values for starfish
% Area, Perimiter are not good properties to filter by, because they
% depend on the image size. Extent, Solidity, Eccentricity are good because
% they are ratios that are more intrinsic to the shape of the object
% Starfish are regions 5, 16, 25, 42, 56

% Step-7: Object Recognition
% bwlabel(imgib) returns the label matrix L that contains labels for the connected objects found in imgib.
L = bwlabel(imgib); % L = The connected pixels and adds a numbered label.

% Measures a set of properties for each labeled region in the label matrix L
stats = regionprops(L, 'Extent', 'Solidity', 'Eccentricity'); %How we find our object.

extent = [stats.Extent];
solidity = [stats.Solidity];
eccentricity = [stats.Eccentricity];

idx = find(extent > 0.23 & extent < 0.35 & solidity > 0.35 & solidity < 0.44 & eccentricity > 0.4 & eccentricity < 0.85);

bw2 = ismember(L, idx); %Retuns of the results of the idx

% Median filtering is more effective than convolution when the goal is to simultaneously reduce noise and preserve edges.
bw2 = medfilt2(bw2); %Add another median filter 
subplot(2,4,7);
imshow(bw2); 
title('Step-7: Object Recognition');



%Display each individual starfish separately with for loop.


%fishCounter=0;
%for v = idx
%  fishCounter = fishCounter+1;
%  
%    starfisheach = ismember(L, v);
%     figure()
%     imshow(starfisheach) 
%     str = sprintf('Starfish %d', fishCounter);
%     title(str)
%end



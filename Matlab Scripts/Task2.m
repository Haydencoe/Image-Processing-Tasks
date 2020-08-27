% Hayden Coe 15595332
% MATLAB script for Assessment Item-1
% Task-2
clear; close all; clc;

% Read in noisy input image
I = imread('Noisy.png');

% Convert to greyscale
N = rgb2gray(I);

% Get image size
[rows, cols] = size(N);

% Pad image with 2 zeros on each edge to allow 5x5 window to go all the way 
% to the edge
paddedN = padarray(N,[2 2]);

% Output container to hold image with mean filter applied
meanN = zeros(size(N), class(N));

% Output container to hold image with median filter applied
medianN = zeros(size(N), class(N));

% Loop through individual image pixels by iterating rows and columns
for x=1:cols
    for y=1:rows
        
        % Get the 5x5 window around the pixel
        % y:y+4 in padded image is equivalent to y-2:y+2 in original image
        window = paddedN(y:y+4, x:x+4);
        
        % Set the meanN pixel value to the mean value of the window
        % Aren't allowed to use 'mean2' - so calculate mean by summing all 
        % elements then dividing by number of elements
        % (We do know numel(window) = 25 always, so could just use that...)
        meanN(y, x) = sum(window, 'all') / numel(window);
        
        % Set the medianN pixel value to the median of the window
        medianN(y, x) = median(window, 'all');
    end
end

% Show output
figure;
subplot(1, 3, 1);
imshow(N);
title('Noisy original image')

subplot(1, 3, 2);
imshow(meanN);
title('Mean filter');

subplot(1, 3, 3);
imshow(medianN);
title('Median filter');

% Comparison:
% Median filter appears to work better than mean filter to remove noise
% This is because the median is less affected by extreme 'outlier' values
% So it ignores the noise pixels better


% Hayden Coe 15595332
% MATLAB script for Assessment Item-1
% Task-4
clear; close all; clc;

% Read image
im = imread('Starfish.jpg');

figure;
subplot(2, 3, 1);
imshow(im);
title('Original noisy image')

% Remove noise using median filter on each RGB colour channel
im(:, :, 1) =  medfilt2(im(:, :, 1));
im(:, :, 2) =  medfilt2(im(:, :, 2));
im(:, :, 3) =  medfilt2(im(:, :, 3));
subplot(2, 3, 2);
imshow(im);
title('Noise removed with median filter')

% Use k-means clustering of colours for segmentation
klabels = imsegkmeans(im, 3, 'NumAttempts', 10);
subplot(2, 3, 3);
overlay = labeloverlay(im, klabels);
imshow(overlay)
title('K-means segmentation')

binary = klabels ~= 1;  
subplot(2, 3, 4);
imshow(binary)
title('Non-background objects')

% Close small gaps and remove smallest objects
clean = imclose(binary, strel('disk', 2));
small_object_threshold = round(size(im, 1) * 0.1);
clean = bwareaopen(clean, small_object_threshold);
subplot(2, 3, 5);
imshow(clean)
title('Cleaned objects')

% Get properties of each object
cc = bwconncomp(clean);
% stats = regionprops(cc, 'Eccentricity', 'Extent', 'Solidity'); 



% By trial and error, starfish are regions 4, 11, 19, 29, 41
% We can look at the stats and get the range of values for starfish
% [stats([4, 11, 19, 29, 41]).Extent] => 0.2817 0.3272 0.3224 0.2714 0.3100
% So we can filter by requiring Extent >0.25 and <0.35

% Area, Perimiter are not good properties to filter by, because they
% depend on the image size. Extent, Solidity, Eccentricity are good because
% they are ratios that are more intrinsic to the shape of the object

% Filter the ojects by regionprops
% Disabled: We can use this for task3? Now for task4 we use signature below
% idx = find([stats.Extent] > 0.25 & ...
%            [stats.Extent] < 0.35 & ...
%            [stats.Solidity] > 0.4 & ...
%            [stats.Solidity] < 0.5 & ...
%            [stats.Eccentricity] > 0.54 & ...
%            [stats.Eccentricity] < 0.72 ...
%           );
%       
% disp('Starfish: ')
% disp(idx)
% starfish = ismember(labelmatrix(cc), idx); 
% subplot(2, 3, 6);
% imshow(starfish)
% title('Starfish objects filtered by regionprops')



% Load our previously generated 'average' starfish signature to compare against
avgstarfishsig = dlmread('avgstarfishsig.csv')';

[B,L] = bwboundaries(clean, 'noholes');
stats = regionprops(L,'Centroid');
figure;
subplot(1,3,1)
imshow(label2rgb(L, @jet, [.5 .5 .5]))
title('Starfish boundaries')
hold on
alldistances = zeros(360, length(B));
starfish = [];
for k = 1:length(B)
  boundary = B{k};
  centroid = stats(k).Centroid;
  
  % Get angle for each boundary pixel
  angles = atan2(boundary(:,2)-centroid(1), boundary(:,1)-centroid(2));
  [angles, angleorder] = sort(angles);  % Sort by angle
  [angles, uniques] = unique(angles); % Remove duplicate angles
  
  % Get distance between each boundary pixel and centroid
  distances = sqrt((boundary(:,1)-centroid(2)).^2 + (boundary(:,2)-centroid(1)).^2);
  distances = distances(angleorder);  % Copy angle sort
  distances = distances(uniques);    % Copy angle deduplication
  
  % Re-sample distances to 360 equally spaced points around boundary
  distances = interp1(angles, distances, linspace(-pi, pi, 360));
  
  % Shift distances so highest value first (gets them in sync, even if at different rotation)
  [maxval, maxidx] = max(distances);
  distances = circshift(distances, -maxidx);
  
  % Fill missing distances (from interp failing at edges before shifting)
  distances = fillmissing(distances, 'linear');
  
  % Normalize distances to between 0 and 1 (so size doesn't matter)
  distances = (distances - min(distances)) / (max(distances) - min(distances));
  
  % Get sum of squared differances with 'average' starfish
  ssd = sum((distances - avgstarfishsig).^2);
  
  if ssd < 10  % 10 best threshold / 38 all 5 appear for the larger image 
      starfish = [starfish, k];
      subplot(1,3,1)
      plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
      subplot(1,3,2)
      plot(distances);
      hold on
  end
  
  % Collect distances for use in generating the 'average' starfish signature
  alldistances(:, k) = distances;
end

% This is disabled. It was ran once to generate the 'average' starfish signature
% avgstarfishsig = mean(alldistances, 2);
% dlmwrite('avgstarfishsig.csv', avgstarfishsig)
 plot(avgstarfishsig, 'LineWidth', 3);

starfishimg = ismember(L, starfish); 
subplot(1,3,3)
imshow(starfishimg)
title('Starfish objects filtered by signature')




%Display each individual starfish separately with for loop.

%counter=2;
%fishCounter=0;
%for v = starfish
%   fishCounter = fishCounter+1;
%    counter = counter + 1; 
%    starfisheach = ismember(L, v);
%     figure(counter)
%     imshow(starfisheach) 
%     str = sprintf('Starfish %d', fishCounter);
%     title(str)
%end








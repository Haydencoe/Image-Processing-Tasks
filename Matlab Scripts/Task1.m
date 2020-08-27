% Hayden Coe 15595332
% MATLAB script for Assessment Item-1
% Task-1
clear; close all; clc;

% Step-1: Load input image
I = imread('Zebra.jpg');

%figure;
%imshow(I);
%title('Step-1: Load input image');

% Step-2: Conversion of input image to grey-scale image
Igray = rgb2gray(I);

figure;
imshow(Igray);
title('Step-2: Conversion of input image to greyscale');

% Step-3: Nearest Neighbour scaling
[or, oc] = size(Igray);                  % Get the size of original zebra image (556x612)
nr = 1668;
nc = 1836;                               % Desired size given in task (1668*1836)

% Make an image of zeros at the output size
Inn = zeros(nr, nc, class(Igray));

% Iterate each output pixel row by row, col by col
for i=1:nr
    for j=1:nc
        % Get the nearest pixel in the input
        ii = round( (i-1)*(or-1)/(nr-1)+1 );
        jj = round( (j-1)*(oc-1)/(nc-1)+1 );
        
        % Set the output pixel value
        Inn(i,j) = Igray(ii,jj);
    end
end

% Step-4 Bilinear        
[row ,col, d] = size(Igray);  % 3 dimentional array of the Zebra image 
Zebra=3;                      % Increase the pixel values by 3 ((556*612)*3 = (1668*1836))
zr=Zebra*row;                 % Allocate the rows to itereate 
zc=Zebra*col;                 % Allocate the cols to itereate 

im_zoom = zeros(zr,zc, class(Igray)); % Sets the empty matrix so the size is known and the memory can be allocated beforehand 

for i=1:zr % Loop 
    
    x=i/Zebra;        % x = The zebra rows divided by the zoom applied.  
    
    f1=floor(x);      % Rounding down to next integer 
    c2=ceil(x);       % Rounding up to next integer 
    if f1==0,f1=1; 
    end
    xint=rem(x,1);    % xint = remainder after rounding applied 
    for j=1:zc        % Second iteration to cover linear searches 
        y=j/Zebra;    % Its a tow bi linear interpolation 
        F1=floor(y);  % Rounds down to the next integer 
        C2=ceil(y);   % Rounds up to the next integer 
        if F1==0,F1=1; 
        end
        
        Rint=rem(y,1);      % Rounds up while keeping whole numbers 
        Z1=Igray(f1,F1,:);  % Allocation of variables in arrays 
        Z2=Igray(f1,C2,:);
        Z3=Igray(c2,F1,:);
        Z4=Igray(c2,C2,:);
        
        R1=Z3*Rint+Z1*(1-Rint); % Remainder of the integers calculated with both floor and ceiling integers 
        R2=Z4*Rint+Z2*(1-Rint); % Remainder of the integers calculated with both floor and ceiling integers 
        
        im_zoom(i,j,:)=R1*xint+R2*(1-xint); % im_zoom index i and j 
    end
end




Inn_cropped = imcrop(Inn,[250,300,250,300]); % Image cropped so difference is visable 

CB = imcrop(im_zoom,[250,300,250,300]); % image cropped so difference is visable



% Show images together with sub plot.  

figure;
subplot(2,2,1);
imshow(Inn_cropped);  % Cropped version of Nearest Neighbour
title('Cropped Nearest Neighbour');
subplot(2,2,2);
imshow(Inn);   % Full size version of Nearest Neighbour
title('Full Nearest Neighbour');
subplot(2,2,3);
imshow (CB);    % Cropped version of Bilinear
title('Cropped Bilinear');
subplot(2,2,4);
imshow(im_zoom); % Full size version of Bilinear
title('Full Bilinear');

% Show full sizes images by themselves.

%figure(2);
%imshow(Inn);   % Full size version of Nearest Neighbour
%title('Full Nearest Neighbour');
%figure(3);
%imshow(im_zoom); % Full size version of Bilinear
%title('Full Bilinear');





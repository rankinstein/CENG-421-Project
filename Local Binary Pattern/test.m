%% Test script for Local Binary Pattern
%This script tests and demonstrates the Local Binary Pattern Textural
%descriptor and its rotation invariance
close all

%% Demonstrate LBP Descriptor on occupied and unoccupied spots
% camera_rotated = imresize(camera_rotated, [256 256]);
img1 = rgb2gray(imread('occ1.jpg'));
img2 = rgb2gray(imread('unocc1.jpg'));
tic
lbp1 = LocalBinaryPattern(img1, [3 3]);
lbp1_r = LocalBinaryPattern(img2, [3 3]);
toc

nbins = 60;

figure;
subplot(2,2,1)
imshow(img1,[]);
title('Occupied Parking Space');

subplot(2,2,2);
h1 = histogram(lbp1,nbins,'Normalization','probability'); 
title('LBP of Occupied Parking Space');

subplot(2,2,3)
imshow(img2,[]);
title('Unoccupied Parking Space');
subplot(2,2,4);
h1_r = histogram(lbp1_r,nbins,'Normalization','probability');
title('LBP of Unoccupied Parking Space');

figure; 
h1 = histogram(lbp1,nbins,'Normalization','probability');
hold on
h1_r = histogram(lbp1_r,nbins,'Normalization','probability');
title('LBP Comparision of Two Image');
legend('Occupied Space', 'Unoccupied Space');

%% Demonstrate Rotation Invariance
load('camera256.mat');
%convert image to grayscale
%create neighbourhood sliding window nlfilter or im2col
camera_rotated = imrotate(camera256,90);

tic
lbp1 = LocalBinaryPattern(camera256, [3 3]);
lbp1_r = LocalBinaryPattern(camera_rotated, [3 3]);
toc

nbins = 60;

figure;
subplot(2,2,1)
imshow(camera256,[]);
title('Original Image');

subplot(2,2,2);
h1 = histogram(lbp1,nbins,'Normalization','probability'); 
title('LBP of Original Image');

subplot(2,2,3)
imshow(camera_rotated,[]);
title('Rotated Image');
subplot(2,2,4);
h1_r = histogram(lbp1_r,nbins,'Normalization','probability');
title('LBP of Rotated Image');

figure; 
h1 = histogram(lbp1,nbins,'Normalization','probability');
hold on
h1_r = histogram(lbp1_r,nbins,'Normalization','probability');
title('LBP Comparision of Two Image');
legend('camera256', 'camera256 rotated');

rmse =  sqrt(mean((h1.Values - h1_r.Values).^2))
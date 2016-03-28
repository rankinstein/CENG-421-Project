%% Test script for Local Phase Quantzation
%This script tests and demonstrates the Local Phase Quantization Textural
%descriptor and its blur invariance
close all

%% Demonstrate LPQDescriptor on occupied and unoccupied spots
load('lot_seg1.mat');
load('lot_seg2.mat');
load('lot_seg3.mat');

f1 = LPQ(im_seg1);
f2 = LPQ(im_seg2);
f3 = LPQ(im_rot);

figure;
subplot(3,3,1);
imshow(im_seg1);
subplot(3,3,2);
imshow(im_seg2);
subplot(3,3,3);
imshow(im_rot);
subplot(3,3,4);
histogram(f1,256,'Normalization', 'probability');
subplot(3,3,5);
histogram(f2,256,'Normalization', 'probability');
subplot(3,3,6);
histogram(f3,256,'Normalization', 'probability');
subplot(3,3,7:9);
hold on;

histogram(f1,256,'Normalization', 'probability');
histogram(f2,256,'Normalization', 'probability');
histogram(f3,256,'Normalization', 'probability');
legend('car1','car2','empty');

%% Demonstrate the Blur Invariance of Local Phase Quantization Descriptor
load('camera256.mat')
camera_motion = imgaussfilt(camera256, 2);

tic
lbp1 = LPQ(camera256);
lbp1_r = LPQ(camera_motion);
toc

nbins = 60;

figure;
subplot(2,2,1)
imshow(camera256,[]);
title('Original Image');

subplot(2,2,2);
h1 = histogram(lbp1,nbins,'Normalization','probability'); 
title('LPQ of Original Image');

subplot(2,2,3)
imshow(camera_motion,[]);
title('Rotated Image');
subplot(2,2,4);
h1_r = histogram(lbp1_r,nbins,'Normalization','probability');
title('LPQ of Rotated Image');

figure; 
h1 = histogram(lbp1,nbins,'Normalization','probability');
hold on
h1_r = histogram(lbp1_r,nbins,'Normalization','probability');
title('LPQ Comparision of Two Image');
legend('Original Image', 'Blurred Image');

rmse =  sqrt(mean((h1.Values - h1_r.Values).^2))


close all

load('camera256.mat');
load('boat512.mat');
%convert image to grayscale
%create neighbourhood sliding window nlfilter or im2col
camera_rotated = imrotate(camera256,90);
% camera_rotated = imresize(camera_rotated, [256 256]);

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

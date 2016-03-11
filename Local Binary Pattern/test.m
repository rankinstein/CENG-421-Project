close all

load('camera256.mat');
load('boat512.mat');
%convert image to grayscale
%create neighbourhood sliding window nlfilter or im2col
camera_rotated = imrotate(camera256,30);
func = @(x) LBP(x);
t3 = nlfilter(boat512, [3 3], func);
t2 = nlfilter(camera256, [3 3], func);
t1 = nlfilter(camera_rotated, [3 3], func);

figure; 
subplot(1,3,1);
imshow(camera_rotated, []);
subplot(1,3,2);
imshow(camera256, []);
subplot(1,3,3);
imshow(boat512, []);

nbins = 60;
figure;
h1 = histogram(t1,nbins,'Normalization','probability'); 
hold on
h2 = histogram(t2,nbins,'Normalization','probability');
h3 = histogram(t3,nbins,'Normalization','probability');
legend('camera256 rotated', 'camera256', 'boat512');
%repeat 
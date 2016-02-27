close all

load('camera256.mat');
load('boat512.mat');
%convert image to grayscale
%create neighbourhood sliding window nlfilter or im2col
func = @(x) LBP(x);
t2 = nlfilter(camera256, [3 3], func);
t1 = nlfilter(boat512, [3 3], func);

figure; 
subplot(1,2,1);
imshow(boat512, []);
subplot(1,2,2);
imshow(camera256, []);

figure;
h1 = histogram(t1); 
hold on
h2 = histogram(t2);
legend('boat512', 'camera256')
%repeat 
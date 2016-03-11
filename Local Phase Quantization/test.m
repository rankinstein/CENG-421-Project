close all

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



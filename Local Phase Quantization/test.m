close all

load('lot_seg1.mat');
load('lot_seg2.mat');
load('lot_seg3.mat');

%f1 = lpq_basic(im_seg1);
figure;
hold on;
f1 = LPQ(im_seg1);
f2 = LPQ(im_seg2);
f3 = LPQ(im_rot);
legend('car1','car2','empty');



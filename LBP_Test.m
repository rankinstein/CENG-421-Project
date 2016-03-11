base_path = 'PKLot/PKLot/';

if ~exist('file_set','var') % only find the files if they are not defined
    [ file_set, training_set ] = get_file_paths(base_path, 0.1);
end

% concat '.jpg' to get the image and '.xml' to get the metadata
%   TEST CASE: Choosing image 100, this is an arbirary choice
%   NOTE: file_set is a cell array hence the {}
image_path = strcat(file_set{100},'.jpg');
xml_path = strcat(file_set{100},'.xml');

image = imread(image_path);

% s contains all the meta data for the image
% Order of Columns:
%       Spot Number, Occupied, Center X, Center Y, Width, Height, Angle
s = readXML(xml_path);

%% Example printing information from the metadata file
num_spaces = size(s,1);

%% Example of space segmentation for space k
k = 33;
im_seg1 = segment_space(image, s(k,3:7));
k = 34;
im_seg2 = segment_space(image, s(k,3:7));

% filter band responses?? for texture description

addpath 'Local Binary Pattern';

t1 = imageLBP(im_seg1);
t2 = imageLBP(im_seg2);

figure; 
subplot(1,2,1);
imshow(im_seg1, []);
subplot(1,2,2);
imshow(im_seg2, []);

t1 = t1(t1>0);
t2 = t2(t2>0);

figure;
h1 = bar(1:size(t1,2),t1);
hold on
h2 = bar(1:size(t2,2),t2);

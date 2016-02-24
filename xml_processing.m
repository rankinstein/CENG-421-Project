
%% Get the paths of all files
% File names do not include extension. Each file name has an image (.jpg)
% and its associated metadata (.xml)
base_path = 'PKLot/PKLot/';
if ~exist('file_set','var')
    [ file_set, training_set ] = get_file_paths(base_path, 0.1);
end

% concat '.jpg' to get the image and '.xml' to get the metadata
image_path = strcat(file_set{100},'.jpg');
xml_path = strcat(file_set{100},'.xml');

%% Display Images and Metadata
image = imread(image_path);
imshow(image);
hold on;

R = @(deg) [cosd(deg) -sind(deg); sind(deg) cosd(deg)]; % 2D rotation matrix

s = readXML(xml_path);

num_spaces = size(s,1);
for k = 1:num_spaces
    plot(s(k,2),s(k,3),'b+');
    C = s(k,2:3);
    W = s(k,4)/2;
    H = s(k,5)/2;
    P(1,:) = [W H];
    P(2,:) = [W -H];
    P(3,:) = [-W H];
    P(4,:) = [-W -H];
    Rs = (R(-74)*P')';
    P = [Rs(:,1)+C(1) Rs(:,2)+C(2)];
    if mod(k,3) == 0
        plot(P(1,1),P(1,2),'g+');
        plot(P(2,1),P(2,2),'g+');
        plot(P(3,1),P(3,2),'g+');
        plot(P(4,1),P(4,2),'g+');
%     elseif mod(k,3) == 1
%         plot(P(1,1),P(1,2),'r+');
%         plot(P(2,1),P(2,2),'r+');
%         plot(P(3,1),P(3,2),'r+');
%         plot(P(4,1),P(4,2),'r+');
%     else
%         plot(P(1,1),P(1,2),'c+');
%         plot(P(2,1),P(2,2),'c+');
%         plot(P(3,1),P(3,2),'c+');
%         plot(P(4,1),P(4,2),'c+');   
    end
end

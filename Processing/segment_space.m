function [ im_rot ] = segment_space( image, section )
%SEGMENT_SPACE segments a section of the image given a bounding rectangle
% and angle
% Parameters:
%   image       The image matrix to segment.
%   section 	An array describing the area to segment.
%                  [centerx, centery, width, height, angle]
%               (This format was chosen to match format of metadata matrix 
%                and simplifies function calls)
%
% Output:
%   im_rot      The segmented image.

    % 2D rotation matrix
    R = @(deg) [cosd(deg) -sind(deg); sind(deg) cosd(deg)];
    
    C = section(1:2);
    W = section(3)/2;
    H = section(4)/2;
    A = section(5);
    
    P(1,:) = [W H];
    P(2,:) = [W -H];
    P(3,:) = [-W H];
    P(4,:) = [-W -H];
    Rs = (R(A)*P')';
    P = [Rs(:,1)+C(1) Rs(:,2)+C(2)];
    segmin = floor(min(P));
    segmax = ceil(max(P));
    segment_x = segmin(1):segmax(1);
    segment_y = segmin(2):segmax(2);
    im_seg = image(segment_y, segment_x,:);
    
    % Metadata files flip orientation of bounding rectagle for certain
    % spots (generally those on the left side of the parking lot). This is
    % a hack solution to addressing these inconsistencies.
    if W > H
        im_rot = imrotate(im_seg,90+A,'bilinear');
        C = [size(im_rot,1)/2 size(im_rot,2)/2];
        min_x = round(C(1)-W);
        max_x = round(C(1)+W);
        min_y = round(C(2)-H);
        max_y = round(C(2)+H);
    else
        im_rot = imrotate(im_seg,A,'bilinear');
        C = [size(im_rot,1)/2 size(im_rot,2)/2];
        min_x = round(C(1)-H);
        max_x = round(C(1)+H);
        min_y = round(C(2)-W);
        max_y = round(C(2)+W);
    end

    im_rot = im_rot(min_x:max_x, min_y:max_y, :);

end


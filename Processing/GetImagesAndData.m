function [ image_data_matrix ] = GetImagesAndData( file_set )
%GETIMAGEANDDATA Summary of this function goes here
%   Detailed explanation goes here

    addpath './..';
    addpath './../xml2struct';
    file_set_size = length(file_set);
    spots_per_file = 100;
    image_data_matrix = cell(file_set_size*spots_per_file,3);
    image_set = {};
    parfor k = 1:file_set_size;
        %% Open image, convert to grayscale and open the metadata file
        image_path = strcat(file_set{k},'.jpg');
        xml_path = strcat(file_set{k},'.xml');

        data_matrix = readXML(xml_path);
        lot_image = rgb2gray(imread(image_path));

        %% Combine space number, occupied, and segmented image
        data_matrix_size = length(data_matrix);
        image_and_data = num2cell(data_matrix(:,1:2));
        for l = 1:data_matrix_size
            image_and_data{l,3} = segment_space(lot_image, data_matrix(l,3:7));
        end
        image_set{k} = image_and_data;
        %disp(sprintf('Data from file %3d of %3d processed.\n',k,file_set_size));
    end
    
    for k = 1:file_set_size
        start_index = (k-1)*spots_per_file + 1;
        image_data_matrix(start_index:(start_index + spots_per_file - 1),:) = image_set{k};
    end
    
    %sort rows by space number (column 1)
    image_data_matrix = sortrows(image_data_matrix,1);


end


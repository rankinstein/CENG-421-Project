function [ occupied_spots ] = DetermineOccupancy( img, method, classifier )
% Input Parameters
% imgs              - array of images that must to classified
% method            - binary value for determining the method to be used to
%                     classifiy the images:
%                     0 Local Binary Pattern
%                     1 Local Phase Quantization
%Ouput
% occupied_spots    - integer count of number of detected occupied spots

    if method == 0
        %Get feature vector of image using Local Binary Pattern
        feature_vector = FeatureVectors(img,0);

    elseif method == 1
        %Get feature vector of image using Local Phase Quantization
    end

    %Using the textural descriptor use classifer to determine the number of
    %occupied parking spots
end


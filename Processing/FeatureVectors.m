function [ feature_vectors ] = FeatureVectors( imgs, method )
% Input Parameters
% imgs              - Cell array of images needed to be processed
% method            - binary value for determining the method to be used to
%                     classifiy the images:
%                     0 Local Binary Pattern
%                     1 Local Phase Quantization
%Ouput
% feature_vectors   - Array continaining the feature vectors
%                     for each image in the cell array using the specified 
%                     method

    %iterate through each array cell and determine feature vector
    parfor i = 1:length(imgs)
        if method == 0
            %Get feature vector of image using Local Binary Pattern
            descriptor = LocalBinaryPattern(imgs{i}, [3, 3]);
            feature_vectors(i,:) = histcounts(descriptor,257,'Normalization','probability')';

        elseif method == 1
            %Get feature vector of image using Local Phase Quantization
        end
    end



end


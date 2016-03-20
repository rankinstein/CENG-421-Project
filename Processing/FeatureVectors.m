function [ feature_vectors ] = FeatureVectors( imgs, method )
% Input Parameters
% imgs              - Cell array of images needed to be processed
% method            - string value for determining the method to be used to
%                     classifiy the images:
%                     'LBP' Local Binary Pattern
%                     'LPQ' Local Phase Quantization
%Ouput
% feature_vectors   - Array continaining the feature vectors
%                     for each image in the cell array using the specified 
%                     method

    %iterate through each array cell and determine feature vector
    parfor i = 1:length(imgs)
        disp(i);
        if strcmp(method, 'LBP')
            %Get feature vector of image using Local Binary Pattern
            descriptor = LocalBinaryPattern(imgs{i}, [3, 3]);
            feature_vectors(i,:) = histcounts(descriptor,257,'Normalization','probability')';
        elseif strcmp(method, 'LPQ')
            %Get feature vector of image using Local Phase Quantization
            descriptor = LPQ(imgs{i});
            feature_vectors(i,:) = histcounts(descriptor,256,'Normalization','probability')';
        else
            error('Invalid feature vector generation method, specify LBP or LPQ');
        end
    end
end


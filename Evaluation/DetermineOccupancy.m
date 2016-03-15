function [ occupied_spots ] = DetermineOccupancy( imgs, method, classifier )
% Input Parameters
% imgs      - array of images that must to classified
% method    - binary value for determining the method to be used to
%             classifiy the images:
%             0 Local Binary Pattern
%             1 Local Phase Quantization


    if method == 0
        %Set the descriptor to Local Binary Pattern
        
    elseif method == 1
        %Set the descriptor to Local Phase Quantization
    end

    %Using the textural descriptor use classifer to determine the number of
    %occupied parking spots
end


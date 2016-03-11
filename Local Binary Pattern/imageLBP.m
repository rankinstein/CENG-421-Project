function [ LBPfeatures ] = imageLBP( image )
%IMAGELBP Extracts the Local Binary Pattern features of the input image
%   images are converted to gray-scale before processing if neccessary.

    kernel = [3 3];
    if size(image,3) > 1
       image = rgb2gray(image); 
    end

    func = @(x) LBP(x);
    LBPfeatures = nlfilter(image, kernel, func);

    LBPfeatures = histcounts(LBPfeatures, 'BinMethod', 'integer');
end


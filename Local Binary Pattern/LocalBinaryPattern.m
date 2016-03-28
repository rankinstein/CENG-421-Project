function LBP = LocalBinaryPattern( img, window_size )
%% Local Binary Pattern
% Performs the MxN sliding neighbourood and applies LBP descriptor
% Input Parameters
% img               - The image 
% window_size        - vector [M, N] which sets the neighborhood size
%Ouput
% LBP             -  Local Binary Pattern
    
    %Determine the window size (LBP3 only supports 3x3 window size)
    M = window_size(1);
    N = window_size(2);
    
    %compute the zero padding for borders
    PadM = round((M-1)/2);
    PadN = round((N-1)/2);
    img_padded = padarray(img, [PadM, PadN],'replicate');
    
    %preallocate variables for performance
    LBP = zeros(size(img,1), size(img,2));
    
    %iterate through each image dimension and determine the neighborhood
    for i = (PadM)+1:size(img_padded,1) - PadM
        for j = (PadN)+1:size(img_padded,2) - PadN
            %determine the Local binary pattern
             LBP(i-PadM,j-PadN) = LBP3(img_padded(i-1:i+1, j-1:j+1));   
        end
    end
end




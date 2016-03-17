function LBPu2 = LocalBinaryPattern( img, window_size )
% Input Parameters
% img               - The image 
% windw_size        - vector [N, N] which sets the neighborhood size
%Ouput
% LBPu2             - Unifrom Local Binary Pattern
    
    M = window_size(1);
    N = window_size(2);
    
    %compute the zero padding for borders
    PadM = round(M/2);
    PadN = round(N/2);
    img_padded = padarray(img, [PadM, PadN]);
    
    %preallocate variables for performance
    LBPu2 = zeros(size(img,1), size(img,2));
    neighbourhood_window = zeros(M,N);
    
    %iterate through each image dimension and determine the neighborhood
    for i = 1:size(img_padded,1) - ((PadM*2)+1)
        for j = 1:size(img_padded,2) - ((PadN*2)+1)     
            %Find neighbourhood
            for x = 1:M
                for y = 1:N
                    neighbourhood_window(x,y) = img_padded(i+x-1, j+y-1);
                end
            end
            %determine the Local binary pattern
             LBPu2(i,j) = LBP(neighbourhood_window);   
        end
    end
end




function LBP = LBP3( neighbourhood_window )
    %% Local Binary Pattern using 3x3 window 
    % Determines the Local Binary Pattern for a 3x3 window
    % Input Parameters
    % neighbourhood_window               - the 3x3 neighbourhood
    %Ouput
    % LBP                              -  Local Binary Pattern
    %window size
    [m,n] = size(neighbourhood_window);
    
    %weighted matrix for determining the LBP
    weights = [1 2 4; 128 0 8; 64 32 16];
    
    %center pixel of neighbourhood sliding window
    center_pixel = neighbourhood_window(round((m*n)/2));
   
    %compare gray level values of center pixel with neighbouring pixels
    binary_matrix = center_pixel <= neighbourhood_window;
    
    %determine the LBP
    LBP = sum(sum(binary_matrix .* weights));

end


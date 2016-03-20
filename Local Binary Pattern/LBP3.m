function LBPu2 = LBP3( neighbourhood_window )
    %window size
    [m,n] = size(neighbourhood_window);

    weights = [1 2 4; 128 0 8; 64 32 16];
    
    %center pixel of neighbourhood sliding window
    center_pixel = neighbourhood_window(round((m*n)/2));
   
    %compare gray level values of center pixel with neighbouring pixels
    binary_matrix = center_pixel <= neighbourhood_window;

    LBPu2 = sum(sum(binary_matrix .* weights));

end


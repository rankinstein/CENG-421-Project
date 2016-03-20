function LBPu2 = LBP3( neighbourhood_window )
    %window size
    [m,n] = size(neighbourhood_window);
    %number of neigbours
    P = m*n-1;
    weights = [1 2 4; 128 0 8; 64 32 16];
    
    %center pixel of neighbourhood sliding window
    center_pixel = neighbourhood_window(round((m*n)/2));
    
    neighbourhood_window(round((m*n)/2)) = 0;
   
    %compare gray level values of center pixel with neighbouring pixels
    binary_matrix = center_pixel <= neighbourhood_window;
    binary_pattern = reshape(binary_matrix,1, m*n);
    binary_pattern(round((m*n)/2)) = [];
    
    %Keep uniform values (transition <= 2) and put others in single bin
    if sum([diff(binary_pattern) binary_pattern(1)-binary_pattern(end)]~=0) <= 2
        LBPu2 = sum(sum(binary_matrix .* weights));
    else
        %put nonuniform LBP into a single bin (decimal value 256)
        LBPu2 = 2^(P);
    end
end


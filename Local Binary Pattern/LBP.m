function LBPu2 = LBP( neighbourhood_window )
    %window size
    [m,n] = size(neighbourhood_window);
    %number of neigbours
    P = m*n-1;
    %center pixel of neighbourhood sliding window
    center_pixel = neighbourhood_window(round((m*n)/2));
    
    %row vector containing all neighbouring pixels
    NB_pixels = reshape(neighbourhood_window, [1, m*n]);
    NB_pixels(round((m*n)/2)) = [];
   
    %compare gray level values of center pixel with neighbouring pixels
    binary_pattern = bsxfun(@le, center_pixel, NB_pixels); 
    
    %Keep uniform values (transition <= 2) and put others in single bin
    if sum(diff(binary_pattern)~=0) <= 2
        lbpu = binary_pattern;
        LBPu2 = bi2de(lbpu, 'left-msb');
    else
        %put nonuniform LBP into a single bin
        LBPu2 = P+1;
    end
end


function LBPu2 = LBP( neighbourhood_window )
    %window size
    [m,n] = size(neighbourhood_window);
    %number of neigbours
    P = m*n-1;
    %center pixel of neighbourhood sliding window
    center_pixel = neighbourhood_window(round((m*n)/2));
    
    %Radius of neibourhood_window (ASSUMES square neigbourhood matrix)
    R = (m-1)/2;
    
    %Get circular index from square matrix 
    PerimeterIndices = @(r, d) sub2ind([(r*2+1) (r*2+1)], round(r+1 + r*cosd(d)), round(r+1 + r*sind(d)));
    
    %Number of perimeter pixels.
    perimeter = 2*m + 2*n - 4*R;
    %Angle between neighbours
    A = 360/perimeter;
    
    %Determine rotational indexing of neighbourhood window. 
    %OPTIMIZATION:This is the same for all calls of the same window size
    %               could perform this once prior to calling LBP
    NB_pixels = zeros(1,perimeter);
    for k = 1:perimeter
        NB_pixels(k) = PerimeterIndices(R, A*k);
    end
    
    %row vector containing all neighbouring pixels
    NB_pixels = neighbourhood_window(NB_pixels);
   
    %compare gray level values of center pixel with neighbouring pixels
    binary_pattern = center_pixel <= NB_pixels; 
    
    %Keep uniform values (transition <= 2) and put others in single bin
    if sum([diff(binary_pattern) binary_pattern(1)-binary_pattern(end)]~=0) <= 2
        lbpu = binary_pattern;
        LBPu2 = bi2de(lbpu, 'left-msb');
    else
        %put nonuniform LBP into a single bin (decimal value 257)
        LBPu2 = 2^(P)+1;
    end
end


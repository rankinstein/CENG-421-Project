function [ sp ] = readXML( file )
%READXML wrapper for xml2struct function
%   Reads the contents of an XML file and produces an space information
%   matrix (whether it is occupied and the coordinates of its bounding
%   rectangle).
%   Order of Columns:
%       Spot Number, Occupied, Center X, Center Y, Width, Height, Angle
    %addpath 'xml2struct';
    s = xml2struct(file);
    %rmpath 'xml2struct';
    
    lot_id = s.parking.Attributes;
    spaces = s.parking.space;
    
    num_spaces = max(size(spaces));
    
    sp = zeros(num_spaces,7)-1;
    
    for k = 1:num_spaces
        
        % Some of data files may be missing the occupied entry
        try
            occupied = str2double(spaces{k}.Attributes.occupied);
        catch
            occupied = -1;
        end
        
        sp(k,:) = [ ...
           k ...
           occupied ...
           str2double(spaces{k}.rotatedRect.center.Attributes.x) ... 
           str2double(spaces{k}.rotatedRect.center.Attributes.y) ...
           str2double(spaces{k}.rotatedRect.size.Attributes.w) ...
           str2double(spaces{k}.rotatedRect.size.Attributes.h) ...
           str2double(spaces{k}.rotatedRect.angle.Attributes.d) ];
    end
    
end


function [ file_set, training_set, test_set ] = GetFileSets( training_percent )
%GETFILESETS returns the training, test, and complete set of files
% File names do not include extension. Each file name has an image (.jpg)
% and its associated metadata (.xml).
    
    addpath '..';
    base_path = '../PKLot/PKLot/';

    disp('Retrieving File Sets');
    if ~exist('file_set','var') % only find the files if not already defined
        [ file_set, training_set ] = get_file_paths(base_path, training_percent);
    end

    test_set = setdiff(file_set, training_set);

end


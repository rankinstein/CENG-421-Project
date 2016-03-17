%SUMMARY
% This script is used to evalaute detection results of the following
% Textural Descriptors:
%       - Local Binary Patterns
%       - Local Phase Quantization
% Note all the test images used are from a open source parking lot image
% database.
close all;

%% Open and separate image and metadata files
if ~exist('file_set','var')
    [ file_set, training_set, test_set ] = GetFileSets(0.01);
end
training_data = GetImagesAndData(training_set);

%%
% Load spot segments into a 3 arrays (2 for training, 1 for evaluation)

% Array of only occupied spots (For training)
training_data_occupied = training_data([training_data{:,2}] == 1,:);
% Array of empty spots (For training)
training_data_empty = training_data([training_data{:,2}] == 0,:);
% Array of bad spots missing data (For reference)
training_data_bad = training_data([training_data{:,2}] == -1,:);

% Array of mixed number of occupied and unoccupied (must know the number of
% occupied spots)

%%

%Get feature vectors for each training set and Pattern

%Train Classifier

%%  
% Evaluate Local Binary Pattern Descriptor
LBP_detections = DetermineOccupancy(o_imgs, 0, classifier);
LBP_false_detections = abs(num_occupied - LBP_detections);
LBP_rel_error = (LBP_detections - num_occupied)/ num_occupied;

%%
% Evaluate Local Phase Quantization Descriptor
LPQ_detections = DetermineOccupancy(o_imgs, 1, classifier);
LPQ_false_detections = abs(num_occupied - LPQ_detections);
LPQ_rel_error = (LPQ_detections - num_occupied)/ num_occupied;
%SUMMARY
% This script is used to evalaute detection results of the following
% Textural Descriptors:
%       - Local Binary Patterns
%       - Local Phase Quantization
% Note all the test images used are from a open source parking lot image
% database.
close all;

%add relevant file paths
addpath(genpath('File Extraction'),'./Processing', './Local Phase Quantization', './Local Binary Pattern');

%% Open and separate image and metadata files
if ~exist('file_set','var')
    [ file_set, training_set, test_set ] = GetFileSets(0.01);
end

% Select a set of images from the test files
test_data = GetImagesAndData(randsample(test_set, 50));

% Segment the images for the training files
training_data = GetImagesAndData(training_set);

%%
%Generate Training Data and Test Data
disp('Generating Training Data');
% Array of only occupied spots (For training)
training_data_occupied = training_data([training_data{:,2}] == 1,:);
% Array of empty spots (For training)
training_data_empty = training_data([training_data{:,2}] == 0,:);
% Array of bad spots missing data (For reference)
training_data_bad = training_data([training_data{:,2}] == -1,:);

disp('Generating Test Data');
% Array of only occupied spots (For testing)
test_data_occupied = test_data([test_data{:,2}] == 1,:);
% Array of empty spots (For testing)
test_data_empty = test_data([test_data{:,2}] == 0,:);
% Array of bad spots missing data (For reference)
test_data_bad = test_data([test_data{:,2}] == -1,:);


%%
%Create Feature Vectors for Training Sets
disp('Creating Local Binary Pattern Training Vectors Data');
%Get feature vectors for each training set and Pattern
if ~exist('LBP_features_occupied','var')
    LBP_features_occupied = FeatureVectors(training_data_occupied(:,3),'LBP');
end
if ~exist('LBP_features_empty','var')
    LBP_features_empty = FeatureVectors(training_data_empty(:,3),'LBP');
end

disp('Creating Local Phase Quantization Training Vectors Data');
if ~exist('LPQ_features_occupied','var')
    LPQ_features_occupied = FeatureVectors(training_data_occupied(:,3),'LPQ');
end
if ~exist('LPQ_features_empty','var')
    LPQ_features_empty = FeatureVectors(training_data_empty(:,3),'LPQ');
end

disp('Applying Fisher Discriminat Analysis on LBP and LPQ Training Vectors');
%Use Fisher Discriminant Analysis to reduce dimensions between empty and occupied
[LBP_db, LBP_V] = FisherDiscriminant(LBP_features_empty, LBP_features_occupied, 'LBP');
[LPQ_db, LPQ_V] = FisherDiscriminant(LPQ_features_empty, LPQ_features_occupied, 'LPQ');


%%
%Create Feature Vectors for Test Data
disp('Creating Local Binary Pattern Test Vectors Data');
%Get feature vectors for each test set and Pattern
if ~exist('LBP_test_features_occupied','var')
    LBP_test_features_occupied = FeatureVectors(test_data_occupied(:,3),'LBP');
end
if ~exist('LBP_test_features_empty','var')
    LBP_test_features_empty = FeatureVectors(test_data_empty(:,3),'LBP');
end
disp('Creating Local Phase Quantization Test Vectors Data');
if ~exist('LPQ_test_features_occupied','var')
    LPQ_test_features_occupied = FeatureVectors(test_data_occupied(:,3),'LPQ');
end
if ~exist('LPQ_test_features_empty','var')
    LPQ_test_features_empty = FeatureVectors(test_data_empty(:,3),'LPQ');
end

%%
%Evaluate the Local Binary Pattern and Local Phase Quantization Descriptors
disp('Evaluating LBP and LPQ Test Vectors');
c_mat_LBP = Evaluate(LBP_test_features_empty, LBP_test_features_occupied, LBP_V, LBP_db, 'LBP')
c_mat_LPQ = Evaluate(LPQ_test_features_empty, LPQ_test_features_occupied, LPQ_V, LPQ_db, 'LPQ')

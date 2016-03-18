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
if ~exist('features_occupied','var')
    features_occupied = FeatureVectors(training_data_occupied(:,3),0);
end
if ~exist('features_empty','var')
    features_empty = FeatureVectors(training_data_empty(:,3),0);
end
%Train Classifier

% Use Fisher Discriminant Analysis to reduce dimensions between empty and occupied

% Construct Sb, the scatter matrix for the distance between means
Sb = (mean(features_occupied) - mean(features_empty))'*(mean(features_occupied) - mean(features_empty));
% Construct Sw, the scatter matrix for the within covariances
Sw = cov(features_empty) + cov(features_occupied);

% Goal is to maximize Sb and minimize Sw. Which is reduced to the
% dominant eigenvector associated inv(Sw)*Sb. Note couldn't calculate true
% inverse. V becomes the vector to project all the data on to.
[V, D] = eigs(pinv(Sw)*Sb,1);

% correct V being calculated in the opposite direction
if sum(V) > 0
    V = -1 * V;
end

% Project the empty and occupied data sets on the FDA vector V.
p_em = features_empty*V;
p_oc = features_occupied*V;

hold on;
histogram(p_oc);
histogram(p_em);

% Fit a gaussian distribution or the empty and occupied data
h_oc = fitdist(p_oc,'Normal');
h_em = fitdist(p_em,'Normal');

% decision boundary where the two distributions are equal
db = fzero(@(x) normpdf(x, h_oc.mu, h_oc.sigma) - normpdf(x, h_em.mu, h_em.sigma), 0);

% display the decision boundary
x=[db,db];
y=[0,200];
plot(x,y,'r-.');
legend(sprintf('Occupied (total: %d)', ...
    length(p_oc)), sprintf('Empty (total: %d)', ...
    length(p_em)), sprintf('Decision Boundary (x = %.4f)', db));

% Type 1 Error: False Positives - Empty when classified as occupied
t1_error = sum(p_em > db);

% Type 2 Error: False Negatives - Occupied when classified as empty
t2_error = sum(p_oc < db);

title(sprintf('Training Data Analysis\nT1 Error: %.1f%%, T2 Error: %.1f%%', 100*t1_error/length(p_em), 100*t2_error/length(p_oc)));

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
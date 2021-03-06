function [ decision_boundary, V ] = FisherDiscriminant( features_vector1, features_vector2, str)
    % Use Fisher Discriminant Analysis to reduce dimensions between empty and occupied
    % classes
    % Inputs:
    %   features_vector1 - the feature vectors of the occupied class
    %                       each feature vector is a row.
    %   features_vector2 - the feature vector of the empty class
    %                       each feature vector is a row.

    % Construct Sb, the scatter matrix for the distance between means
    Sb = (mean(features_vector2) - mean(features_vector1))'*(mean(features_vector2) - mean(features_vector1));
    % Construct Sw, the scatter matrix for the within covariances
    Sw = cov(features_vector1) + cov(features_vector2);

    % Goal is to maximize Sb and minimize Sw. Which is reduced to the
    % dominant eigenvector associated inv(Sw)*Sb. Note couldn't calculate true
    % inverse. V becomes the vector to project all the data on to.
    [V, ~] = eigs(pinv(Sw)*Sb,1);

    % It was found that the direction of the vector V is sometimes reversed
    % even for the exact same input. This little hack corrects the inconsistency.
    if sum(V) > 0
        V = -1 * V;
    end

    %% Find the histograms of the projected feature vectors
    % Project the empty and occupied data sets on the FDA vector V.
    p_empty = features_vector1*V;
    p_occupied = features_vector2*V;

    figure;
    hold on;
    histogram(p_occupied);
    histogram(p_empty);

    %% Determine the decision boundary
    % Fit a gaussian distribution to the empty and occupied data sets
    h_oc = fitdist(p_occupied,'Normal');
    h_em = fitdist(p_empty,'Normal');

    % choose the decision boundary where the two distributions are equal
    decision_boundary = fzero(@(x) normpdf(x, h_oc.mu, h_oc.sigma) - normpdf(x, h_em.mu, h_em.sigma), (h_oc.mu+h_em.mu)/2);

    %% Plot the decision boundary on the histograms and label the graph
    % display the decision boundary
    x=[decision_boundary,decision_boundary];
    y=ylim;
    plot(x,y,'r-.');
    legend(sprintf('Occupied (total: %d)', ...
        length(p_occupied)), sprintf('Empty (total: %d)', ...
        length(p_empty)), sprintf('Decision Boundary (x = %.4f)', decision_boundary));

    if h_oc.mu > h_em.mu
        % Type 1 Error: False Positives - Empty when classified as occupied
        FP = sum(p_empty > decision_boundary)/length(p_empty)*100;

        % Type 2 Error: False Negatives - Occupied when classified as empty
        FN = sum(p_occupied < decision_boundary)/length(p_occupied)*100;
    else
        % Type 1 Error: False Positives - Empty when classified as occupied
        FP = sum(p_empty < decision_boundary)/length(p_empty)*100;

        % Type 2 Error: False Negatives - Occupied when classified as empty
        FN = sum(p_occupied > decision_boundary)/length(p_occupied)*100;  
    end
    
    
    TP = sum(p_occupied < decision_boundary)/length(p_occupied)*100;
    TN = sum(p_empty > decision_boundary)/length(p_empty)*100;

    
    Overall_Error = (FP + FN)/ (TP + TN + FP + FN) * 100;
    str1 = sprintf('%s Training Data Overall Error: %.2f%%', str, Overall_Error);
    title(str1);

end


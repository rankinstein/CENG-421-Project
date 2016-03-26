function [ decision_boundary, V ] = FisherDiscriminant( features_vector1, features_vector2, str)
    % Use Fisher Discriminant Analysis to reduce dimensions between empty and occupied
    % Construct Sb, the scatter matrix for the distance between means
    Sb = (mean(features_vector2) - mean(features_vector1))'*(mean(features_vector2) - mean(features_vector1));
    % Construct Sw, the scatter matrix for the within covariances
    Sw = cov(features_vector1) + cov(features_vector2);

    % Goal is to maximize Sb and minimize Sw. Which is reduced to the
    % dominant eigenvector associated inv(Sw)*Sb. Note couldn't calculate true
    % inverse. V becomes the vector to project all the data on to.
    [V, ~] = eigs(pinv(Sw)*Sb,1);

    % correct V being calculated in the opposite direction
    if sum(V) > 0
        V = -1 * V;
    end

    % Project the empty and occupied data sets on the FDA vector V.
    p_em = features_vector1*V;
    p_oc = features_vector2*V;

    figure;
    hold on;
    histogram(p_oc);
    histogram(p_em);

    % Fit a gaussian distribution or the empty and occupied data
    h_oc = fitdist(p_oc,'Normal');
    h_em = fitdist(p_em,'Normal');

    % decision boundary where the two distributions are equal
    decision_boundary = fzero(@(x) normpdf(x, h_oc.mu, h_oc.sigma) - normpdf(x, h_em.mu, h_em.sigma), (h_oc.mu+h_em.mu)/2);

    % display the decision boundary
    x=[decision_boundary,decision_boundary];
    y=ylim;
    plot(x,y,'r-.');
    legend(sprintf('Occupied (total: %d)', ...
        length(p_oc)), sprintf('Empty (total: %d)', ...
        length(p_em)), sprintf('Decision Boundary (x = %.4f)', decision_boundary));

    if h_oc.mu > h_em.mu
        % Type 1 Error: False Positives - Empty when classified as occupied
        t1_error = sum(p_em > decision_boundary);

        % Type 2 Error: False Negatives - Occupied when classified as empty
        t2_error = sum(p_oc < decision_boundary);
    else
        % Type 1 Error: False Positives - Empty when classified as occupied
        t1_error = sum(p_em < decision_boundary);

        % Type 2 Error: False Negatives - Occupied when classified as empty
        t2_error = sum(p_oc > decision_boundary);  
    end
    str1 = sprintf('%s Training Data T1 Error: %.1f%%, T2 Error: %.1f%%', str, 100*t1_error/length(p_em), 100*t2_error/length(p_oc));
    title(str1);

end


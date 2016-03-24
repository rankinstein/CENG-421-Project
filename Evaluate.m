function Evaluate( feature_vector1,feature_vector2, p_vector, decision_boundary, str )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
p_empty = feature_vector1 * p_vector;
p_occupied = feature_vector2 * p_vector;
figure;
    hold on;
    histogram(p_occupied);
    histogram(p_empty);

    % Fit a gaussian distribution or the empty and occupied data
    h_oc = fitdist(p_occupied,'Normal');
    h_em = fitdist(p_empty,'Normal');

    % display the decision boundary
    x=[decision_boundary,decision_boundary];
    y=ylim;
    plot(x,y,'r-.');
    legend(sprintf('Occupied (total: %d)', ...
        length(p_occupied)), sprintf('Empty (total: %d)', ...
        length(p_empty)), sprintf('Decision Boundary (x = %.4f)', decision_boundary));

    if h_oc.mu > h_em.mu
        % Type 1 Error: False Positives - Empty when classified as occupied
        t1_error = sum(p_empty > decision_boundary);

        % Type 2 Error: False Negatives - Occupied when classified as empty
        t2_error = sum(p_occupied < decision_boundary);
    else
        % Type 1 Error: False Positives - Empty when classified as occupied
        t1_error = sum(p_empty < decision_boundary);

        % Type 2 Error: False Negatives - Occupied when classified as empty
        t2_error = sum(p_occupied > decision_boundary);  
    end
    str1 = sprintf('%s T1 Error: %.1f%%, T2 Error: %.1f%%', str, 100*t1_error/length(p_empty), 100*t2_error/length(p_occupied));
    title(str1);


end


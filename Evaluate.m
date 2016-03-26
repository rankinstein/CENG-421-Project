function confusion_matrix = Evaluate( feature_vector1,feature_vector2, p_vector, decision_boundary, str )
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

    % Type 1 Error: False Positives - Empty when classified as occupied
    % Number of unoccupied detections when looking at ocuppied
    FP = sum(p_empty < decision_boundary)/length(p_empty)*100;

    % Type 2 Error: False Negatives - Occupied when classified as empty
     % Number of occupied detections when looking at unocuppied
    FN = sum(p_occupied > decision_boundary)/length(p_occupied)*100; 

    TP = sum(p_occupied < decision_boundary)/length(p_occupied)*100;
    TN = sum(p_empty > decision_boundary)/length(p_empty)*100;

    
    Overall_Error = (FP + FN)/ (TP + TN + FP + FN) * 100;
    str1 = sprintf('%s Overall Error: %.2f%%', str, Overall_Error);
    title(str1);

    confusion_matrix = [TP FN; FP TN];
end

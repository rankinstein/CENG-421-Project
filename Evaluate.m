function confusion_matrix = Evaluate( feature_vector1,feature_vector2, p_vector, decision_boundary, str )
    %% Evaluate
    % Evaluates a given results from a classfieer
    % Input Parameters
    % feature vector1               - feature vector of empty parking spots
    % feature vector2               - feature vector of occupied parking spots
    % p_vector                      - projection vector
    % decision_boundary             - decision boundary 
    % str                           - string used from title of plots
    %Ouput
    % confusion matrix              -  confusion matrix 

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
        FP = sum(p_empty > decision_boundary);

        % Type 2 Error: False Negatives - Occupied when classified as empty
        FN = sum(p_occupied < decision_boundary);
    else
        % Type 1 Error: False Positives - Empty when classified as occupied
        FP = sum(p_empty < decision_boundary);

        % Type 2 Error: False Negatives - Occupied when classified as empty
        FN = sum(p_occupied > decision_boundary);  
   end
    %compute the True positve and true negatives
    TP = sum(p_occupied < decision_boundary);
    TN = sum(p_empty > decision_boundary);

    %Compute the overall error so we can compare results with paper
    Overall_Error = (FP + FN)/ (TP + TN + FP + FN) * 100;
    str1 = sprintf('%s Test Overall Error: %.2f%%', str, Overall_Error);
    title(str1);
    
    %construct confusion matrix
    c = [TP FN; FP TN];
    confusion_matrix = array2table(c, 'RowNames', {'occupied' 'empty'}, 'VariableNames', {'occupied', 'empty'});
end


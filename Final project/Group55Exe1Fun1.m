%Michail Dadopoulos
%Dimos Kompitselidis


function [p1,p2]=Group55Exe1Fun1(vec)
    % Count the number of distinct values in the vector
    
    vec=vec(~isnan(vec));
    n = length(unique(vec));
    
    % Check if the number of distinct values is greater than 10
    if n > 10
        figure(1)
        clf
        % Plot histogram with appropriate bin width
        histogram(vec, round(sqrt(n)));
        
        % Perform Chi-squared goodness-of-fit test on normal and uniform distributions
        [~, p1] = chi2gof(vec);
        pd = makedist('Uniform','lower',min(vec),'upper',max(vec));
        [~, p2] = chi2gof(vec, 'CDF', pd );
        
        % Display the p-values on the graph
        title(sprintf('p-value for normal distribution = %3.5f\np-value for uniform distribution = %3.5f', p1, p2));
    else
        figure(1)
        clf
        % Plot bar graph with appropriate bin width
        bar(unique(vec));
   
        % Perform Chi-squared goodness-of-fit test on bionomial and uniform distributions
        pd1 = fitdist(vec,'Binomial','NTrials',length(vec));
        [~, p1] = chi2gof(vec,"CDF",pd1);
        pd2 = makedist('Uniform','lower',min(vec),'upper',max(vec));
        [~, p2] = chi2gof(vec, 'CDF', pd2 );
        
        % Display the p-values on the graph
        title(sprintf('p-value for Binomial distribution = %3.9f\np-value for uniform distribution = %3.5f', p1, p2));
    end
end
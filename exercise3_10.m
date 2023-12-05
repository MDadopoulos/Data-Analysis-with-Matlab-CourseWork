% Exercise 10 of Chp.3
% Statistical test for mean using parametric test and (percentile) 
% bootstrap test.
clear all
n = 10; % sample size
mu = 0; % mean of data generating distribution
sigma = 1; % SD of data generating distribution
M = 100; % number of realizations
B = 1000; % number of bootstraps
alpha = 0.05; % significance level
dosquare = 1; % If 1, do square transform first
mu0 = 2; % value to test for mean 
         % Note that for square transform of standard Gaussian the mean is 
         % 1 (the mean of the Chi-square distribution with one degree of 
         % freedom).

% rng(1);
% Generation of all M samples
xM = mu*ones(n,M) + sigma*ones(n,M).*randn(n,M);
if dosquare
    xM = xM.^2;
end
xmV = mean(xM)';
xsdV = std(xM)';
pvalmxM = NaN(M,2); % the first column is for the p-values of the parametric
                    % tests, the second for the percentile bootstrap tests 
klower = floor((B+1)*alpha/2);
kup = B+1-klower;
tailpercV = [klower kup]*100/B;
tcrit = tinv(1-alpha/2,n-1);
for iM = 1:M
    % Parametric hypothesis testing for mean 
    tsample = (xmV(iM)-mu0) / (xsdV(iM) / sqrt(n));
    pvalmxM(iM,1) = 2*(1-tcdf(abs(tsample),n-1)); % p-value for two-sided test
    % Percentile Bootstrap hypothesis testing for mean
    newxV = xM(:,iM) - xmV(iM) + mu0; % The sample consistent with the H0
    bootmxV = NaN(B,1);   
    for iB=1:B
        rV = unidrnd(n,n,1);
        xbV = newxV(rV);
        bootmxV(iB) = (mean(xbV)-mu0) / (std(xbV) / sqrt(n));
    end
    allmxV = [tsample; bootmxV];
    [~,imxV] = sort(allmxV);
    rankmx0 = find(imxV == 1);
    % With the following, strange situations are handled, such as one or
    % more bootstrap statistics being identical to the original and even 
    % all statistics (original and bootstrap) are identical.
    multiplemxV = find(allmxV==allmxV(1));
    if length(multiplemxV)==B+1
        rankmx0=round(n/2); % If all identical give rank ins the middle
    elseif length(multiplemxV)>=2
        irand = unidrnd(length(multiplemxV));
        rankmx0 = rankmx0+irand-1; % If at least one bootstrap statistic 
               % identical to the original pick the rank of one of them at
               % random  
    end
    if rankmx0 > 0.5*(B+1)
        pvalmxM(iM,2) = 2*(1-rankmx0/(B+1));
    else
        pvalmxM(iM,2) = 2*rankmx0/(B+1);
    end   
end
% Make a plot of the cumulative p-values, so that you can read the 
% probability (relative frequency) of rejection (y-axis) for each alpha 
% value (x-axis)
[prob1V,pval1V] = ecdf(pvalmxM(:,1));
[prob2V,pval2V] = ecdf(pvalmxM(:,2));
figure(1)
clf
stairs(pval1V,prob1V,'-b','linewidth',2);
hold on
stairs(pval2V,prob2V,'-r','linewidth',2);
plot(alpha*[1 1],ylim,'c--','linewidth',2)
xlabel('p-value')
ylabel('relative frequency')
title(sprintf('M=%d, B=%d n=%d, p-value of test for mean ',M,B,n))
legend('parametric','bootstrap','Location','Best')

fprintf('Probability of rejection of mean=%f at alpha=%f, parametric = %f \n',...
    mu0,alpha,sum(pvalmxM(:,1)<alpha)/M); 
fprintf('Probability of rejection of mean=%f at alpha=%f, bootstrap = %f \n',...
    mu0,alpha,sum(pvalmxM(:,2)<alpha)/M); 




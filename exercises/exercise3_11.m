% Exercise 10 of Chp.3
% Statistical test for equal means using percentile bootstrap and
% random permutation (randomization) along with the parametric test.
clear all
n = 10;
mux = 0;
sigmax = 1;
m = 12;
muy = 0;
sigmay = 1;
M = 100;
B = 1000;
alpha = 0.05;
dosquare = 0; % If 1, do square transform first
nbin = 10;

% rng(1);
% Generation of all M samples
xM = mux*ones(n,M) + sigmax*ones(n,M).*randn(n,M);
yM = muy*ones(m,M) + sigmay*ones(m,M).*randn(m,M);
if dosquare
    xM = xM.^2;
    yM = yM.^2;
end
xmV = mean(xM)';
xsdV = std(xM)';
ymV = mean(yM)';
ysdV = std(yM)';
pvaldmxM = NaN(M,3); % the first column is for the p-values of the parametric
                     % tests and the second for the bootstrap tests, and
                     % the third for the randomization test
klower = floor((B+1)*alpha/2);
kup = B+1-klower;
tailpercV = [klower kup]*100/B;
tcrit = tinv(1-alpha/2,n+m-2);
for iM = 1:M
    %% Parametric hypothesis testing for mean difference
    dmx = xmV(iM) - ymV(iM);
    vardxt = (xsdV(iM)^2*(n-1)+ysdV(iM)^2*(m-1)) / (n+m-2);
    sddxt = sqrt(vardxt);
    tsample = dmx / (sddxt * sqrt(1/n+1/m));
    pvaldmxM(iM,1) = 2*(1-tcdf(abs(tsample),n+m-2)); % p-value for two-sided test
    %% Bootstrap hypothesis testing for mean difference
    bootdmxV = NaN(B,1);
    for iB=1:B
        rV = unidrnd(n+m,n+m,1);
        xyV = [xM(:,iM); yM(:,iM)];
        xbV = xyV(rV(1:n));
        ybV = xyV(rV(n+1:n+m));
        bootdmxV(iB) = mean(xbV)-mean(ybV);
    end
    alldmxV = [dmx; bootdmxV];
    [~,idmxV] = sort(alldmxV);
    rankdmx0 = find(idmxV == 1);
    % With the following, strange situations are handled, such as all
    % statistics (original and bootstrap) are identical or there are
    % bootstrap statistics identical to the original.
    multipledmxV = find(alldmxV==alldmxV(1));
    if length(multipledmxV)==B+1
        rankdmx0=round(n/2); % If all identical give rank in the middle
    elseif length(multipledmxV)>=2
        irand = unidrnd(length(multipledmxV));
        rankdmx0 = rankdmx0+irand-1; % If at least one bootstrap statistic 
               % identical to the original pick the rank of one of them at
               % random  
    end
    if rankdmx0 > 0.5*(B+1)
        pvaldmxM(iM,2) = 2*(1-rankdmx0/(B+1));
    else
        pvaldmxM(iM,2) = 2*rankdmx0/(B+1);
    end
    %% Randomization hypothesis testing for mean difference
    randdmxV = NaN(B,1);
    for iB=1:B
        rV = randperm(n+m);
        xyV = [xM(:,iM); yM(:,iM)];
        xbV = xyV(rV(1:n));
        ybV = xyV(rV(n+1:n+m));
        randdmxV(iB) = mean(xbV)-mean(ybV);
    end
    alldmxV = [dmx; randdmxV];
    [~,idmxV] = sort(alldmxV);
    rankdmx0 = find(idmxV == 1);
    % With the following, strange situations are handled, such as all
    % statistics (original and randomized) are identical or there are
    % randomized statistics identical to the original.
    multipledmxV = find(alldmxV==alldmxV(1));
    if length(multipledmxV)==B+1
        rankdmx0=round(n/2); % If all identical give rank in the middle
    elseif length(multipledmxV)>=2
        irand = unidrnd(length(multipledmxV));
        rankdmx0 = rankdmx0+irand-1; % If at least one randstrap statistic 
               % identical to the original pick the rank of one of them at
               % random  
    end
    if rankdmx0 > 0.5*(B+1)
        pvaldmxM(iM,3) = 2*(1-rankdmx0/(B+1));
    else
        pvaldmxM(iM,3) = 2*rankdmx0/(B+1);
    end
end
% Make a plot of the cumulative p-values, so that you can read the 
% probability (relative frequency) of rejection (y-axis) for each alpha 
% value (x-axis)
[prob1V,pval1V] = ecdf(pvaldmxM(:,1));
[prob2V,pval2V] = ecdf(pvaldmxM(:,2));
[prob3V,pval3V] = ecdf(pvaldmxM(:,3));
figure(1)
clf
stairs(pval1V,prob1V,'-b','linewidth',2);
hold on
stairs(pval2V,prob2V,'-r','linewidth',2);
stairs(pval3V,prob3V,'-k','linewidth',2);
plot(alpha*[1 1],ylim,'c--','linewidth',2)
xlabel('p-value')
ylabel('relative frequency')
title(sprintf('M=%d, B=%d n=%d, p-value of test for mean difference',M,B,n))
legend('parametric','bootstrap','randomization','Location','Best')

fprintf('Probability of rejection of equal mean at alpha=%1.3f, parametric = %1.3f \n',...
    alpha,sum(pvaldmxM(:,1)<alpha)/M); 
fprintf('Probability of rejection of equal mean at alpha=%1.3f, bootstrap = %1.3f \n',...
    alpha,sum(pvaldmxM(:,2)<alpha)/M); 
fprintf('Probability of rejection of equal mean at alpha=%1.3f, randomization = %1.3f \n',...
    alpha,sum(pvaldmxM(:,3)<alpha)/M); 




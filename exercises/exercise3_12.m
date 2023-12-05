% Exercise 12 of Chp.3
% Statistical test for equal means using bootstrap along with the 
% parametric test without assuming same distribution (and thus equal
% variances). 
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
dosquare = 1; % If 1, do square transform first

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
pvaldmxM = NaN(M,4); % the first column is for the p-values of the parametric
                     % tests and the second for the bootstrap tests 
klower = floor((B+1)*alpha/2);
kup = B+1-klower;
tailpercV = [klower kup]*100/B;
tcrit = tinv(1-alpha/2,n+m-2);
for iM = 1:M
    %% Parametric hypothesis testing for mean difference (equal variances not assumed)
    dmx = xmV(iM) - ymV(iM);
    varmx = xsdV(iM)^2/n;
    varmy = ysdV(iM)^2/m; % Not equal variances assumed
    sddxt = sqrt(varmx + varmy);
    tsample = dmx / sddxt;
    dfe = (varmx + varmy)^2 / (varmx^2/(n-1)+varmy^2/(m-1));   
    pvaldmxM(iM,1) = 2*(1-tcdf(abs(tsample),dfe)); % p-value for two-sided test
    %% Bootstrap hypothesis testing for mean difference
    % The statistic is computed on bootstrap sampled from the merged sample
    xyV = [xM(:,iM); yM(:,iM)];
    meanall = mean(xyV);
    newxV = xM(:,iM)-xmV(iM)+meanall;
    newyV = yM(:,iM)-ymV(iM)+meanall;
    bootstatV = NaN(B,1);   
    for iB=1:B
        rV = unidrnd(n+m,n+m,1);
        xbV = xyV(rV(1:n));
        ybV = xyV(rV(n+1:n+m));
        bootstatV(iB) = (mean(xbV)-mean(ybV)) / sqrt(var(xbV)/n + var(ybV)/m);
    end
    alldmxV = [tsample; bootstatV];
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
end
% Make a plot of the cumulative p-values, so that you can read the 
% probability (relative frequency) of rejection (y-axis) for each alpha 
% value (x-axis)
[prob1V,pval1V] = ecdf(pvaldmxM(:,1));
[prob2V,pval2V] = ecdf(pvaldmxM(:,2));
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

fprintf('Probability of rejection of equal mean (unequal variances) at alpha=%1.3f \n', alpha) 
fprintf(' parametric = %1.3f \n',sum(pvaldmxM(:,1)<alpha)/M); 
fprintf(' bootstrap = %1.3f \n',sum(pvaldmxM(:,2)<alpha)/M); 

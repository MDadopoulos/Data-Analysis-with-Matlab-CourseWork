% Data from eruption of geyser, waiting and duration from 2006 and waiting
% from 1989.
% Estimation and hypothesis testing on mean, variance and hypothesis
% testing for goodness of fit to normal distribution.
datdir = 'c:\MyFiles\Teach\DataAnalysis\Data\';
dattxt = 'eruption';
% 1->expectation time, 2-> duration, 3-> as 1 for 1996.
tittxtM = str2mat('waiting time 1989','duration 1989','waiting time 2006');
sigma0V = [10 1 10]'; % Sigma tested for each column of data matrix
varalpha = 0.05;
mu0V = [75 3 75]'; % Mu tested for each column of data matrix
mualpha = 0.05;
durationthrs = 2.5; % threshold for duration
wait0V = [65 91]'; % waiting time for below and over duration threshold
wait0sd = 10; % SD for the waiting times of small and long duration

eval(['load ',datdir,dattxt,'.dat'])
eval(['xM = ',dattxt,';'])
[n,m]=size(xM);
nbin = round(sqrt(n));
for i=1:m
    xV = xM(:,i);
    sigma0 = sigma0V(i);
    mu0 = mu0V(i);
    figure((i-1)*2+1)
    clf
    histfit(xV,nbin)
    xlabel('x')
    ylabel('counts')
    title(sprintf('%s: n=%d ',deblank(tittxtM(i,:)),n))
    figure(i*2)
    clf
    boxplot(xV)
    title(sprintf('%s: n=%d ',deblank(tittxtM(i,:)),n))
    % (a) and (b)
    [h,pvar,civarV]=vartest(xV,sigma0^2,varalpha);
    fprintf('==== %s ==== \n',deblank(tittxtM(i,:)))
    fprintf('---- 3.5 (a) ----- \n');
    fprintf('CI for sigma(X)=[%2.3f,%2.3f] \n',sqrt(civarV(1)),sqrt(civarV(2)));
    fprintf('---- 3.5 (b) ----- \n');
    fprintf('p-value (for H:sigma=%2.2f) = %1.5f \n',sigma0,pvar);
    % (c) and (d)
    [h,pmu,cimuV]=ttest(xV,mu0,mualpha);
    fprintf('---- 3.5 (c) ----- \n');
    fprintf('CI for mu(X)=[%2.3f,%2.3f] \n',cimuV(1),cimuV(2));
    fprintf('---- 3.5 (d) ----- \n');
    fprintf('p-value (for H:mu=%2.2f) = %1.5f \n',mu0,pmu);
    % (e)
    % [h,pgof,gofstats]=chi2gof(xV,'nbins',nbin)
    [h,pgof,gofstats]=chi2gof(xV);
    fprintf('---- 3.5 (e) ----- \n');
    fprintf('p-value (for H:normal fit) = %1.5f \n',pgof);
    fprintf('\t observed \t expected frequencies \n');
    Kc = length(gofstats.O);
    for j=1:Kc
        fprintf('\t %3.3f \t %3.3f \n',gofstats.O(j),gofstats.E(j));
    end
    disp('press any key to continue ...')
    pause;
end
% Check the claim for the waiting time regarding the duration below and
% over threshold
i1V = find(xM(:,2)<durationthrs);
i2V = setdiff([1:n]',i1V);
x1V = xM(i1V,1);
x2V = xM(i2V,1);
for i=1:2
    eval(['xV = x',int2str(i),'V;'])
    nnow = length(xV);
    figure(2*m+(i-1)*2+1)
    clf
    histfit(xV,nbin)
    xlabel('x')
    ylabel('counts')
    title(sprintf('Waiting time %d, n=%d ',i,nnow))
    figure(2*m+i*2)
    clf
    boxplot(xV)
    title(sprintf('Waiting time %d, n=%d ',i,nnow))
    % (a) and (b)
    [h,pvar,civarV]=vartest(xV,wait0sd^2,varalpha);
    fprintf('==== Waiting time %d ==== \n',i)
    fprintf('---- 3.4 (a) ----- \n');
    fprintf('CI for sigma(X%d)=[%2.3f,%2.3f] \n',i,sqrt(civarV(1)),sqrt(civarV(2)));
    fprintf('p-value (for H:sigma=%2.2f) = %1.5f \n',wait0sd,pvar);
    % (c) and (d)
    [h,pmu,cimuV]=ttest(xV,wait0V(i),mualpha);
    fprintf('CI for mu(X%d)=[%2.3f,%2.3f] \n',i,cimuV(1),cimuV(2));
    fprintf('p-value (for H:mu=%2.2f) = %1.5f \n',wait0V(i),pmu);
    % (e)
    % [h,pgof,gofstats]=chi2gof(xV,'nbins',nbin)
    [h,pgof,gofstats]=chi2gof(xV);
    fprintf('p-value (for H:normal fit) = %1.5f \n',pgof);
    fprintf('\t observed \t expected frequencies \n');
    Kc = length(gofstats.O);
    for j=1:Kc
        fprintf('\t %3.3f \t %3.3f \n',gofstats.O(j),gofstats.E(j));
    end
    disp('press any key to continue ...')
    pause;
end
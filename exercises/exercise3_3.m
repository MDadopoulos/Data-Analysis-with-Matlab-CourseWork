% Exercise 3.3
% Simulation of the confidence interval estimation of the mean of the 
% exponential distribution 
M = 1000;
n = 100;
tau = 15;
alpha = 0.05;
nbin = round(sqrt(M/5));

hV = NaN*ones(M,1);
cimxM = NaN*ones(2,M);
for iMC = 1:M
    xV = exprnd(tau,n,1);
    [hV(iMC),p,cimxM(:,iMC)]=ttest(xV,tau,alpha);
end
fprintf('Estimated probability of rejection=%1.3f \n',sum(hV)/M);

figure(1)
clf
hist(cimxM(1,:),nbin)
hold on
ax = axis;
plot(tau*[1 1],[ax(3) ax(4)],'r')
xlabel(sprintf('lower limit of CI for mean [P(lower>tau)=%1.3f]',...
    length(find(cimxM(1,:)>tau))/M))
ylabel('counts')
title(sprintf('Exponential: tau=%2.2f M=%d n=%d CI-lower for alpha=%1.3f',...
    tau,M,n,alpha))

figure(2)
clf
hist(cimxM(2,:),nbin)
hold on
ax = axis;
plot(tau*[1 1],[ax(3) ax(4)],'r')
xlabel(sprintf('upper limit of CI for mean [P(upper<tau)=%1.3f]',...
    length(find(cimxM(2,:)<tau))/M))
ylabel('counts')
title(sprintf('Exponential: tau=%2.2f M=%d n=%d CI-upper for alpha=%1.3f',...
    tau,M,n,alpha))

    

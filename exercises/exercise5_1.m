% Exercise 5.1
rho = 0.5; % 0.0, 0.5
n = 100;
M = 1000;
muxV = [0 0]';
sdxV = [1 1]';
bins = round(sqrt(M));
alpha = 0.05;
exponent = 2;
if exponent == 2
    rho2 = rho.^2;
else
    rho2 = rho;
end
% randn('state',0);

% (a)
rV = NaN*ones(M,1);
for i=1:M
    xM = mvnrnd(muxV',[sdxV(1)^2 rho; rho sdxV(2)^2],n);
    xM = xM.^exponent;
    rM=corrcoef(xM);
    rV(i) = rM(1,2);
end
% confidence interval using Fisher transform (tanh)
zV = 0.5*log((1+rV)./(1-rV));
zcrit = norminv(1-alpha/2);
zsd = sqrt(1/(n-3));
zlV = zV-zcrit*zsd;
zuV = zV+zcrit*zsd;
rlV = (exp(2*zlV)-1)./(exp(2*zlV)+1);
ruV = (exp(2*zuV)-1)./(exp(2*zuV)+1);
% hypothesis test for H0: rho=0 using the t-statistic
tV = rV.*sqrt((n-2)./(1-rV.^2));
tcrit = tinv(1-alpha/2,n-2);

figure(1)
clf
hist(rV,bins)
hold on
ax = axis;
plot(rho2*[1 1],[ax(3) ax(4)],'r')
xlabel('r')
ylabel('counts')
title(sprintf('rho=%1.2f n=%d M=%d alpha=%1.2f r-histogram',rho,n,...
    M,alpha))
figure(2)
clf
hist(zV,bins)
hold on
ax = axis;
plot((0.5*log((1+rho2)./(1-rho2)))*[1 1],[ax(3) ax(4)],'r')
xlabel('z')
ylabel('counts')
title(sprintf('rho=%1.2f n=%d M=%d alpha=%1.2f z-histogram',rho,n,...
    M,alpha))
% CI
figure(3)
clf
hist(rlV,bins)
hold on
ax = axis;
plot(rho2*[1 1],[ax(3) ax(4)],'r')
xlabel('lower r')
ylabel('counts')
rholow = length(find(rho2<rlV));
title(sprintf('rho=%1.2f n=%d M=%d alpha=%1.2f p(rho<r_l)=%d/%d',rho,n,...
    M,alpha,rholow,M))
figure(4)
clf
hist(ruV,bins)
hold on
ax = axis;
plot(rho2*[1 1],[ax(3) ax(4)],'r')
xlabel('upper r')
ylabel('counts')
rhoupp = length(find(rho2>ruV));
title(sprintf('rho=%1.2f n=%d M=%d alpha=%1.2f p(rho>r_u)=%d/%d',rho,n,...
    M,alpha,rhoupp,M))
pnotinCI = length(find(rho2>rlV & rho2<ruV))/M;
fprintf('rho=%1.2f n=%d M=%d 1-alpha=%1.2f p(rho in [rl,ru])=%1.5f \n',...
    rho,n,M,1-alpha,pnotinCI);
% H0
figure(5)
clf
hist(tV,bins)
hold on
ax = axis;
plot(tcrit*[1 1],[ax(3) ax(4)],'r')
plot(-tcrit*[1 1],[ax(3) ax(4)],'r')
xlabel('t-statistic')
ylabel('counts')
ntsig = length(find(abs(tV)<tcrit));
title(sprintf('rho=%1.2f n=%d M=%d alpha=%1.2f p(|t|<t_{%d-2,1-%1.2f/2})=%d/%d',...
    rho,n,M,alpha,n,alpha,ntsig,M))
pval = 1-ntsig/M;
fprintf('rho=%1.2f n=%d M=%d alpha=%1.2f H0(rho=0): p-value=%1.5f \n',...
    rho,n,M,alpha,pval);


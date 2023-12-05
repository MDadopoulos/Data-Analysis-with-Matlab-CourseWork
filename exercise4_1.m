% Exercise 4.1
% Uncertainty in the coefficient of restitution and propagation of error
% of the height after bouncing to the error of the coefficient of
% restitution.
h1 = 100; % height of free fall
h2V = [60 54 58 60 56]'; % heights afte bouncing
e0 = 0.76; % expected coefficient of restitution
ealpha = 0.05;
M = 1000;
n = 5;
muh2 = 58;
sigmah2 = 2;

% (a)
eV = sqrt(h2V / h1);
esd = std(eV);
emean = mean(eV);
n = length(eV);
tcrit = tinv(1-ealpha/2,n-1); 
esderr = esd / sqrt(n); 

[h,pe,cieV]=ttest(eV,e0,ealpha);
fprintf('---- 4.1 (a) ----- \n');
fprintf('Precision of COR for one throw: \n \t e_i +- SD_e = e_i +- %2.3f \n',esd);
fprintf('Precision limit of COR for one throw: \n \t e_i +- t_{%d,1-%1.2f/2} SD_e = e_i +- %2.3f * %2.3f = e_i +- %2.3f \n',...
    n-1,ealpha,tcrit,esd,tcrit*esd);
fprintf('Precision of mean COR: \n \t mean +- SD(mean) = %2.3f +- %2.3f / sqrt(%d) = %2.3f +- %2.3f \n',...
    emean,esd,n,emean,esderr);
fprintf('Precision limit of mean COR: \n \t mean +- t_{%d,1-%1.2f/2} SD(mean) = %2.3f +- %2.3f * %2.3f = %2.3f +- %2.3f \n',...
    n-1,ealpha,emean,tcrit,esderr,emean,tcrit*esderr);
fprintf('\n');

% (b)
h2meanV = NaN*ones(M,1);
h2sdV = NaN*ones(M,1);
emeanV = NaN*ones(M,1);
esdV = NaN*ones(M,1);
for i=1:M
    h2V = muh2 + sigmah2*randn(n,1);
    eV = sqrt(h2V ./ h1);
    h2sdV(i) = std(h2V);
    h2meanV(i) = mean(h2V);
    esdV(i) = std(eV);
    emeanV(i) = mean(eV);
end
mue = sqrt(muh2 / h1);
sigmae = 0.5*sqrt(1/h1)*sqrt(1/muh2)*sigmah2;
figure(1)
clf
hist(h2meanV)
hold on
ax = axis;
title(['Mean of h_2, M=',int2str(M)])
plot(muh2*[1 1],[ax(3) ax(4)],'r')
figure(2)
clf
hist(h2sdV)
hold on
ax = axis;
plot(sigmah2*[1 1],[ax(3) ax(4)],'r')
title(['SD of h_2, M=',int2str(M)])
figure(3)
clf
hist(emeanV)
hold on
ax = axis;
plot(mue*[1 1],[ax(3) ax(4)],'r')
title(['Mean of e, M=',int2str(M)])
figure(4)
clf
hist(esdV)
hold on
ax = axis;
plot(sigmae*[1 1],[ax(3) ax(4)],'r')
title(['SD of e, M=',int2str(M)])

% (c)
% Uncertainty in the coefficient of restitution and propagation of error
% of the height after bouncing to the error of the coefficient of
% restitution.
h1V = [80 100 90 120 95]'; % height of free fall
h2V = [48 60 50 75 56]'; % heights after bouncing
e0 = 0.76; % expected coefficient of restitution
alpha = 0.05;

n = length(h1V);
eV = sqrt(h2V ./ h1V);
h1sd = std(h1V);
h1mean = mean(h1V);
h2sd = std(h2V);
h2mean = mean(h2V);
esd = std(eV);
emean = mean(eV);

% First (simple) approach: h1 and h2 are assumed to be independent
esigma = sqrt((-0.5*sqrt(h2mean)*h1mean^(-3/2))^2*h1sd^2 + ...
    (0.5*sqrt(1/h1mean)*sqrt(1/h2mean))^2*h2sd^2);
fprintf('---- 4.1 (c) ----- \n');
fprintf('SD of COR computed from transformed data: %2.5f \n',esd);
fprintf('SD of COR computed from transformed SD (assume independence): %2.5f \n',esigma);
% Second approach: h1 and h2 are assumed to be dependent to each other
tmp =  corrcoef(h1V,h2V);
r = tmp(1,2);
h1h2covar = h1sd * h2sd * r;
esigma2 = sqrt((-0.5*sqrt(h2mean)*h1mean^(-3/2))^2*h1sd^2 + ...
    (0.5*sqrt(1/h1mean)*sqrt(1/h2mean))^2*h2sd^2 + ...
    2*(-0.5*sqrt(h2mean)*h1mean^(-3/2))*(0.5*sqrt(1/h1mean)*sqrt(1/h2mean))*h1h2covar);
fprintf('SD of COR computed from transformed SD (assume dependence): %2.5f \n',esigma2);



% Exercise 9 of Chp.3
% Comparison of percentile bootstrap and parametric confidence interval of
% mean difference. 
clear all
n = 10;
mux = 0;
sigmax = 1;
m = 10;
muy = 0.0;
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
cidmxM = NaN(M,4); % the two first are the limits of parametric ci for mean  
              % difference, the other two for the percentile bootstrap ci 
              % for mean difference
klower = floor((B+1)*alpha/2);
kup = B+1-klower;
tailpercV = [klower kup]*100/B;
tcrit = tinv(1-alpha/2,n+m-2);
diffmeanF = @(x1,x2) mean(x1)-mean(x2);
for iM = 1:M
    % Parametric confidence interval (ci) for mean difference
    dmx = xmV(iM) - ymV(iM);
    vardxt = (xsdV(iM)^2*(n-1)+ysdV(iM)^2*(m-1)) / (n+m-2);
    sddxt = sqrt(vardxt);
    mdxterr = tcrit * sddxt * sqrt(1/n+1/m);
    cidmxM(iM,1:2) = [dmx-mdxterr dmx+mdxterr];
    % Percentile bootstrap ci for mean
    bootdmxV = NaN(B,1);
    for iB=1:B
        rV = unidrnd(n,n,1);
        xbV = xM(rV,iM);
        rV = unidrnd(m,m,1);
        ybV = yM(rV,iM);
        bootdmxV(iB) = mean(xbV)-mean(ybV);
    end
    cidmxM(iM,3:4) = prctile(bootdmxV,tailpercV);
end
% For min
mxmin = min(min(cidmxM(:,[1 3])));
mxmax = max(max(cidmxM(:,[1 3])));
xcenterV = linspace(mxmin,mxmax,nbin+1);
xcenterV = xcenterV(1:nbin)+0.5*(xcenterV(2)-xcenterV(1));
parNx = hist(cidmxM(:,1),xcenterV);
bootNx = hist(cidmxM(:,3),xcenterV);
figure(1)
clf
plot(xcenterV,parNx/M,'.-','linewidth',1.5)
hold on
plot(xcenterV,bootNx/M,'.-r','linewidth',1.5)
xlabel('lower ci limit')
ylabel('relative frequency')
title(sprintf('M=%d, B=%d n=%d, lower limit of ci of mean difference',M,B,n))
legend('parametric','Perc.bootstrap','Location','Best')

% For max
mxmin = min(min(cidmxM(:,[2 4])));
mxmax = max(max(cidmxM(:,[2 4])));
xcenterV = linspace(mxmin,mxmax,nbin+1);
xcenterV = xcenterV(1:nbin)+0.5*(xcenterV(2)-xcenterV(1));
parNx = hist(cidmxM(:,2),xcenterV);
bootNx = hist(cidmxM(:,4),xcenterV);
figure(2)
clf
plot(xcenterV,parNx/M,'.-','linewidth',1.5)
hold on
plot(xcenterV,bootNx/M,'.-r','linewidth',1.5)
xlabel('upper ci limit')
ylabel('relative frequency')
title(sprintf('M=%d, B=%d n=%d, upper limit of ci of mean difference',M,B,n))
legend('parametric','Perc.bootstrap','Location','Best')

iparV = find(cidmxM(:,1)<0 & cidmxM(:,2)>0);
ibootV = find(cidmxM(:,3)<0 & cidmxM(:,4)>0);
fprintf('Coverage probability of %1.3f%% parametric ci of muX-muY = %1.3f \n',...
    (1-alpha)*100,length(iparV)/M); 
fprintf('Coverage probability of %1.3f%% percentile bootstrap ci of muX-muY = %1.3f \n',...
    (1-alpha)*100,length(ibootV)/M); 



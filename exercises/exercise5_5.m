% Exercise 5.5 - bootstrap confidence intervals for regression parameters
datdir = 'c:\MyFiles\Teach\DataAnalysis\Data\';
dattxt = 'lightair';
alpha = 0.05;
M = 1000;

xyM = load([datdir,dattxt,'.dat']);
xysM = sortrows(xyM);
xV = xysM(:,1);
yV = xysM(:,2);
n = length(xV);

xM = [ones(n,1) xV];
[bV, bint,r,rint,stats] = regress(yV,xM);
% se2 = ((n-1)/(n-2))*(vary-bV(2)^2*varx);
% se = sqrt(se2);

mx = mean(xV);
sx2 = sum(xV.^2);
varx = (sx2 - n* mx^2)/(n-1);
sdx = std(xV);
my = mean(yV);
sy2 = sum(yV.^2);
vary = (sy2 - n* my^2)/(n-1);
sdy = std(yV);
sxy = sum(xV.*yV);
covxy = (sxy - n*mx*my)/(n-1);
tmpM = corrcoef(xV,yV);
cc = tmpM(1,2);
xM = [ones(n,1) xV];
[bV, bint,r,rint,stats] = regress(yV,xM);
se2 = ((n-1)/(n-2))*(vary-bV(2)^2*varx);
se = sqrt(se2);

tcrit = tinv(1-alpha/2,n-2);
Sxx  = varx*(n-1);
b1sd = se / sqrt(Sxx);
b1ciV = [bV(2)-tcrit*b1sd  bV(2)+tcrit*b1sd]; 
b0sd = se *sqrt(1/n + mx^2/Sxx);
b0ciV = [bV(1)-tcrit*b0sd  bV(1)+tcrit*b0sd]; 

bbM = NaN*ones(M,2);
for i=1:M
    indxV = unidrnd(n,n,1);
    xbV = xysM(indxV,1);
    ybV = xysM(indxV,2);
    xbM = [ones(n,1) xbV];
    bbV = regress(ybV,xbM);
    bbM(i,:) = bbV(:)';
end
indxlow = round(M*alpha/2);
indxupp = round(M*(1-alpha/2));

ob0V = sort(bbM(:,1));
b0cibootV = [ob0V(indxlow) ob0V(indxupp)]; 
ob1V = sort(bbM(:,2));
b1cibootV = [ob1V(indxlow) ob1V(indxupp)]; 

disp(['n = ',int2str(n)])
disp(['b0 = ',num2str(bV(1),3),'   b1 = ',num2str(bV(2),3)])
fprintf('Parametric (1-%1.2f)%% CI for beta0=[%1.3f, %1.3f] \n',alpha,b0ciV(1),b0ciV(2));
fprintf('Bootstrap  (1-%1.2f)%% CI for beta0=[%1.3f, %1.3f] \n',alpha,b0cibootV(1),b0cibootV(2));
fprintf('Parametric (1-%1.2f)%% CI for beta1=[%1.3f, %1.3f] \n',alpha,b1ciV(1),b1ciV(2));
fprintf('Bootstrap  (1-%1.2f)%% CI for beta1=[%1.3f, %1.3f] \n',alpha,b1cibootV(1),b1cibootV(2));

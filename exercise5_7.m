% Exercise 5.7 
xM = [
1 0.76 110
2 0.86 105
3 0.97 100
4 1.11 95
5 1.45 85
6 1.67 80
7 1.92 75
8 2.23 70
9 2.59 65
10 3.02 60
11 3.54 55
12 4.16 50
13 4.91 45
14 5.83 40
15 6.94 35
16 8.31 30
17 10.00 25
18 12.09 20
19 14.68 15
20 17.96 10
21 22.05 5
22 27.28 0
23 33.89 -5
24 42.45 -10
25 53.39 -15
26 67.74 -20
27 86.39 -25
28 111.30 -30
29 144.00 -35
30 188.40 -40
31 247.50 -45
32 329.20 -50 
];
kmax = 3; % the degree of the polynomial regression
alpha = 0.05;
nresol = 1000;

xV = log(xM(:,2));
yV = 1./(273.15 + xM(:,3));
n = length(xV);

xysM = sortrows([xV yV]);
xV = xysM(:,1);
yV = xysM(:,2);

xmin = min(xV);
xmax = max(xV);
xgridV = (linspace(xmin,xmax,nresol))';
zcrit = norminv(1-alpha/2);
for k=1:kmax
    switch k
        case 1
            xM = [ones(n,1) xV];
            xgridM = [ones(nresol,1) xgridV];
        case 2
            xM = [ones(n,1) xV xV.^2];
            xgridM = [ones(nresol,1) xgridV xgridV.^2];
        case 3
            xM = [ones(n,1) xV xV.^2 xV.^3];
            xgridM = [ones(nresol,1) xgridV xgridV.^2 xgridV.^3];
        case 4
            xM = [ones(n,1) xV xV.^2 xV.^3 xV.^4];
            xgridM = [ones(nresol,1) xgridV xgridV.^2 xgridV.^3 xgridV.^4];
    end
    [bV, bint,r,rint,stats] = regress(yV,xM);
    yhatV = xM * bV;
    ygridV = xgridM * bV;
    se2 = (1/(n-(k+1)))*(sum((yV-yhatV).^2));
    se = sqrt(se2);
    my = mean(yV);
    eV = yV-yhatV;
    estarV = eV ./ se;
    R2 = 1-(sum(eV.^2))/(sum((yV-my).^2));
    adjR2 =1-((n-1)/(n-(k+1)))*(sum(eV.^2))/(sum((yV-my).^2));
    
    figure(2*(k-1)+1)
    clf
    % paperfigure
    plot(xV,yV,'k.','Markersize',10)
    hold on
    plot(xgridV,ygridV)
    ax = axis;
    xlabel('ln(R)')
    ylabel('1/T [^oK]')
    text(ax(1)+0.3*(ax(2)-ax(1)),ax(3)+0.2*(ax(4)-ax(3)),['R^2=',...
        num2str(R2,6)])
    text(ax(1)+0.3*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),['adjR^2=',...
        num2str(adjR2,6)])
    title(sprintf('Polynomial degree=%d',k))
    pause;
    
    figure(2*k)
    clf
    % paperfigure
    plot(yV,estarV,'ko')
    hold on
    ax = axis;
    plot([ax(1) ax(2)],zcrit*[1 1], 'c--')
    plot([ax(1) ax(2)],-zcrit*[1 1], 'c--')
    xlabel('1/T')
    ylabel('e^*')
    title(sprintf('Polynomial degree=%d',k))
    pause;
    
    fprintf('=== Polynomial degree=%d \n \t coefficients: \n',k);
    for i=1:k+1
        fprintf('b_%d = %1.10f \n',i-1,bV(i));
    end
    pause;
end

% Steinhart-Hart's model
xM = [ones(n,1) xV xV.^3];
xgridM = [ones(nresol,1) xgridV xgridV.^3];

[bV, bint,r,rint,stats] = regress(yV,xM);
yhatV = xM * bV;
ygridV = xgridM * bV;
se2 = (1/(n-(k+1)))*(sum((yV-yhatV).^2));
se = sqrt(se2);
my = mean(yV);
eV = yV-yhatV;
estarV = eV ./ se;
R2 = 1-(sum(eV.^2))/(sum((yV-my).^2));
adjR2 =1-((n-1)/(n-(k+1)))*(sum(eV.^2))/(sum((yV-my).^2));

figure(2*k+1)
clf
% paperfigure
plot(xV,yV,'k.','Markersize',10)
hold on
plot(xgridV,ygridV)
ax = axis;
xlabel('ln(R)')
ylabel('1/T [^oK]')
text(ax(1)+0.3*(ax(2)-ax(1)),ax(3)+0.2*(ax(4)-ax(3)),['R^2=',...
    num2str(R2,6)])
text(ax(1)+0.3*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),['adjR^2=',...
    num2str(adjR2,6)])
title('Steinhart-Hart model')
pause;

figure(2*(k+1))
clf
% paperfigure
plot(yV,estarV,'ko')
hold on
ax = axis;
plot([ax(1) ax(2)],zcrit*[1 1], 'c--')
plot([ax(1) ax(2)],-zcrit*[1 1], 'c--')
xlabel('1/T')
ylabel('e^*')
title('Steinhart-Hart model')
pause;

fprintf('=== Steinhart-Hart model \n \t coefficients: \n');
fprintf('b_0 = %1.10f \n',bV(1));
fprintf('b_1 = %1.10f \n',bV(2));
fprintf('b_3 = %1.10f \n',bV(3));

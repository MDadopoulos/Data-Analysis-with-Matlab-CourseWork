% Exercise 5.6 
xM = [
2 98.2
3 91.7
8 81.3
16 64.0
32 36.4
48 32.6
64 17.1
80 11.3];
alpha = 0.05;
n = size(xM,1);
xV = xM(:,1);
yV = xM(:,2);
x0 = 25;

% Scatter plot of the raw data
figure(1)
clf
plot(xV,yV,'.')
xlabel('km driven (in thousands)')
ylabel('percentage usable')

% Linear regression line on the raw data
xregM = [ones(n,1) xV];
[bV, bint,r,rint,stats] = regress(yV,xregM);
yhatV = xregM * bV;
my = mean(yV);
eV = yV-yhatV;
R2 = 1-(sum(eV.^2))/(sum((yV-my).^2));
adjR2 =1-((n-1)/(n-2))*(sum(eV.^2))/(sum((yV-my).^2));
pause;

figure(1)
hold on
plot(xV,yhatV,'r')
ax = axis;
text(ax(1)+0.3*(ax(2)-ax(1)),ax(3)+0.2*(ax(4)-ax(3)),['R^2=',...
    num2str(R2,3)])
text(ax(1)+0.3*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),['adjR^2=',...
    num2str(adjR2,3)])
pause;

% Diagnostic plot: residuals vs response (dependent variable)
se2 = (1/(n-1))*(sum((yV-yhatV).^2));
se = sqrt(se2);
estarV = eV ./ se;
zcrit = norminv(1-alpha/2);
figure(2)
clf
plot(yV,estarV,'.')
hold on
ax = axis;
plot([ax(1) ax(2)],zcrit*[1 1],'c--')
plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
xlabel('percentage usable')
ylabel('residuals of linear regression')
pause;

% Ln-transform of the response and then linear regression 
ylnV = log(yV);
[blnV, blnint,r,rint,stats] = regress(ylnV,xregM);
ylnhatV = xregM * blnV;
myln = mean(ylnV);
elnV = ylnV-ylnhatV;
R2ln = 1-(sum(elnV.^2))/(sum((ylnV-myln).^2));
adjR2ln =1-((n-1)/(n-2))*(sum(elnV.^2))/(sum((ylnV-myln).^2));

% Scatter plot of the ln of response vs independent variable
figure(3)
clf
plot(xV,ylnV,'.')
xlabel('km driven (in thousands)')
ylabel('ln of percentage usable')
hold on
pause;
plot(xV,ylnhatV,'r')
ax = axis;
text(ax(1)+0.3*(ax(2)-ax(1)),ax(3)+0.2*(ax(4)-ax(3)),['R^2(ln(y))=',...
    num2str(R2ln,3)])
text(ax(1)+0.3*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),['adjR^2(ln(y))=',...
    num2str(adjR2ln,3)])
if blnV(2)<0
    modtxt = sprintf('ln(y) = %2.2f - %2.2f x',blnV(1),abs(blnV(2))); 
else
    modtxt = sprintf('ln(y) = %2.2f + %2.2f x',blnV(1),abs(blnV(2))); 
end
ax = axis;
text(ax(2)-0.05*(ax(2)-ax(1)),ax(4)-0.15*(ax(4)-ax(3)),modtxt,...
    'Horizontalalignment','Right')
pause;

% Diagnostic plot: residuals vs ln of response
elnV = ylnV-ylnhatV;
vareln = ((n-1)/(n-2))*(var(ylnV)-blnV(2)^2*var(xV));
sdeln = sqrt(vareln);
elnstarV = elnV ./ sdeln;
figure(4)
clf
plot(ylnV,elnstarV,'.')
hold on
ax = axis;
plot([ax(1) ax(2)],zcrit*[1 1],'c--')
plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
xlabel('ln of percentage usable')
ylabel('residuals of linear (ln) regression')
pause;

% The exponential fit on the raw data
bexp0 = exp(blnV(1));
xgridV = linspace(min(xV),max(xV),1000);
yexpgridV = bexp0*exp(blnV(2)*xgridV);
yexphatV = bexp0*exp(blnV(2)*xV);
my = mean(yV);
eexpV = yV-yexphatV;
R2exp = 1-(sum(eexpV.^2))/(sum((yV-my).^2));
adjR2exp =1-((n-1)/(n-2))*(sum(eexpV.^2))/(sum((yV-my).^2));

figure(1)
plot(xgridV,yexpgridV,'r','linewidth',2)
modtxt = sprintf('y = %2.2f e^{%2.2f x}',bexp0,blnV(2)); 
ax = axis;
text(ax(2)-0.05*(ax(2)-ax(1)),ax(4)-0.15*(ax(4)-ax(3)),modtxt,...
    'Horizontalalignment','Right')
pause;
y0 = bexp0*exp(blnV(2)*x0);
plot(x0*[1 1],[ax(3) y0],'b--')
plot([ax(1) x0],y0*[1 1],'b--')
text(ax(1)+0.4*(ax(2)-ax(1)),ax(3)+0.6*(ax(4)-ax(3)),['R^2(exp(y))=',...
    num2str(R2exp,3)])
text(ax(1)+0.4*(ax(2)-ax(1)),ax(3)+0.5*(ax(4)-ax(3)),['adjR^2(exp(y))=',...
    num2str(adjR2exp,3)])

% Exercise 2 of Chp.2 
% Generation of data from exponential distribution using the inverse from uniform.
n = 1000;
lambda = 1;
bins = 20;

% Generate random numbers from exponential distribution and form bins 
% (as if to draw a histogram)
rV = rand(n,1);
yV = -(1/lambda)*log(1-rV);
[Ny,Xy]=hist(yV,bins);  % Xy has the centers of bins, Ny the frequencies

% First (simple) way to plot simulated (from histogram) together with
% analytic expression for the pdf. The y-axis has the scale for relative
% frequency.
ypdfV = lambda*exp(-lambda*Xy);
ypdfV = ypdfV / sum(ypdfV);
figure(1)
clf
plot(Xy,Ny/n,'.-k')
hold on
plot(Xy,ypdfV,'c')
legend('simulated','analytic')
xlabel('x')
ylabel('f_X(x) - relative frequency scale')
title(['Exponential distribution from ',int2str(n),' samples'])

% Second way to plot simulated (from histogram) together with
% analytic expression for the pdf. The y-axis has the proper scale of the pdf!
width = Xy(2)-Xy(1); % width of bin
relfreqV = Ny/n;  % relative frequency
estypdfV = relfreqV/width; % estimated pdf values
fexppdf = @(x) lambda*exp(-lambda*x); % the 'function' of exponential pdf 
figure(2)
clf
plot(Xy,estypdfV,'.-k')
hold on
fplot(fexppdf,[Xy(1)-width/2 Xy(end)+width/2],'c')
legend('simulated','analytic')
xlabel('x')
ylabel('f_X(x) - pdf scale')
title(['Exponential distribution from ',int2str(n),' samples'])

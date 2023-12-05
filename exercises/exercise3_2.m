% Exercise 3.2
% Simulation of the distribution of the mean of the exponential distribution 
M = 1000;
nV = 2.^[2:15]';
tau = 10;

tV = linspace(0,100,10000)';
figure(1)
clf
plot(tV,exppdf(tV,tau))

nn = length(nV);
fprintf('\t n \t average of sample mean \n') 
for i=1:nn
    figure(i+1)
    clf
    n = nV(i);
    mxV = simmeanexponential(tau,n,M,1);
    fprintf('\t %d \t %2.4f \n',n,mean(mxV))
    pause;
end
% Exercise 3.1: 
% Simulation of the distribution of the mean of Poisson distribution 
M = 1000;
nV = 2.^[2:15]';
lambda = 10;

tV = [0:100]';
figure(1)
clf
stem(tV,poisspdf(tV,lambda))

nn = length(nV);
fprintf('lambda = %2.2f \n',lambda); 
fprintf('\t n \t average of sample mean \n');
for i=1:nn
    figure(i+1)
    n = nV(i);
    mxV = simmeanpoisson(lambda,n,M,1);
    fprintf('\t %d \t %2.4f \n',n,mean(mxV))
    pause;
end
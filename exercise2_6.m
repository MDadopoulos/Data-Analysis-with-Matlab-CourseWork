% Exercise 2.6: Simulation of the central limiti theorem
nvar = 100;
n = 10000;
bins = 100;

yV = mean(rand(nvar,n));
figure(1)
clf
histfit(yV,bins);
xlabel('x')
ylabel('counts')
title(sprintf('%d means of %d uniform variables',n,nvar))

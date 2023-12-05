% Exercise 4.2
% Uncertainty in measuring rectangular areas.
lsigma = 5;  % uncertainty for length
wsigma = lsigma; % uncertainty for width
l = 500;
w = 300;

areasigma = sqrt(w^2*lsigma^2 + l^2*wsigma^2);

lgridV = [1:1000]';
wgridV = sqrt(areasigma^2 - lgridV.^2*wsigma^2)/lsigma;
figure(1)
clf
plot(lgridV,wgridV,'.')

lgridV = [1:50:10001]';
wgridV = [1:50:10001]';
nlgrid = length(lgridV);
areagridM = NaN*ones(nlgrid);
for i=1:nlgrid
    for j=1:nlgrid
        areagridM(j,i) = sqrt(wgridV(j)^2*lsigma^2 + lgridV(i)^2*wsigma^2);
    end
end
figure(2)
clf
surf(lgridV,wgridV,areagridM)


% Exercise 6.3: PCA on 'physical' data, prjection on d<p dimension and PC scores
dattxt = 'physical';

%% Load and show the mean and SD of data at each variable
fid = fopen('physical.txt','r');
tline = fgetl(fid);
varnameC = textscan(tline,'%s');
varnameC = varnameC{1};
p = numel(varnameC);
xM = fscanf(fid,'%f');
n = length(xM)/p;
xM = reshape(xM,p,n)';
fclose(fid);

figure(1)
clf
plot(mean(xM,2))
xlabel('variable index i')
ylabel('sample mean of x_i')
title('Sample mean of physical data')
figure(2)
clf
plot(std(xM'))
xlabel('variable index i')
ylabel('sample SD of x_i')
title('Sample SD of physical data')

%% (a) PCA and estimate of d<p using different techniques
% Center the data.
xM = xM - repmat(sum(xM)/n,n,1);
% Find the covariance matrix.
covxM = cov(xM);
[eigvecM,eigvalM] = eig(covxM);
eigvalV = diag(eigvalM); % Extract the diagonal elements
% Order in descending order
eigvalV = flipud(eigvalV);
eigvecM = eigvecM(:,p:-1:1);
neigval = length(eigvalV);
ieigvalV = (1:p)';
%% 1. Scree plot
% Do a scree plot.
figure(3)
clf
plot(ieigvalV,eigvalV,'ko-')
avgeig = mean(eigvalV);
hold on
plot(xlim,avgeig*[1 1],'b') 
title('Scree Plot')
xlabel('index')
ylabel('eigenvalue')
%% 2. Explained Variance percentage
pervarV = 100*cumsum(eigvalV)/sum(eigvalV);
figure(4)
clf
plot(ieigvalV,pervarV,'o-k')
xlabel('index')
ylabel('variance percentage')
title('Explained Variance percentage')
%% 3. Broken stick test
% First get the expected sizes of the eigenvalues.
gV = zeros(1,p);
for k = 1:p
    for i = k:p
        gV(k) = gV(k) + 1/i;
    end
end
gV = gV/p;
propvarV = eigvalV/sum(eigvalV);
figure(5)
clf
plot(ieigvalV,propvarV,'.-b')
hold on
plot(ieigvalV,gV,'.-r')
xlabel('index')
ylabel('eignevalue proportion')
title('Broken stick test')
%% 4. Size of the variance
avgeig = mean(eigvalV);
ind = find(eigvalV > avgeig);
fprintf('Dimension d using size of the variance: %d \n',length(ind));
%% (b) Projection in 3-D
d = 3;
pM = eigvecM(:,1:d);
zM = xM*pM;
figure(6)
clf
plot3(zM(:,1),zM(:,2),zM(:,3),'*k')
xlabel('PC 1')
ylabel('PC 2')
zlabel('PC 3')
title('PCA, d=3')
% Projection in 2-D
pM = eigvecM(:,1:2);
zM = xM*pM;
figure(7)
clf
plot(zM(:,1),zM(:,2),'*k')
xlabel('PC 1')
ylabel('PC 2')
title('PCA, d=2')
figure(8)
clf
plot(pM(:,1),'.-')
hold on
plot(pM(:,2),'.-r')
legend('PC1','PC2','Location','Best')
% xlabel('natural base index')
ylabel('PeC component')
title('PC rotation components')
set(gca,'Box','On')
set(gca,'XTick',[1:p])
set(gca,'XTickLabel',[])
set(gca,'XTickLabel',varnameC)
rotateticklabel(gca,30);





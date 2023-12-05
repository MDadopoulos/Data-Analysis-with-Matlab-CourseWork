% Exercise 6.1 A 2-D set of points in 3-D and PCA on them.
n = 1000;
xM = mvnrnd([0 0]',[1 0; 0 4],n);
wM = [0.2 0.8; 0.4 0.5; 0.7 0.3];
x3M = xM*wM'; % The 2-D data points in 3-D
datadim = size(wM,1);

% Show the points in 2-D
figure(1)
clf
plot(xM(:,1),xM(:,2),'.')
xlabel('x1')
ylabel('x2')
title('2D Gaussian generated points')
% Show the points in 3-D
figure(2)
clf
plot3(x3M(:,1),x3M(:,2),x3M(:,3),'.')
xlabel('y1')
ylabel('y2')
ylabel('y3')
title('3D observed points')

%% (a) PCA using the covariance matrix
yM = x3M - repmat(sum(x3M)/n,n,1);
% Find the covariance matrix.
covxM = cov(yM);
[eigvecM,eigvalM] = eig(covxM);
eigvalV = diag(eigvalM); % Extract the diagonal elements
% Order in descending order
eigvalV = flipud(eigvalV);
eigvecM = eigvecM(:,datadim:-1:1);
ieigvalV = (1:datadim)';
%% (b) Scree plot and rotation in 3-D
% Scree plot
figure(3)
clf
plot(ieigvalV,eigvalV,'ko-')
title('Scree Plot')
xlabel('index')
ylabel('eigenvalue')
title('Scree plot')
% Rotation in 3-D having PCA eigenvectors as new base
z3M = yM * eigvecM;
figure(7)
clf
plot3(z3M(:,1),z3M(:,2),z3M(:,3),'.k')
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')
title('Principal component scores')

%% (c) Projection in 2-D
z2M = yM * eigvecM(:,1:2);
figure(8)
clf
plot(z2M(:,1),z2M(:,2),'.k')
xlabel('PC1')
ylabel('PC2')
title('Principal component scores')



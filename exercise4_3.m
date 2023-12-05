% Exercise 4.3
% Uncertainty in power dissipated in a circuit of alternating current.
M = 1000;
meanv = 77.78;
sigmav = 0.71;
meani = 1.21;
sigmai = 0.071;
meanf = 0.283;
sigmaf = 0.017;
rhovf = 0.5;

%(a)
sigmap = sqrt((meani*cos(meanf))^2*sigmav^2+(meanv*cos(meanf))^2*sigmai^2+...
    (meanv*meani*(-sin(meanf)))^2*sigmaf^2);
%(b)
vV = randn(M,1)*sigmav + meanv;
iV = randn(M,1)*sigmai + meani;
fV = randn(M,1)*sigmaf + meanf;
pV = vV.*iV.*cos(fV);
sdp = std(pV);
fprintf('Expected SD for P=%2.3f   Observed SD for P=%2.3f \n',sigmap,sdp);

%(c)
sigmap2 = sqrt((meani*cos(meanf))^2*sigmav^2+(meanv*cos(meanf))^2*sigmai^2+...
    (meanv*meani*(-sin(meanf)))^2*sigmaf^2 + 2*(meani*cos(meanf))*...
    (meanv*meani*(-sin(meanf)))*rhovf*sigmav*sigmaf);
meanallV = [meani meanv meanf]';
covvf = rhovf*sigmav*sigmaf;
sigmaallM = [sigmai^2 0 0; 0 sigmav^2 covvf; 0 covvf sigmaf^2];
xM = mvnrnd(meanallV,sigmaallM,M); 
i2V = xM(:,1);
v2V = xM(:,2);
f2V = xM(:,3);
p2V = v2V.*i2V.*cos(f2V);
sdp2 = std(p2V);
fprintf('Expected SD for P=%2.3f   Observed SD for P=%2.3f \n',sigmap2,sdp2);
 

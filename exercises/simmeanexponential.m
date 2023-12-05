function mxV = simmeanexponential(tau,n,M,displayhist,nbin)
% mxV = simmeanexponential(tau,n,M,displayhist,nbin)
% This function simulates the mean of the exponential distribution with 
% parameter 'tau'. A number of samples 'M' of size 'n' are generated 
% from this exponential distribution and the histogram of the sample means
% is plotted if 'displayhist==1' using the given 'nbin'. 
% The sample means are returned in the array 'mxV'.
% INPUT
% - tau         : parameter of the exponential distribution
% - n           : sample size
% - M           : number of samples
% - displayhist : if 1 display hist (default), otherwise don't
% - nbin        : number of bins for histogram (default sqrt(M/5))
% OUTPUT
% - mxV         : Mx1 array of sample means 

if nargin==4
    nbin=round(sqrt(M/5));
elseif nargin==3
    nbin=round(sqrt(M/5));
    displayhist=1;
end

xM = exprnd(tau,n,M);
mxV = mean(xM);
if displayhist
    figure(gcf)
    clf
    histfit(mxV,nbin)
    xlabel('sample mean')
    ylabel('counts')
    title(sprintf('mean of %d exponential(tau=%2.2f) samples of size %d',...
        M,tau,n))
end

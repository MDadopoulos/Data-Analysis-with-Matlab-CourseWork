%Michail Dadopoulos
%Dimos Kompitselidis


function [cip,cib,pp,pb,n] = Group55Exe4Fun1(x,y)
    %a
    nanx=isnan(x);
    nany=isnan(y);
    nan=~(nanx+nany);
    x=x(nan);
    y=y(nan);
    
    a=0.05;
    n=length(x);
    B=1000;
    %b confidence interval using Fisher transform (tanh) 
    R = corrcoef(x,y);
    r=R(1,2);
    z = 0.5*log((1+r)./(1-r));
    zcrit = norminv(1-a/2);
    zsd = sqrt(1/(n-3));
    zl = z-zcrit*zsd;
    zu = z+zcrit*zsd;
    rl = (exp(2*zl)-1)./(exp(2*zl)+1);
    ru = (exp(2*zu)-1)./(exp(2*zu)+1);
    cip=[rl ru];%ci for correlation coefficient
    %confidence interval from bootstrap for correlation coefficient
    cib=bootci(10000,@corr2,x,y);
    % hypothesis test for H0: rho=0 using the t-statistic
    t = r.*sqrt((n-2)./(1-r.^2));
    pp = 2*(1-tcdf(abs(t),n-2));%p-value
    
    % hypothesis test for H0: rho=0 ,p-value from randomization
    bootr = NaN(B,1);%correlation coefficient
    boott = NaN(B,1);%t statistic for rh0=0 for every sample
    for iB=1:B
        rV = randperm(n+n);
        xy = [x; y];
        xb = xy(rV(1:n));
        yb = xy(rV(n+1:n+n));
        Rb = corrcoef(xb,yb);
        bootr(iB) = Rb(1,2);
        boott(iB) = bootr(iB).*sqrt((n-2)./(1-bootr(iB).^2));
    end
    
    %p-value for correlation coefficient from randomization using t-statistic
    pb=length(boott(find(boott>=abs(t))))/B+length(boott(find(boott<=-abs(t))))/B;
    %pb=length(bootr(find(bootr>=abs(r))))/B+length(bootr(find(bootr<=-abs(r))))/B;
    %using r,is same p =value


end

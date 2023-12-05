%Michail Dadopoulos
%Dimos Kompitselidis


function [adjR2,p] = Group55Exe8Fun1(x,y)
    %a
    nanx=isnan(x);
    nany=isnan(y);
    nan=~(nanx+nany);
    x=x(nan);
    y=y(nan);
    n=length(x);
    %b
    %find coefficients
    k=3;
    b=polyfit(x,y,3);
    %find yhat using linear regression with b coefficients
    yhat = polyval(b, x);   
    my = mean(y);
    e = y-yhat;
    %calculate coefficient of determination
    R2 = 1-(sum(e.^2))/(sum((y-my).^2));
    %calculate adaptive coefficient of determination
    adjR2 =1-((n-1)/(n-(k+1)))*(sum(e.^2))/(sum((y-my).^2));

    %c
    L=1000;
    % p-value from randomization
    bootadjr = NaN(L,1);%t statistic for rh0=0 for every sample
    for iL=1:L
        rV = randperm(n+n);
        xy = [x; y];
        xr = xy(rV(1:n));
        yr = xy(rV(n+1:n+n));
        br=polyfit(xr,yr,3);
        %find yhat using linear regression with b coefficients
        yhatr = polyval(br, xr);   
        myr = mean(yr);
        er = yr-yhatr;
        %calculate adaptive coefficient of determination
        bootadjr(iL) = 1-((n-1)/(n-(3+1)))*(sum(er.^2))/(sum((yr-myr).^2));
    end
    
    %p-value for adaptive coefficient of determination 
    p=length(bootadjr(find(bootadjr>=abs(adjR2))))/L+length(bootadjr(find(bootadjr<=-abs(adjR2))))/L;




end
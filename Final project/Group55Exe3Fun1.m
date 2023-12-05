%Michail Dadopoulos
%Dimos Kompitselidis


function [p1,p2] = Group55Exe3Fun1(years,vec)
    n=length(years);
    B=1000;
    %find discontinuity in years
    i=1;
    while (years(i+1) - years(i)) == 1
        i = i+1;
        if i == length(vec)-1 
            error("There was not find any discontinuity");
        end
    end
    x1=vec(1:i);
    x2=vec(i+1:n);
    x2=x2(~isnan(x2));
    x1=x1(~isnan(x1));
    m=length(x1);
    n=length(x2);
    x1m=mean(x1);
    x1sd=std(x1);
    x2m=mean(x2);
    x2sd=std(x2);
    %find parametric p-value
    dm = x1m - x2m;
    vardxt = (x1sd^2*(m-1)+x2sd^2*(n-1)) / (n+m-2);
    sddxt = sqrt(vardxt);
    tsample = dm / (sddxt * sqrt(1/m+1/(n)));
    p1 = 2*(1-tcdf(abs(tsample),n+m-2)); 
    %find random-permutation test p-value
    %
    randdmx = NaN(B,1);
    randts = NaN(B,1);
    for iB=1:B
        rV = randperm(n+m);
        x12 = [x1; x2];
        x1b = x12(rV(1:m));
        x2b = x12(rV(m+1:n+m));
        randdmx(iB) = mean(x1b)-mean(x2b);
        vardxr = (std(x1b)^2*(m-1)+std(x2b)^2*(n-1)) / (n+m-2);
        sddxr = sqrt(vardxr);
        randts(iB) = randdmx(iB) / (sddxr * sqrt(1/m+1/(n)));
    end
    %2 ways to calculate p with same result
    %p2=length(randdmx(find(randdmx>=abs(dm))))/B+length(randdmx(find(randdmx<=-abs(dm))))/B;
    p2=length(randts(find(randts>=abs(tsample))))/B+length(randts(find(randts<=-abs(tsample))))/B;


end
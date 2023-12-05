T = readtable('Heathrow.xlsx');
data= table2array(T);
[n,m]=size(data);
varnameM = char('T','TM','Tm','PP','V','RA','SN','TS','FG','TN','GR');
%use data without years first column
data=data(:,2:m);
[n,m]=size(data);
pairs=[[3 11]' [5 8]' [5 10]' [3 4]'];
    %set x and y for pairs
    x=data(:,pairs(1,3));
    y=data(:,pairs(2,3));


    
    nanx=isnan(x);
    nany=isnan(y);
    nan=~(nanx+nany);
    x=x(nan);
    y=y(nan);
    n=length(x);

    %b
    %discretize x and y to 0-1 values with median
    xm=median(x);
    ym=median(y);
    x(x<=xm)=0;
    x(x>xm)=1;
    y(y<=ym)=0;
    y(y>ym)=1;
    %calculate pmf for x and for y
    pmfx=[length(find(x==0))/n 1-length(find(x==0))/n];
    pmfy=[length(find(y==0))/n 1-length(find(y==0))/n];
    %common pmf for x,y
    counts = histcounts2(x,y);
    pmfxy = counts/n;%for x=1 y=0 pmfx(2,1)


    %calulate Shannon entropies
    Hx=-sum(pmfx.*log10(pmfx));
    Hy=-sum(pmfy.*log10(pmfy));
    Hxy=-sum(pmfxy*log10(pmfxy),"all");
    
 
    %calculate mutual information
    Ixy=Hx+Hy-Hxy;

    %c
    L=1000;
    %calculate correlation coefficient
    R = corrcoef(x,y);
    r=R(1,2);
    %calculate t-statistic to original sample
    t = r.*sqrt((n-2)./(1-r.^2));
   
    % hypothesis test for H0: rho=0 ,p-value from randomization
    bootr = NaN(L,1);%correlation coefficient
    boott = NaN(L,1);%t statistic for rh0=0 for every sample
    for iL=1:L
        rV = randperm(n+n);
        xy = [x; y];
        xb = xy(rV(1:n));
        yb = xy(rV(n+1:n+n));
        Rb = corrcoef(xb,yb);
        bootr(iL) = Rb(1,2);
        boott(iL) = bootr(iL).*sqrt((n-2)./(1-bootr(iL).^2));
    end
    
    %p-value for correlation coefficient from randomization using t-statistic
    p=length(boott(find(boott>=abs(t))))/L+length(boott(find(boott<=-abs(t))))/L;
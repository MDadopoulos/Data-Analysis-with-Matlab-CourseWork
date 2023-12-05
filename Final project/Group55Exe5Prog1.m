%Michail Dadopoulos
%Dimos Kompitselidis


T = readtable('Heathrow.xlsx');
data= table2array(T);
[n,m]=size(data);
varnameM = char('T','TM','Tm','PP','V','RA','SN','TS','FG','TN','GR');
%use data without years first column
data=data(:,2:m);
[n,m]=size(data);

%selct this pairs
pairs=[[3 11]' [5 8]' [5 10]' [3 4]'];
for i=1:length(pairs)
    %set x and y for pairs
    x=data(:,pairs(1,i));
    y=data(:,pairs(2,i));
    fprintf('Index %s and Index %s \n',varnameM(pairs(1,i),:),varnameM(pairs(2,i),:));
    [Ixy,pr,nc] = Group55Exe5Fun1(x,y);
    %calculate correlation coefficient
    nanx=isnan(x);
    nany=isnan(y);
    nan=~(nanx+nany);
    x=x(nan);
    y=y(nan);
    R = corrcoef(x,y);
    r=R(1,2);
    fprintf("Pearson Correlation coefficient=%3.6f\n",r);
    % p-value  using the t-statistic for hypothesis test for H0: rho=0
    t = r.*sqrt((n-2)./(1-r.^2));
    p = 2*(1-tcdf(abs(t),n-2));%p-value
    fprintf("p-value using t-statistc %3.6f\n",p);
    fprintf("Mutual information=%3.6f\n",Ixy);
    fprintf("p-value from randomization=%3.6f\n",pr);
end


    
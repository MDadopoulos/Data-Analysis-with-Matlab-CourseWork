%Michail Dadopoulos
%Dimos Kompitselidis


T = readtable('Heathrow.xlsx');
data= table2array(T);
varnameM = char('T','TM','Tm','PP','V','RA','SN','TS','FG','TN','GR');
[n,m]=size(data);
ppmin=1;
pdifindex=varnameM(1,:);
bdifindex=varnameM(1,:);
pbmin=1;
pvalues=NaN(2,10);
for i=2:10
    fprintf(' INDEX %s \n',varnameM(i-1,:));
    [pvalues(1,i),pvalues(2,i)] = Group55Exe3Fun1(data(:,1),data(:,i));
    fprintf(' p-value from parametric test p1=%3.6f\n p-value from random-permutation test p2=%3.6f\n',pvalues(1,i),pvalues(2,i));
    if pvalues(1,i) < 0.05 && pvalues(2,i) < 0.05
        fprintf('At Index %s there is difference at means between the 2 periods\n',varnameM(i-1,:));
    end
    if pvalues(1,i) < ppmin
        ppmin=pvalues(1,i);
        pdifindex=varnameM(i-1,:);
    end
    if pvalues(2,i) < pbmin
        pbmin=pvalues(2,i);
        bdifindex=varnameM(i-1,:);
    end
    
end
fprintf('At Index %s there is the biggest difference at means between the 2 periods for parametric p-value\n',pdifindex);
fprintf('At Index %s there is the biggest difference at means between the 2 periods for random permutation test p-value\n',bdifindex);

%For indexes T,TM,V,RA,TS,FG there is difference for the mean for the 2
%periods.Index FG has the biggest difference according to parametric test
%and index PP according to random-permutation test
%Index Tm and SN dont have significant changed mean between the 2 periods
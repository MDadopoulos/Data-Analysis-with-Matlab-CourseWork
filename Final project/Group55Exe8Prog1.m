%Michail Dadopoulos
%Dimos Kompitselidis


T = readtable('Heathrow.xlsx');
data= table2array(T);
%only names that will be the indipendent variables
varnameM = char('T','TM','Tm','PP','V','RA','SN','TS','GR');
% data without years first column and TN index
data=data(:,[2:10 12]);
[n,m]=size(data);
fg=data(:,m-1);
%data without FG index
data=data(:,[1:8 10]);
[n,m]=size(data);

adjR2=NaN(m,1);
p=NaN(m,1);
for i=1:m
    
    [adjR2(i),p(i)]=Group55Exe8Fun1(data(:,i),fg);

end
[~,ip]=sort(adjR2,'descend');
fprintf("Index %s can explain  FG Index with a 3 degree polynomial regression with adjR2=%3.5f and p-value=%3.5f\n",varnameM(ip(1),:),adjR2(ip(1)),p(ip(1)));
fprintf("Index %s can explain  FG Index with a 3 degree polynomial regression with adjR2=%3.5f and p-value=%3.5f\n",varnameM(ip(2),:),adjR2(ip(2)),p(ip(2)));
fprintf("Index %s can explain  FG Index with a 3 degree polynomial regression with adjR2=%3.5f and p-value=%3.5f\n",varnameM(ip(3),:),adjR2(ip(3)),p(ip(3)));


%It seem that indexes RA and T and TM can explain better FG with a 3 degree
%polynomial regression
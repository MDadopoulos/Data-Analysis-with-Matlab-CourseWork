%Michail Dadopoulos
%Dimos Kompitselidis


T = readtable('Heathrow.xlsx');
data= table2array(T);
%all indexes except TN
varnameM = char('T','TM','Tm','PP','V','RA','SN','TS','FG','GR');
%use data without years first column and TN index
data=data(:,[2:10 12]);
[n,m]=size(data);

R2=NaN(m-1,2);%stores temporaly all coefficients of determination for a dependent with every other independent variable 
bestR2=NaN(m,4);%it will keep the  2 highest coefficients of determination for each variable 
for i=1:m
    %indexes of indipendent variables
    ind=[1:i-1 i+1:m];
    figure(i)
    clf
    for j=1:9
        subplot(3,3,j);
        [R2(j,1)] = Group55Exe6Fun1(data(:,ind(j)),data(:,i));
        R2(j,2)=ind(j);
    end
    [~,ip]=sort(R2,1,'descend');
    bestR2(i,1)=R2(ip(1,1),1);
    bestR2(i,2)=R2(ip(1,1),2);
    bestR2(i,3)=R2(ip(2,1),1);
    bestR2(i,4)=R2(ip(2,1),2);
    sgtitle(['Dependent variable:  ' varnameM(i,:) ])
end

bests=bestR2(:,[2 4]);%only the 2 variables that fit best linearly the dependent one
for i=1:m
    fprintf('Index %s :Index %s and Index %s \n',varnameM(i,:),varnameM(bests(i,1),:),varnameM(bests(i,2),:));
end

%T and TM can be explained with a linear model better than all

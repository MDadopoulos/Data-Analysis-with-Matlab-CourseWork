%Michail Dadopoulos
%Dimos Kompitselidis

%T = readtable('C:\Users\mdado\Downloads\Heathrow.xlsx');
T = readtable('Heathrow.xlsx');
data= table2array(T);
varnameM = char('T','TM','Tm','PP','V','RA','SN','TS','FG','TN','GR');
test=data(:,11);
[n,m]=size(data);

pvalues=NaN(m,2);
finalmatrix = NaN(m,2);
for i=2:m
    vec=data(:,i);
    vec=vec(~isnan(vec));
    n = length(unique(vec));
    if n>10
        finalmatrix(i,1)=1; %"Continuous";
        [pvalues(i,1),pvalues(i,2)]=Group55Exe1Fun1(data(:,i));
        if pvalues(i,1)>=pvalues(i,2)
            finalmatrix(i,2)=1; %"Normal";
        else
            finalmatrix(i,2)=2; %"Uniform";
        end
    else
        finalmatrix(i,1)=2; %"Discrete";
        [pvalues(i,1),pvalues(i,2)]=Group55Exe1Fun1(data(:,i));
        if pvalues(i,1)>=pvalues(i,2)
            finalmatrix(i,2)=1; %"Bionomial";
        else
            finalmatrix(i,2)=2; %"Uniform";
        end
    end
end

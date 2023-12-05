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

for i=1:m
    
    figure(i)
    clf
    model=Group55Exe7Fun1(data(:,i),fg);
    sgtitle(['Models of Independent variable:  ' varnameM(i,:) ])
    switch model
        case 1
            fprintf("Best model for Independent variable %s is 1 degree polynomial regression\n",varnameM(i,:))
        case 2
            fprintf("Best model for Independent variable %s is 2 degree polynomial regression\n",varnameM(i,:))
        case 3
            fprintf("Best model for Independent variable %s is 3 degree polynomial regression\n",varnameM(i,:))
        case 4
            fprintf("Best model for Independent variable %s is transfrom y'=log(y) of intrinsically linear exponential y=a*e^(b*x) function\n",varnameM(i,:))
        case 5
            fprintf("Best model for Independent variable %s is transfrom y'=log(y),x=log(x) of intrinsically linear power y=a*x^b function\n" ,varnameM(i,:))
        case 6
            fprintf("Best model for Independent variable %s is transfrom x'=log(x) of intrinsically linear y=a+b*log(x) function\n",varnameM(i,:))
    end
    
end


%It seem that indexes RA and T can explain better FG with a 3 degree
%polynomial regression

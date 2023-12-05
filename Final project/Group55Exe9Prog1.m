%Michail Dadopoulos
%Dimos Kompitselidis


T = readtable('Heathrow.xlsx');
data= table2array(T);
%only names that will be the indipendent variables
option=2; %if 1 we want fg if 2 we want GR
switch option
        case 1
            fprintf("FG Dependent variable\n")
            varnameM = char('T','TM','Tm','PP','V','RA','SN','TS','FG','TN','GR');
            y=data(:,10);
            % data without years first column and FG  index
            data=data(:,[2:9 11 12]);
        case 2
            fprintf("GR Dependent variable\n")
            varnameM = char('T','TM','Tm','PP','V','RA','SN','TS','FG','TN','GR');
            y=data(:,12);
            % data without years first column and GR  index
            data=data(:,2:11);

end


%a
x=data;
nanx=isnan(x);
nany=isnan(y);
nanxy=nany+sum(nanx,2);
nanxy=~nanxy;
x=x(nanxy,:);
y=y(nanxy);
[n,m]=size(x);
xreg=[ones(n,1) x];
[b,bint] = regress(y,xreg,0.05);
fprintf("Model of Multiple linear regression\n");
yhat=xreg*b;
%errors variance
se2 = (1/(n-(m+1)))*(sum((y-yhat).^2));
my = mean(y);
e = y-yhat;
%calculate coefficient of determination
R2 = 1-(sum(e.^2))/(sum((y-my).^2));
%calculate adaptive coefficient of determination
adjR2 =1-((n-1)/(n-(m+1)))*(sum(e.^2))/(sum((y-my).^2));
fprintf("R2=%3.5f ,error variance =%3.5f and adapative coefficient of determination adjR2=%3.5f \n",R2,se2,adjR2);

for i=1:m
    if bint(i+1,1)>0 || bint(i+1,2)<0
        fprintf("For Index %s its coefficient is statistically important for multiple linear regression model\n",varnameM(i,:));
    end
end

[bs,~,~,inmodel,stats]=stepwisefit(x,y,'Display',"off");
b0s = stats.intercept;
indx = find(inmodel==1);
yhats = xreg * ([b0s;bs].*[1 inmodel]');
es = y-yhats;
ks = sum(inmodel);
%errors variance
se2s = (1/(n-(ks+1)))*(sum(es.^2));
ses = sqrt(se2s);
%calculate coefficient of determination
R2s = 1-(sum(es.^2))/(sum((y-my).^2));
%calculate adaptive coefficient of determination
adjR2s =1-((n-1)/(n-(ks+1)))*(sum(es.^2))/(sum((y-my).^2));
fprintf("Model  stepwise regression\n");
fprintf("R2=%3.5f ,error variance =%3.5f and adapative coefficient of determination adjR2=%3.5f \n",R2s,se2s,adjR2s);

for i=1:ks
    fprintf("For Index %s its coefficient is statistically important for multiple linear regression model\n",varnameM(indx(i),:));
end
%PLS
[~,~,~,~,bPLS] = plsregress(x,y,4);
yfitPLS = [ones(n,1) x]*bPLS;
resPLS = yfitPLS - y;     
%errors variance
se2PLS  = (1/(n-(2+1)))*(sum(resPLS.^2));
sePLS  = sqrt(se2PLS);
%calculate coefficient of determination
R2PLS  = 1-(sum(resPLS.^2))/(sum((y-my).^2));
%calculate adaptive coefficient of determination
adjR2PLS  =1-((n-1)/(n-(2+1)))*(sum(resPLS.^2))/(sum((y-my).^2));
fprintf("PLS  regression to 4 dimensions\n");
fprintf("R2=%3.5f ,error variance =%3.5f and adapative coefficient of determination adjR2=%3.5f \n",R2PLS,se2PLS,adjR2PLS);


%We can explain FG well with TM and PP indexes,the models of multiple linear
%regression and stepwise regression agree on that.With PLS to dimension
%reduction to 4 we have better adaptive coefficient of determination
%We can explain FG well with TM and TS indexes,the models of multiple linear
%regression and stepwise regression agree on that TS but only stepwise present TM.With PLS to dimension
%reduction to 4 we have good adaptive coefficient of determination close to
%the others
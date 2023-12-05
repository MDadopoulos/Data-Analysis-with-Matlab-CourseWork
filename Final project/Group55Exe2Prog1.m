%Michail Dadopoulos
%Dimos Kompitselidis


T = readtable('Heathrow.xlsx');
data= table2array(T);
varnameM = char('T','TM','Tm','PP','V','RA','SN','TS','FG','TN','GR');
[n,m]=size(data);
indexbefore=find(data(:,1)<=1958);
indexafter=setdiff((1:n)',indexbefore);
for i=2:10
    fprintf(' INDEX %s \n',varnameM(i-1,:));
    m=mean(data(indexbefore,i));
    fprintf('Mean during 1949-1958 is %f \n',m);
    [cip,cib] = Group55Exe2Fun1(data(indexafter,i));
    fprintf('Parametric CI for mean of period 1973-2017 [%2.3f,%2.3f] \n',cip(1),cip(2));
    if m>=cip(1) && m<= cip(2)
        fprintf('Mean of Index %s during 1949-1958 is in parametric CI of period 1973-2017\n',varnameM(i-1,:))
    else
        fprintf('Mean of Index %s during 1949-1958 is not in parametric CI of period 1973-2017\n',varnameM(i-1,:))
    end
    fprintf('Bootstrap CI for mean of period 1973-2017 [%2.3f,%2.3f] \n',cib(1),cib(2));
    if m>=cib(1) && m<= cib(2)
        fprintf('Mean of Index %s during 1949-1958 is in bootstrap CI of period 1973-2017\n',varnameM(i-1,:))
    else
        fprintf('Mean of Index %s during 1949-1958 is not in bootstrap CI of period 1973-2017\n',varnameM(i-1,:))
    end
    pause()
end
%mean has changed during period 1973-2017 to T,TM,V,RA,TS,FG
%mean Tm,SN hasnt changed
%both test agrees
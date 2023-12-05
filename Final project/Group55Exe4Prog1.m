%Michail Dadopoulos
%Dimos Kompitselidis


T = readtable('Heathrow.xlsx');
data= table2array(T);
varnameM = char('T','TM','Tm','PP','V','RA','SN','TS','FG','TN','GR');
[n,m]=size(data);
%use data without years first column
data=data(:,2:m);




% %list that found to have linear correlation for each method(ci and
% %p-values)
listcip=[];
listcib=[];
listpp=[];
listpr=[];
for i=1:9
   for j=(i+1):9
       [cip,cib,pp,pr,n] = Group55Exe4Fun1(data(:,i),data(:,j));
       if cip(1)>0 || cip(2)<0
           listcip=[listcip [i j]'];
       end
       if cib(1)>0 || cib(2)<0
           listcib=[listcib [i j]'];
       end
       if pp<0.05
           listpp=[listpp [i j pp]'];
       end
       if pr<0.05
           listpr=[listpr [i j pr]'];
       end
   end
end

fprintf('Indexes pairs with linear correlation  from ci parametric test\n');
for q=1:length(listcip(1,:))
     fprintf('Index %s and Index %s \n',varnameM(listcip(1,q),:),varnameM(listcip(2,q),:));
end

fprintf('Indexes pairs with linear correlation  from ci bootstrap test\n');
for q=1:length(listcib(1,:))
     fprintf('Index %s and Index %s \n',varnameM(listcib(1,q),:),varnameM(listcib(2,q),:));
end

fprintf('Indexes pairs with linear correlation  from p-value parametric test\n');
for q=1:length(listpp(1,:))
     fprintf('Index %s and Index %s \n',varnameM(listpp(1,q),:),varnameM(listpp(2,q),:));
end

fprintf('Indexes pairs with linear correlation  from p-value randomization test\n');
for q=1:length(listpr(1,:))
     fprintf('Index %s and Index %s \n',varnameM(listpr(1,q),:),varnameM(listpr(2,q),:));
end

%sort the rows to find higher p-values and use indexes from pre sorted
%array to find correct indexes
[~,ipp]=sort(listpp,2,'descend');
fprintf('3 Indexes pairs with higher correlation by descending order from parametric test\n');
for i=1:3
    fprintf('Index %s and Index %s \n',varnameM(listpp(1,ipp(3,i)),:),varnameM(listpp(2,ipp(3,i)),:));
end


%sort the rows to find higher p-values and use indexes from pre sorted
%array to find correct indexes
[~,ipb]=sort(listpr,2,'descend');
fprintf('3 Indexes pairs with higher correlation by descending order from randomization test\n');
for i=1:3
    fprintf('Index %s and Index %s \n',varnameM(listpr(1,ipb(3,i)),:),varnameM(listpr(2,ipb(3,i)),:));
end

%Parametric and randomization calculation of p-values agree for every pair
%with linear correlation and for the higher p-values and also they agree
%with parametric and bootstrap test for linear correlation



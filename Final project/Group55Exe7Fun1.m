%Michail Dadopoulos
%Dimos Kompitselidis


function model = Group55Exe7Fun1(x,y)
    %a
    nanx=isnan(x);
    nany=isnan(y);
    nan=~(nanx+nany);
    x=x(nan);
    y=y(nan);
    n=length(x);
    %b
    R2=NaN(6);
    for i=1:3
        %find coefficients
        b=polyfit(x,y,i);
        %find yhat using linear regression with b coefficients
        yhat = polyval(b, x);
        %Evaluate the polynomial on a finer grid and plot the results
        xl=linspace(min(x),max(x));
        yl = polyval(b, xl);
       

        my = mean(y);
        e = y-yhat;
        %calculate coefficient of determination
        R2(i) = 1-(sum(e.^2))/(sum((y-my).^2));
        %scatter diagram and fitted line
        subplot(2,3,i)
        plot(x, y, '.',xl,yl,'r')
        title(['R^2 = ' num2str(R2(i))])
    end

    % y'=log(y) -transform  and then linear regression 
    yln = log(y);
    b=polyfit(x,yln,1);
    ylnhat = polyval(b, x);

    myln = mean(yln);
    eln = yln-ylnhat;
    %calculate coefficient of determination
    R2(4) = 1-(sum(eln.^2))/(sum((yln-myln).^2));
    subplot(2,3,4)
    %Evaluate the non-linear on a finer grid and plot the results
    xl=linspace(min(x),max(x));
    yl = polyval(b, xl);
    %scatter diagram and fitted line
    plot(x, y, '.',xl,exp(yl),'r')
    title(['R^2 = ' num2str(R2(4))])


    % x'=log(x),y'=log(y) transform  and then linear regression 
    yln=log(y);
    xln=log(x);
    b=polyfit(xln,yln,1);
    ylnhat = polyval(b, xln);

    myln = mean(yln);
    eln = yln-ylnhat;
    %calculate coefficient of determination
    R2(5) = 1-(sum(eln.^2))/(sum((yln-myln).^2));
    subplot(2,3,5)
    %Evaluate the non-linear on a finer grid and plot the results
    xl=linspace(min(x),max(x));
    yl = polyval(b, log(xl));
    %scatter diagram and fitted line
    plot(x, y, '.',xl,exp(yl),'r')
    title(['R^2 = ' num2str(R2(5))])



    % x'=log(x) transform  and then linear regression 
    xln=log(x);
    b=polyfit(xln,y,1);
    yhat = polyval(b, xln);

    my = mean(y);
    e = y-yhat;
    %calculate coefficient of determination
    R2(6) = 1-(sum(e.^2))/(sum((y-my).^2));
    subplot(2,3,6)
    %Evaluate the non-linear on a finer grid and plot the results
    xl=linspace(min(x),max(x));
    yl = polyval(b, log(xl));
    %scatter diagram and fitted line
    plot(x, y, '.',xl,yl,'r')
    title(['R^2 = ' num2str(R2(6))])



    %return best model id
    model=find(R2==max(R2));


end
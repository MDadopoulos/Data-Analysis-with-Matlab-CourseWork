%Michail Dadopoulos
%Dimos Kompitselidis


function [R2] = Group55Exe6Fun1(x,y)
    %a
    nanx=isnan(x);
    nany=isnan(y);
    nan=~(nanx+nany);
    x=x(nan);
    y=y(nan);
   
    
    %b
    %find coefficients
    b=polyfit(x,y,1);
    %find y using linear regression with b coefficients
    yhat = polyval(b, x);
    my = mean(y);
    e = y-yhat;
    %calculate coefficient of determination
    R2 = 1-(sum(e.^2))/(sum((y-my).^2));
    %scatter diagram and fitted line
    plot(x, y, '.', x, yhat, 'r', 'LineWidth', 2)
    title(['R^2 = ' num2str(R2)])

end
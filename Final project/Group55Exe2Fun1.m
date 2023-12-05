%Michail Dadopoulos
%Dimos Kompitselidis


function [cip,cib] = Group55Exe2Fun1(vec)
    vec=vec(~isnan(vec));
    B=1000;
    [~,~,cip]=ttest(vec);
    cib = bootci(B,@mean,vec);
end
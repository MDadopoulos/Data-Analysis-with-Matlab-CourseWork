% Exercise 4.1
% Uncertainty in the coefficient of restitution and propagation of error
% of the height after bouncing to the error of the coefficient of
% restitution.
h1V = [80 100 90 120 95]'; % height of free fall
h2V = [48 60 50 75 56]'; % heights after bouncing
e0 = 0.76; % expected coefficient of restitution
alpha = 0.05;

n = length(h1V);
eV = sqrt(h2V ./ h1V);
h1sd = std(h1V);
h1mean = mean(h1V);
h2sd = std(h2V);
h2mean = mean(h2V);
esd = std(eV);
emean = mean(eV);

esigma = sqrt((-0.5*sqrt(h2mean)*h1mean^(-3/2))^2*h1sd^2 + ...
    (0.5*sqrt(1/h1mean)*sqrt(1/h2mean))^2*h2sd^2);
fprintf('---- 4.1 (c) ----- \n');
fprintf('SD of COR computed from transformed data: %2.5f \n',esd);
fprintf('SD of COR computed from transformed SD: %2.5f \n',esigma);

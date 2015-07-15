function [out1] = invers5(x_0)
% Generiert Zufallszahlen nach der inversen Transformationsmethode die der
% alternativen Einhuellenden entsprechen.
% x_0: Parameter der die Bereiche abgrenzt

r = rand(1);
    
if r>=0 && r<1/4
    zeta = rand(1);
    out1 = -x_0/zeta;
end

if r>=1/4 && r<3/4
    zeta = rand(1);
    out1 = 2*x_0*zeta-x_0;
end

if r>=3/4 && r<=1
    zeta = rand(1);
    out1 = x_0/(1-zeta);
end
function [zufallsvar,a_sim,a_theor,c] = reject(g,s)
% Generiert Zufallszahlen nach der Rejectionmethode die rho(x) entsprechen.
% Verwendung: reject(g,s)
% g entspricht der Anzahl der gewuenschten Zufallsvariablen.
% s Wert für den Parameter s der Funktion h(x)

clc;
z = (pi*(1-exp(-2)))/2;
c = pi/z;
%c = 3.5;

i = 1;
zufallsvar = zeros(1,g);
ges = 0;

while i<=g
    x_t = invers(1,s);
    r = rand(1);

    if r*c*h(x_t,s) < rho(x_t)
        zufallsvar(1,i) = x_t;
        i = i+1;
    end

    ges = ges+1;

end

a_sim = g/ges;
a_theor = 1/c;
end
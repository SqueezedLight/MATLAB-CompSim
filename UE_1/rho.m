function [out1] = rho(x)
% Verwendung: rho(x)
% Funktion zum generieren der Funktionswerte rho(x) - normierte Wahrscheinlichkeitsverteilung.

z = (pi.*(1-exp(-2)))./2;
out1 = (sin(x).^2)./(z*(1+x.^2));
end
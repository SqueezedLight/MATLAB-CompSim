function [out1] = h(x,s)
% Verwendung: h(x,s)
% Funktion zum generieren der Funktionswerte h(x) - Cauchy-Verteilung.

out1 = s./(pi.*(s^2+x.^2));

end
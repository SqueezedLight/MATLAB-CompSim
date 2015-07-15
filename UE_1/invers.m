function [zufallsvar] = invers(g,s)
% Generiert Zufallszahlen nach der inversen Transformationsmethode die h(x)
% entsprechen.
% Verwendung: invers(g,s)
% g entspricht der Anzahl der gewuenschten Zufallsvariablen.
% s ist der Wert des Parameters s in der Funktion.

clc;

zeta = rand(1,g);
zufallsvar = s*tan(pi*(zeta-1/2));

end
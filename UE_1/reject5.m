function [zufallsvar,a_sim,a_theor,c,x_0] = reject5(g)
% Generiert Zufallszahlen nach der Rejectionmethode (mithilfe der 
% alternativen Einhuellenden)die rho(x) entsprechen.
% Verwendung: reject5(g)
% g entspricht der Anzahl der gewuenschten Zufallsvariablen.

clc;
%z = (pi*(1-exp(-2)))/2;
%c = pi/z;
c = 1.8;
x_0 = 1.7;

i = 1;
zufallsvar = zeros(1,g);
ges = 0;

    while i<=g
        x_t = invers5(x_0);
        r = rand(1);
        
        if x_t <= x_0 && x_t>=-x_0
            if r*c*(1/(4*x_0)) < rho(x_t)
                zufallsvar(1,i) = x_t;
                i = i+1;
            end
        
        
        else
        
           if r*c*(x_0/(4*x_t^2)) < rho(x_t)
                zufallsvar(1,i) = x_t;
                i = i+1;
            end
        end
        
        ges = ges+1;
    
    end
    
    a_sim = g/ges;
    a_theor = 1/c;
end
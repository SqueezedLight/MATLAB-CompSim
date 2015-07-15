function [deltaE,deltaM,S] = MetropolisSingleSpinFlip(S,ii,beta,neighbor,gpkt)

%% Energieunterschied zwischen S_vorher und S_nachher berechnen
deltaE = 2*S(gpkt(ii))*sum(S(neighbor(gpkt(ii),:)));
    
%% Metropolis-Akzeptanz-Entscheidung
p_accept = min(1,exp(-beta*deltaE));  
r_accept = rand(1);

%% Spin wir mit der verlangten Wahrscheinlichkeitsverteilung geflipt
if (r_accept <= p_accept) && (p_accept > 0)
    S(gpkt(ii)) = (-1)*S(gpkt(ii));
    deltaM = 2*S(gpkt(ii));
else
    deltaE = 0;
    deltaM = 0;
end
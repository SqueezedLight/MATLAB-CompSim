function [seq,E] = metropolis(deltaE,T,a,b,seq,E)

r = rand(1); %Zufallszahl generieren um mit p_accept zu vergleichen
p_accept = min(1,exp(-deltaE/T)); %Akzeptanzwahrscheinlichkeit berechnen

if r < p_accept && p_accept > 0
   seq = [seq(1:a-1),fliplr(seq(a:b)),seq(b+1:end)]; %Sequenz flippen
   %seq(a:b) = seq(b:-1:a);
   E = E + deltaE; %neue Energie zuweisen
end  
       
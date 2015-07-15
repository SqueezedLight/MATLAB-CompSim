clear all;
clc;

g = 100000;
s = 1;
delta = 0.05;
bin = -10*s:delta:10*s;

[x,a_sim,a_theor,c] = reject(g,s);
n = histc(x,bin);

Normi = 1/(delta*g);

bar(bin+delta/2,Normi.*n);
hold on;
plot(bin,rho(bin),'-r');
plot(bin,c*h(bin,s),'-g');
xlim([-10*s 10*s]);
xlabel('x');
ylabel('rho(x)');
legend('Dichtefunktion der Zufallszahlen','rho(x) exakt','Einhüllende h(x) fuer s=1');
title(['Theoretische Akzeptanzrate: ',num2str(a_theor),'         Akzeptanzrate aus Simulation: ',num2str(a_sim)]);
hold off;

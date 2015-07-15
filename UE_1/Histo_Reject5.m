clear all;
clc;

g = 100000;
s = 1;
delta = 0.1;
bin = -10*s:delta:10*s;

[x,a_sim,a_theor,c,x_0] = reject5(g);
n = histc(x,bin);

Normi = 1/(delta*g);

bar(bin+delta/2,Normi.*n);
hold on;
plot(bin,rho(bin),'-r');
plot(bin,c.*einh(bin,x_0),'-g');
ylim([0 0.3]);
xlim([-10*s 10*s]);
xlabel('x');
ylabel('rho(x)');
legend('Dichtefunktion der Zufallszahlen','Theoretische Dichtefunktion rho(x)','Alternative Einhuellende');
title(['Theoretische Akzeptanzrate: ',num2str(a_theor),'         Akzeptanzrate aus Simulation: ',num2str(a_sim)]);
hold off;

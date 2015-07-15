clear all;
clc;

g = 100000;
s = 1;
delta = 0.3;
bin = -10*s:delta:10*s;

x = invers(g,s);
n = histc(x,bin);

Normi = 1/(delta*g);

bar(bin+delta/2,Normi.*n);
hold on;
plot(bin,h(bin,s),'-r');
xlim([-10*s 10*s]);
xlabel('x');
ylabel('h(x)');
legend('Dichtefunktion der Zufallszahlen','h(x) exakt');
hold off;

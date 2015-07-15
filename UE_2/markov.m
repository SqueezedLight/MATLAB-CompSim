clc;
clear all;

int = [-10 10];
d = 0.3;
steps = linspace(int(1),int(2),200);
bin = int(1):d:int(2);

zeta = 6;
N = 100000;
%delta = 6; %fuer zeta=0
%delta = 11; %fuer zeta=2
%delta = 27; %fuer zeta=6
delta = 30;
t_max = 100;

x = zeros(1,N);

p_accept = zeros(1,N-1);
reject = 0;

for i=1:N-1
    
    if i==1
       %x(i) = 100*randn(1);
       x(i) = 0;
    else
       x(i) = x(i-1);
    end
    
       r = rand(1);
       x(i+1) = x(i) + (r - 0.5)*delta;
       
       p_accept(i) = min(1,pi_v(x(i+1),zeta)/pi_v(x(i),zeta));

       r1 = rand(1);
       
       if r1 <= p_accept(i) && p_accept(i) > 0
           x(i) = x(i+1);
       else
           reject = reject + 1;
       end         
end

% Verhaeltnis accept/reject
p_accept = reject/(N-1)
%p_accept = (N-1)/reject
% Thermalisieren
x = x(ceil(N/10):end);

% Mittelwert und Varianz der Stichprobe
mw = mean(x)
var_s = var(x)

n = histc(x,bin);
Normi = 1/(d*numel(x));

bar(bin+d/2,Normi.*n);
hold on;
plot(steps,pi_v(steps,zeta),'-r');
xlim(int);
xlabel('x');
ylabel('pi(x)');
legend('Dichtefunktion der Zufallszahlen','pi(x) exakt');
hold off;

figure;
plot(x)
xlim([0 numel(x)]);
xlabel('t');
ylabel('x(t)');

rho = autocorr(x,t_max);

% Autokorrelationssfunktion

% Nx = numel(x);
% 
% fft_x = fft(x(1:(Nx-t_max)));
% fft_x = abs(fft_x).^2;
% cov_x = ifft(fft_x);
% 
% rho = zeros(1,t_max);
% 
% for t = 1:t_max
%     x1 = 1:Nx-t;
%     x2 = t+1:Nx;
%     
%     x_MW = 1/(Nx-t)*sum(x(x1));
%     y_MW = 1/(Nx-t)*sum(x(x2));
%     
%     var_x = sum((x(x1)-x_MW).^2);
%     var_y = sum((x(x2)-y_MW).^2);
%     
%     %rho(t) = cov_x(t)./(sqrt(var_x*var_y));
%     rho(t) = (cov_x(t)-(Nx-t)*x_MW*y_MW)./(sqrt(var_x*var_y));
%      
% end
% 
% figure;
% semilogy(abs(rho),'-b');
% ylim([0 1]);
% xlabel('t');
% ylabel('rho(t)');



clc;
clear all;

L = 4;
N = 10000;
beta = 0.6; %beta_c = 0.44068

therm = 10;
t_max = 1000;
S = ones(L^2,1);
M = sum(S);
E = 0;
Spin_ausgabe = zeros(L);
t_draw = 0:1:t_max;

neighbor = get_neighbor(L);

%% Energie der Anfangsspinkonfiguration berechnen
for k = 1:L^2
    E = E - S(k)*sum(S(neighbor(k,:)));
end
E = E/2;

E_vector = zeros(N,1);
M_vector = zeros(N,1);

%% N+(wegen Thermalisierung) Gitterkonfigurationen erzeugen
for i=1:N+ceil(N/therm)
    [S,E,M] = sweep(S,beta,neighbor,L,E,M);
    
    %% Energie und Magnetisierung nach jedem Sweep "messen" und pro
    %  Gitterplatz normieren
    E_vector(i) = E/L^2;
    M_vector(i) = M/L^2;
    
    %% Mittelwert und "naive" Varianz auch gleich berechnen
    MW_simuE = mean(E_vector);
    MW_simuM = mean(M_vector);
    var_simuE = var(E_vector);
    var_simuM = var(M_vector);
    
    %% Visualisierung
%     if mod(i,1000)== 0
%         for k = 1:L^2
%             Spin_ausgabe(k) = S(k);
%         end
%         fprintf(['Sweep ',num2str(i)]);
%         flipud(Spin_ausgabe.')
%     end
end

%% Thermalisieren
E_vector = E_vector(ceil(N/therm)+1:end);
M_vector = M_vector(ceil(N/therm)+1:end);

%% Erwartungswert der Energie analytisch berechnet
MW_analytisch = (16*(exp(-8*beta)-exp(8*beta))/(12+2*(exp(8*beta)+exp(-8*beta))))/4;

%% Statistische Analyse

fprintf(['Beta = ',num2str(beta)]);
fprintf(['\n Erwartungswert der Energie aus der Simulation: ',num2str(MW_simuE)]);
fprintf(['\n Erwartungswert der Energie analytisch: ',num2str(MW_analytisch)]);
fprintf(['\n Erwartungswert der Magnetisierung aus der Simulation: ',num2str(MW_simuM)]);
fprintf(['\n "Naive" Standardabweichung der Energie aus der Simulation: ',num2str(sqrt(var_simuE/N))]);
fprintf(['\n "Naive" Standardabweichung der Magnetisierung aus der Simulation: ',num2str(sqrt(var_simuM/N)),'\n'])

%% Autokorrelationsfunktion der Energie
figure(1)
rho_E = autocorr(E_vector,t_max);
semilogy(0:t_max,abs(rho_E),'-b');
xlabel('t');
ylabel('rhoE(t)');
hold on;
title('Autokorrelationsfunktion der Energie');

%% Fit der ACF der Energie 
figure(2)
coeff_E = createFit_new(0:1:t_max,abs(rho_E));
title('Fit der Autokorrelationsfunktion der Energie');
xlabel('t');
ylabel('rhoE(t)');
hold off;

%% Autokorrelationsfunktion der Magnetisierung
figure(3)
rho_M = autocorr(M_vector,t_max);
semilogy(0:t_max,abs(rho_M),'-b');
xlabel('t');
ylabel('rhoM(t)');
hold on;
title('Autokorrelationsfunktion der Magnetisierung');

%% Fit der ACF der Magnetisierung
figure(4)
coeff_M = createFit_new(0:1:t_max,abs(rho_M));
title('Fit der Autokorrelationsfunktion der Magnetisierung');
xlabel('t');
ylabel('rhoM(t)');
hold off;

a = coeffvalues(coeff_E);
b = coeffvalues(coeff_M);

% x = linspace(0,100);
% figure(1)
% hold on;
% semilogy(x,a(1)*exp((1/a(2))*x))
% hold off;


%% Berechnung der Integrierten Autokorrelationszeiten
% tau_intE = -a(1)/a(2);
% tau_intM = -b(1)/b(2);

tau_intE = 1/a;
tau_intM = 1/b;


%% Bestimmung der Varianzen aus tau_int
var_rightE = (var_simuE/N)*2*tau_intE;
var_rightM = (var_simuM/N)*2*tau_intM;


fprintf(['\n Autokorrelationszeit der Energie: ',num2str(tau_intE)]);
fprintf(['\n Standardabweichung der Energie mithilfe der integrierten Autokorrelationszeit: ',num2str(sqrt(var_rightE)),'\n']);

fprintf(['\n Autokorrelationszeit der Magnetisierung: ',num2str(tau_intM)]);
fprintf(['\n Standardabweichung der Magnetisierung mithilfe der integrierten Autokorrelationszeit: ',num2str(sqrt(var_rightM)),'\n']);


figure(5)
plot(1:numel(E_vector),E_vector);
title('Zeitreihe der Energie');

figure(6)
plot(1:numel(M_vector),M_vector);
title('Zeitreihe der Magnetisierung');


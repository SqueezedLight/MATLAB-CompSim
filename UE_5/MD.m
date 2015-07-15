clc;
clear all;

% Parameter definieren, Anfangsbedingungen
N = 36;
g = 9.81;
N_mess = 500;
t_burn_in = 1000;
t_skip = 50;
t_step = t_skip*N_mess + t_burn_in;
t_show = 100;
tau = 0.001;

n = zeros(N,N_mess);
v_abs = zeros(N,N_mess);

mat = 1:N; % Punkte gleichmässig im Topf verteilen
mat = transpose(reshape(mat,sqrt(N),sqrt(N)));

[x,y] = find(mat);

vx_init = -30 + 60.*rand(N,1);  % Anfangsgeschwindigkeiten
vy_init = -30 + 60.*rand(N,1);

xy = [x,y]; % Anfangskoordinaten


for i=1:t_step
    
    r_abs = dist(xy.'); % Abstände zwischen den einzelnen Punkten
    
    [xh1,xh2] = meshgrid(xy(:,1),xy(:,1)); % x-Abstände zwischen den Punkten
    x_abs = xh2 - xh1;
    
    [yh1,yh2] = meshgrid(xy(:,2),xy(:,2)); % y-Abstände zwischen den Punkten
    y_abs = yh2 - yh1;      
    
    f_x = 24.*((2.*x_abs./r_abs.^14) - (x_abs./r_abs.^8)); % x-Kräfte berechnen
    f_x(isnan(f_x)) = 0; % NaN durch Nullen ersetzten
    f_x = sum(f_x,2);
    
    f_y = 24.*((2.*y_abs./r_abs.^14) - (y_abs./r_abs.^8)); % y-Kräfte berechnen
    f_y(isnan(f_y)) = 0; % NaN durch Nullen ersetzen
    f_y = sum(f_y,2);
    f_y = f_y - g;
    
    if i==1
        v_tau = [vx_init,vy_init] + (tau/2).*[f_x,f_y]; % Geschwindigkeit beim ersten Durchlauf
    else
        v_tau = v_tau + tau.*[f_x,f_y]; % Geschwindigkeit berechnen
    end
    
    xy = xy + tau.*v_tau; % Koordinaten aus Geschw.+Zeitschrit neu berechnen
    
    x = xy(:,1);
    y = xy(:,2);
    
    v_x = v_tau(:,1);
    v_y = v_tau(:,2);
    
    % Reflexion an den Wänden
    logicx1 = x>sqrt(N)+1;
    logicx2 = x<0;
    logicy = y<0;
    
    x(logicx1) = sqrt(N)+1 - (x(logicx1) - (sqrt(N)+1));
    x(logicx2) = -x(logicx2);
    v_x(logicx2) = -v_x(logicx2);
    v_x(logicx1) = -v_x(logicx1);
    
    y(logicy) = -y(logicy);
    v_y(logicy) = -v_y(logicy);
    
    xy = [x,y];
    v_tau = [v_x,v_y];
    
    if mod(i,t_skip)==0 && i> t_burn_in % Messungen der Höhenverteilung und der Geschwindigkeitsbeträge
        n(:,i/t_skip) = y;
        v_abs(:,i/t_skip) = sqrt(v_x.^2 + v_y.^2);
    end
   
   if mod(i,t_show)==0 % Regelmässiges plotten der Punkte
        figure(1)
        plot(xy(:,1),xy(:,2),'ob','MarkerFaceColor','b')
        title(['Zeitschritt ',num2str(i), ' von insgesamt ', num2str(t_step)]);
        xlim([0 sqrt(N)+1])
        %ylim([0 sqrt(N)+1])
        pause(0.1)
   end

end

% Plotten der Höhenverteilung
[nbinh, xouth] = hist(n(:),50);
nbinh = nbinh./(N_mess*N);
ffun1 = fittype('rho0 * exp(-x/hs)');
fit_baro = fit(xouth',nbinh',ffun1);

figure(2)
bar(xouth,nbinh)
hold on
plot(fit_baro)
hold off
xlabel('Höhe')
ylabel('Anzahl der Punkte')
legend('Simulation',['Exponentieller-Fit: rho0 = ',num2str(fit_baro.rho0), ', hs = ',num2str(fit_baro.hs), ', k_b*T = ',num2str(g*fit_baro.hs)])

% Bestimmung von mkbT aus der mittleren Geschwindigkeit
mkbT = 2/(mean(v_abs(:).^2));

% Plotten der Geschwindigkeitsverteilung
[nbinv,xoutv] = hist(v_abs(:),50);
nbinv = nbinv./(N_mess*N);
ffun2 = fittype('a * x .* exp(-a/2*x.^2)'); % a = m/(kbT)
fit_maxwell = fit(xoutv',nbinv',ffun2);

figure(3)
bar(xoutv,nbinv)
hold on
plot(fit_maxwell,'r')
hold off
xlabel('v')
ylabel('Anzahl der Punkte')
legend('Simulation',['Maxwell-Fit: k_b*T = ', num2str(1/fit_maxwell.a),', k_b*T_{<v^2>} = ', num2str(1/mkbT)])

% Gesamtenergie über die Zeitschritte
figure(4)
Energy = sum(v_abs.^2,1)/2 + g.*sum(n,1);
plot(Energy)
xlabel('t')
ylabel('E_{ges}')


clc;
clear all;

N = 23;
L = N^2;
q = 3;
n = 500;
seedzahl = 5;
rand('seed',seedzahl);
xy = rand(N,2);
anz_var = 10;
eps = 1e-5;
MW_var = 1+eps;
k = 0;

xy = xy';

x = xy(1,:);
y = xy(2,:);

T_0 = 1;
T = 1;

E_vec = zeros(L,1);

E_MW = zeros(n,1);
E_var = zeros(n,1);

distances = dist(xy); % Abstände aller Punkte zueinander ermitteln

seq = 1:N; % Anfangssequenz

E = sum(diag(distances,-1)) + distances(end,1); %Anfangsenergie berechnen (geschlossener Rundkurs!)


while eps < MW_var
    
    k = k+1;
    
%for k=1:n
    
    if k ~= 1; T = T_0/k^q; end %Temperaturen immer neu berechnen
    
    for i=1:L
        r_ind = randi(N,1,2);
        a = min(r_ind); %a ist die kleinere der beiden Zufallszahlen
        a_minus = a;
        b = max(r_ind); %b ist die grössere der beiden Zufallszahlen
        b_plus = b;

        if a == 1; a_minus = N+1; end %die Reihenfolge ist geschlossen
        if b == N; b_plus = 0; end %die Reihenfolge ist geschlossen

        if isequal([a,b],[1,N]) %a,b dürfen nicht gleich 1,N sein -> sonst deltaE=0
            deltaE = 0;   
        else
            deltaE = distances(seq(a_minus-1),seq(b)) + distances(seq(a),seq(b_plus+1)) - distances(seq(a_minus-1),seq(a)) - distances(seq(b),seq(b_plus+1));
        end

        [seq,E] = metropolis(deltaE,T,a,b,seq,E); %in metropolis wird neue Reihenfolge akzeptiert oder die alte beibehlaten
        
        E_vec(i) = E; %Energie nach jedem Schritt mitprotokollieren
        
    end
    
    E_MW(k) =  mean(E_vec); %Mittelwert der Energie berechnen
    E_var(k) = var(E_vec); %Varianz der Energie berechnen
    
    if k >= anz_var
        MW_var = mean(E_var(k-anz_var+1:k)); % Konvergenzkriterium
    end
    
    if mod(k,2) == 0 %Grafische Ausgabe
        figure(1)
 
        plot(x(1),y(1),'or','MarkerFaceColor',[1 0 0])
        hold on;
        plot(x(2:end),y(2:end),'ob','MarkerFaceColor',[.49 1 .63])

        plot(x(seq),y(seq),[x(seq(1)),x(seq(N))],[y(seq(1)),y(seq(N))],'-b');
        hold off;
        title(['Lage der Städte mit den verschiedenen Wegstrecken bei T_{', num2str(k),'} = ', num2str(T)])
        xlabel('x')
        ylabel('y')
        pause(0.1)
    end
   
%end

if k == n; break; end

end

fprintf('Folge konvergiert! \n'); 
fprintf(['Anzahl der benötigten Temperaturen: ',num2str(k)]);
fprintf('\n');
fprintf(['Dabei erreichter Energiemittelwert: ',num2str(E_MW(k))]);
fprintf('\n');

figure(2)
plot(1:k,E_MW(1:k))
title('Plot der Mittelwerte')
ylabel('Mittelwert')
xlabel('Inverse Temperatur')

figure(3)
plot(1:k,E_var(1:k))
title('Plot der Varianzen')
ylabel('Varianz')
xlabel('Inverse Temperatur')

figure(1)

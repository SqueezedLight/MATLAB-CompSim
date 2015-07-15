%hai_fisch simulation
%23.01.11

clear all


%DEFINITIONEN
L = 20;            %größe des Ozeans
nH = 26;            %anzahl der haie
nF = 210;           %anzahl  der fische
t_max = 1000;        %zahl der zeitschritte
t_fish = 5;        %fisch breed time
t_hai = 20;         %hai breed time
t_starve = 5;
%DEFINITIONEN

Fisch = zeros(1,t_max);
Hai = zeros(1,t_max);


%Fische und Haie verteilen
ind = randperm(L^2);
indH = [ind(1:1:nH);zeros(1,nH)];
indF = ind(nH+1:1:nH+nF);

%nachbarn berechnen
neighbor = get_neighbor(L);

%ozean befüllen
ocean = zeros(1,L^2);
ocean(indH(1,:)) = 1;
ocean(indF) = -1;


%zeitschleife
figure
for t = 1:t_max
    
    %fische schwimmen
    for i = 1:length(indF)
        neighi = neighbor(indF(i),:);
        neighi = neighi(ocean(neighi)==0);
        if numel(neighi)>0;
            p = randi(numel(neighi));
            ocean(indF(i)) = 0;
            indF(i) = neighi(p);
            ocean(indF(i)) = -1;
        end
            
    end
    
    %fische kinder
    if mod(t,t_fish)==0
        for i = 1:numel(indF)
            neighi = neighbor(indF(i),:);
            neighi = neighi(ocean(neighi)==0);
            if numel(neighi)>0;
                p = randi(numel(neighi));
                indF1 = neighi(p);
                ocean(indF1) = -1;
                indF = [indF,indF1];
            end

        end
    end
    
    
    %haie fressen und schwimmen
    for i = 1:numel(indH(1,:))
        neighi = neighbor(indH(1,i),:);
        neigheat = neighi(ocean(neighi)==-1);
        neighmov = neighi(ocean(neighi)==0);
        if numel(neigheat)>0
            p = randi(numel(neigheat));
            ocean(neigheat(p)) = 0;
            indF(neigheat(p) == indF) = [];
            indH(2,i) = 0;
        elseif numel(neighmov)>0
            p = randi(numel(neighmov));
            ocean(indH(1,i)) = 0;
            indH(1,i) = neighi(p);
            ocean(indH(1,i)) = 1;    
        end
        
    end
    
    
    %haie kinder
    if mod(t,t_hai)==0
        for i = 1:numel(indH(1,:))
            neighi = neighbor(indH(1,i),:);
            neighi = neighi(ocean(neighi)==0);
            if numel(neighi)>0;
                p = randi(numel(neighi));
                indH1 = [neighi(p);0];
                ocean(indH1(1)) = 1;
                indH = [indH,indH1];
            end

        end
        
    end
    %haie sterben
    indH(2,:) = indH(2,:) +1;
    
    ocean(indH(1,indH(2,:)>t_starve)) = 0;
    indH(:,indH(2,:)>t_starve) = [];
    
    Fisch(t) = numel(indF);
    Hai(t) = numel(indH(1,:));
    
    %ausgabe
    if mod(t,20) ==0
    spy(flipud(reshape(ocean,L,L)')==1,'rx')
    hold on
    spy(flipud(reshape(ocean,L,L)') ==-1)
    hold off
    pause(0.1)
    end

end

 plot(1:t_max,Fisch,1:t_max,Hai)
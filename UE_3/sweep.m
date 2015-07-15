function [S,E,M] = sweep(S,beta,neighbor,L,E,M)

%% Zufaellige Reihenfolge der L^2 Gitterpunkte
%gpkt = randperm(L^2);
gpkt = randi([1,L^2],L^2);

%% SpinFlip
for ii=1:L^2
    [deltaE,deltaM,S] = MetropolisSingleSpinFlip(S,ii,beta,neighbor,gpkt);
    E = E + deltaE;
    M = M + deltaM;
end
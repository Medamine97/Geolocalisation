clear
close all
clc

fe=16.368e6; % fréquence d'échantillonnage
fi=2.046e6; % fréquence intermédiaire
Tc=1e-3; % période du code C/A
nbr_ech=fe*Tc; % nombre d'échantillons par période de code

prn=10; % numéro PRN du satellite à étudier

ca = 2*gcacode(prn)-1; % code C/A du satellite à étudier
sca = sampleca(ca,fe); % code rééchantillonné à la fréquence fe

figure
plot(sca)
axis([0 length(sca) -1.2 1.2])
xlabel('Echantillon')
ylabel('Code C/A')
title('Code C/A de PRN 10, échantillonné à 16.368 MHz')

fid = fopen('rec.bin.091','r','l'); % ouverture du fichier en lecture, format little-endian

data01=fread(fid,nbr_ech,'ubit1','l'); % lecture du signal sur 1 période de code
data=2*data01-1; % conversion de binaire en -1 / 1

figure
plot(data)
axis([0 length(data) -1.2 1.2])
xlabel('Echantillon')
ylabel('Signal d''antenne')
title('Signal brut en sortie d''antenne, échantillonné à 16.368 MHz')

fclose(fid); % fermeture du fichier
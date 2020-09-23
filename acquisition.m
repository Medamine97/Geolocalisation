clear
close all
clc

fe=16.368e6; % fr�quence d'�chantillonnage
fi=2.046e6; % fr�quence interm�diaire
Tc=1e-3; % p�riode du code C/A
nbr_ech=fe*Tc; % nombre d'�chantillons par p�riode de code

prn=10; % num�ro PRN du satellite � �tudier

ca = 2*gcacode(prn)-1; % code C/A du satellite � �tudier
sca = sampleca(ca,fe); % code r��chantillonn� � la fr�quence fe

figure
plot(sca)
axis([0 length(sca) -1.2 1.2])
xlabel('Echantillon')
ylabel('Code C/A')
title('Code C/A de PRN 10, �chantillonn� � 16.368 MHz')

fid = fopen('rec.bin.091','r','l'); % ouverture du fichier en lecture, format little-endian

data01=fread(fid,nbr_ech,'ubit1','l'); % lecture du signal sur 1 p�riode de code
data=2*data01-1; % conversion de binaire en -1 / 1

figure
plot(data)
axis([0 length(data) -1.2 1.2])
xlabel('Echantillon')
ylabel('Signal d''antenne')
title('Signal brut en sortie d''antenne, �chantillonn� � 16.368 MHz')
%Acquisitionpar FFT
R=[];
ftest=-5000:100:5000;
for deltaf=ftest  %for Q3
    %deltaf = -2660; %frequence Dopler du satellite 10 Q2
    fs=fi+deltaf;
    t=0:1/fe:1e-3-1/fe;
    porteusec=cos(2*pi*fs*t);
    porteuse=sin(2*pi*fs*t);
    I=data.*porteusec.' ; 
    Q=data.*porteuse.' ;
    X=fft(I+1i*Q);
    Y= conj(fft(sca));
    r2=(ifft(X.*Y.')).^2;
    R=[R r2];
    
end;
figure
%plot(abs(r2))
mesh(ftest,t,abs(R))



fclose(fid); % fermeture du fichier
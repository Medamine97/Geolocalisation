clear
close all
clc

fe=16.368e6; % fréquence d'échantillonnage
fi=2.046e6; % fréquence intermédiaire
Tc=1e-3; % période du code C/A
nbr_ech=fe*Tc; % nombre d'échantillons par période de code (càd sur une milliseconde)

K=1;N=1;
ftest=-5000:100:5000;
t=0:1/fe:N*1e-3-1/fe; % vecteur temps à fréquence d'échantillonnage fe, sur N millisecondes
listeprn=[];
listedeccode=[];
listedoppler=[];
for prn=1:32 % numéro du satellite à étudier
    fid = fopen('rec.bin.091','r','l'); % ouverture du fichier en lecture, format little-endian
    ca = 2*gcacode(prn)-1; % code C/A du satellite à étudier
    sca = sampleca(ca,fe); % code rééchantillonné à la fréquence fe
    scaNms=[];
    for i=1:N
        scaNms=[scaNms sca]; % N périodes (càd N millisecondes) de code GPS pour le satellite numéro prn
    end
    Rsum=zeros(length(t),length(ftest));
    for k=1:K
        data01=fread(fid,nbr_ech*N,'ubit1','l'); % lecture du signal sur N période de code
        data=2*data01-1; % conversion de binaire en -1 / 1
        R=[];
        for deltaf=ftest % fréquence Doppler à tester
            fs=fi+deltaf;
            porteusec=cos(2*pi*fs*t); % réplique de la porteuse en cos
            porteuses=sin(2*pi*fs*t); % réplique de la porteuse en sin
            I=data.*porteusec.'; % démodulation du signal reçu
            Q=data.*porteuses.';
            X=fft(I+1i*Q);
            Y=conj(fft(scaNms));
            r2=(ifft(X.*Y.')).^2; % corrélation calculée sur le bloc de données numéro k
            R=[R r2];
        end
        Rsum=Rsum+R; % somme des résultats de corrélation sur K blocs
    end
    meancorr=mean(mean(abs(Rsum)));
    maxcorr=max(max(abs(Rsum)));
    if maxcorr/meancorr>20 % détection automatique d'un pic de corrélation
        figure
        mesh(ftest,t(1:nbr_ech),abs(Rsum(1:nbr_ech,:)))
        title(num2str(prn))
        X=abs(Rsum(1:nbr_ech,:))==max(max(abs(Rsum(1:nbr_ech,:))));
        [row,col] = find(X);
        listeprn=[listeprn prn];
        listedeccode=[listedeccode row];
        listedoppler=[listedoppler ftest(col)];
        figure
        plot(abs(Rsum(1:nbr_ech,col)))
        pause(0.1)
    end
    fclose(fid); % fermeture du fichier
end

clearvars -except listeprn listedeccode listedoppler
save result_acq
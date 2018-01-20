clear
close all
I=imread ('lenaBW.tif');
% I=imread ('x-ray.tif');
noise=input('inserisci varianza rumore additivo gaussiano [ 0 - 0.01 ] ');
n=input('Inserisci ampiezza max filtro ');
if mod(n,2)==0
    n=n+1;
end
I=imnoise(I,'gaussian',0,noise);
B2=adaptivefilter(I,n,'advavg',noise,2);
B=adaptivefilter(I,n,'avg',noise);
k=fspecial('average',n);
R=imfilter(I,k);
f1=figure('Position',[100,100,1450,700]);
secondline='media 0 e var ' + string(num2str(noise));
subplot(1,2,1),imshow(I), title({'Immagine con rumore gaussiano'; secondline },'FontSize',9);
subplot(1,2,2),imshow(R), title('Risultato filtro media aritmetica ' + string(num2str(n))+'x' + string(num2str(n)) ,'FontSize',9);
f2=figure('Position',[100,100,1450,700]);
subplot(1,2,1),imshow(B), title('Risultato filtro adattivo locale ' + string(num2str(n))+'x' + string(num2str(n)) ,'FontSize',9);
subplot(1,2,2),imshow(B2), title('Filtro adattivo locale migliorato ' + string(num2str(n))+'x' + string(num2str(n)) ,'FontSize',9);

clear
close all
I=imread('lenaBW.tif');

noise=input('inserisci varianza rumore additivo gaussiano [ 0 - 0.01 ] ');

R=imnoise(I,'gaussian',0,noise);
f=figure('Position',[200,200,1200,600]);
subplot(1,3,1),imshow(I),title('Originale');
secondline='media 0 e var ' + string(num2str(noise));
subplot(1,3,2),imshow(R), title({'Immagine con rumore gaussiano'; secondline },'FontSize',9);
hold on
y=[1,60,60,1,1];
x=[110,110,170,170,110];
plot(x,y);

S=im2double(R(1:60,110:170));
varl=var(S(:));
secondline='var calcolata: ' + string(num2str(varl));
subplot(1,3,3),imshow(S), title({'Particolare con rumore gaussiano'; secondline },'FontSize',9);

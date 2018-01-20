clear
close all
I=imread('lenaBW.tif');%('x-ray.tif');
noise=input('inserisci livello rumore s&p [ 0 - 1 ] ');
n=input('Inserisci ampiezza max filtro ');
if mod(n,2)==0
    n=n+1;
end
I=imnoise(I,'salt & pepper',noise);
f=figure('Position',[100,100,1450,700]);
subplot(2,3,1),imshow(I),title('Immagine con rumore s&p al ' +string(num2str(noise*100))+'%','FontSize',9);
[B,st]=adaptivefilter(I,n,'median');

% k=ones(n,n);
% R=ordfilt2(I,median(1:n*n),k);
R=medfilt2(I,[n, n],'symmetric');
subplot(2,3,2),imshow(R), title('Filtro mediano ' + string(num2str(n))+'x' + string(num2str(n)) ,'FontSize',9);
subplot(2,3,3),imshow(B), title('Filtro mediano adattivo ' + string(num2str(n))+'x' + string(num2str(n)),'FontSize',9);
str=st(2,:);
subplot(2,3,[4,6]),plot(st(1,:),st(2,:),'r*'), title({'Ampiezze utilizzate dal'; 'filtro adattivo' },'FontSize',9), grid on, hold on,
text(st(1,:),st(2,:),string(num2str(str(:))));
% figure, imshow(B), title('Filtro mediano adattivo ' + string(num2str(n))+'x' + string(num2str(n)),'FontSize',9);
% figure,imshow(R), title('Filtro mediano ' + string(num2str(n))+'x' + string(num2str(n)) ,'FontSize',9);
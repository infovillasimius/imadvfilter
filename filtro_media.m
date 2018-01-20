clear
close all
I=imread('lenaBW.tif');
f=figure('Position',[200,200,1200,600]);
subplot(2,3,1),imshow(I), title('Immagine originale','FontSize',9);
a=2;
for n=3:2:11
    k=fspecial('average',n);
    R=imfilter(I,k);
    subplot(2,3,a),imshow(R), title('Filtro media ' + string(num2str(n))+'x' + string(num2str(n)) ,'FontSize',9);
    a=a+1;
end
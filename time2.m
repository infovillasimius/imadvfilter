clear
close all
I=(imread ('lenaBW.tif'));
noise=0.002;
R=imnoise(I,'gaussian',0,noise);
figure,imshow(R);
m=7;
t=cputime;

RR=(imadvfilter2b(R,m,noise,2));
tfin=cputime;
figure,imshow(RR);
TotalTime=tfin-t;

K = wiener2(R,[m m],noise);
figure,imshow(K);

err1=ssim(RR,I);
err2=ssim(K,I);

err3=immse(RR,I);
err4=immse(K,I);
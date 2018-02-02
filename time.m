clear
close all
I=imread ('anto.jpg');
R(:,:,1)=imadjust(I(:,:,1));
R(:,:,2)=imadjust(I(:,:,2));
R(:,:,3)=imadjust(I(:,:,3));

noise=0.01;
m=51;

R=imnoise(I,'gaussian',0,noise);
figure,imshow(R);
t=cputime;

RR=imadvfilter2b(R,m,noise,2);
tfin=cputime;
figure,imshow(RR);
TotalTime=tfin-t;

K(:,:,1)=wiener2(R(:,:,1),[m m],noise);
K(:,:,2)=wiener2(R(:,:,2),[m m],noise);
K(:,:,3)=wiener2(R(:,:,3),[m m],noise);
figure,imshow(K);

err1=immse(RR,I)
err2=immse(K,I)
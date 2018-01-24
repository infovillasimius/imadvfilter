clear
close all
I=imread ('cameraman.tif');
R=imnoise(I,'gaussian',0,0.003);
RR=imadvfilter2b(R,15,0.003,1.25);
figure,imshow(RR);

 J = imnoise(I,'gaussian',0,0.003);
 K = wiener2(J,[7 7]);
 figure,imshow(K);
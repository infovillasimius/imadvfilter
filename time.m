clear
close all
I=imread ('lenaBW.tif');
R=imnoise(I,'gaussian',0,0.003);
RR=imadvfilter(R,9,0.003,2);
imshow(RR);

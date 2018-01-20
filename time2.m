clear
close all
I=imread ('lenaBW.tif');
R=imnoise(I,'gaussian',0,0.005);
RR=imadvfilter(R,15,0.005,2);
imshow(RR);
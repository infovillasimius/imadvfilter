clear
close all
I=imread ('anto.jpg');
R=imnoise(I,'gaussian',0,0.005);
RR(:,:,1)=imadvfilter(R(:,:,1),15,0.005,2);
RR(:,:,2)=imadvfilter(R(:,:,2),15,0.005,2);
RR(:,:,3)=imadvfilter(R(:,:,3),15,0.005,2);
imshow(RR);

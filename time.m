clear
close all
I=imread ('anto.jpg');
R=imnoise(I,'gaussian',0,0.005);
figure,imshow(R);
RR(:,:,1)=imadvfilter2(R(:,:,1),15,0.005,1.5);
RR(:,:,2)=imadvfilter2(R(:,:,2),15,0.005,1.5);
RR(:,:,3)=imadvfilter2(R(:,:,3),15,0.005,1.5);
figure,imshow(RR);




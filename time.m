clear
close all
I=imread ('anto.jpg');
R=imnoise(I,'gaussian',0,0.002);
figure,imshow(R);
RR(:,:,1)=imadvfilter2b(R(:,:,1),9,0.002,1.25);
RR(:,:,2)=imadvfilter2b(R(:,:,2),9,0.002,1.25);
RR(:,:,3)=imadvfilter2b(R(:,:,3),9,0.002,1.25);
figure,imshow(RR);




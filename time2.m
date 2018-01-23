clear
close all
I=imread ('x-ray.tif');
R=imnoise(I,'gaussian',0,0.002);
RR=imadvfilter2(R,15,0.002,1.5);
figure,imshow(RR);

J = imnoise(I,'gaussian',0,0.002);
K = wiener2(J,[7 7]);
figure,imshow(K);
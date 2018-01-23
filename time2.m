clear
close all
I=imread ('lenaBW.tif');
R=imnoise(I,'gaussian',0,0.002);
RR=imadvfilter2(R,9,0.003,1.5);
figure,imshow(RR);

% J = imnoise(I,'gaussian',0,0.002);
% K = wiener2(J,[7 7]);
% figure,imshow(K);
clear
close all
I=imread ('lenaBW.tif');
% I=imread ('x-ray.tif');
% I=imread ('cameraman.tif');

nome='cameraman';

% f1=figure('Position',[100,100,1450,700]);
    
for n=1:10
    dim=0;
    noise=n/1000;
    R=imnoise(I,'gaussian',0,noise);
    for i=3:2:15
        dim=dim+1;
        R1= wiener2(R,[i i]); %adaptivefilter(R,i,'avg',noise);
        
        nom1=char("avg"+nome+"-"+string(num2str(n))+'-'+string(num2str(i))+".tif")
        imwrite(R1,nom1,'tif');
        % subplot(2,5,n),imshow(imsubtract(R1,I));
        err1(dim,n)=immse(R1,I)
        R2=imadvfilter2b(R,i,noise,1.5);%adaptivefilter(R,i,'advavg',noise,1.25);
        nom2=char("adv"+nome+"-"+string(num2str(n))+'-'+string(num2str(i))+".tif")
        imwrite(R2,nom2,'tif');
        % subplot(2,5,5+n),imshow(imsubtract(R2,I));
        err2(dim,n)=immse(R2,I)
    end
end

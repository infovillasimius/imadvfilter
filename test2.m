clear
close all
% I=(imread ('lenaBW.tif'));
I=(imread ('x-ray.tif'));
% I=imread ('cameraman.tif');

nome='cameraman';
    
for n=1:10
    dim=0;
    noise=n/1000;
    R=imnoise(I,'gaussian',0,noise);
    for i=3:4:31
        dim=dim+1;
        
        t=cputime;
        R1= wiener2(R,[i i],noise); 
        tfin=cputime;
        time1(dim,n)=tfin-t;
        nom1=char("../../../../../Scrivania/img/avg"+nome+"-"+string(num2str(n))+'-'+string(num2str(i))+".tif")
        imwrite(R1,nom1,'tif');
        
        err_Wiener2(dim,n)=immse(R1,I)
        t=cputime;
        R2=imadvfilter2(R,i,noise,1.25);
        tfin=cputime;
        time2(dim,n)=tfin-t;
        nom2=char("../../../../../Scrivania/img/adv"+nome+"-"+string(num2str(n))+'-'+string(num2str(i))+".tif")
        imwrite(R2,nom2,'tif');
        
        err_advfilter2(dim,n)=immse(R2,I)
    end
end
TempoMedioWiener2=mean(time1(:))
TempoMedioAdvFilter=mean(time2(:))
TempoTotaleWiener2=sum(time1(:))
TempoTotaleAdvFilter=sum(time2(:))

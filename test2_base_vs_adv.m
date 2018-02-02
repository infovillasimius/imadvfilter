clear
close all
% I=(imread ('lenaBW.tif'));
I=(imread ('x-ray.tif'));
% I=imread ('cameraman.tif');
    
for n=1:10
    dim=0;
    noise=n/1000;
    R=imnoise(I,'gaussian',0,noise);
    for i=3:4:31
        dim=dim+1;
        
        t=cputime;
        R1= imbasefilter(R,i,noise);
        tfin=cputime;
        time1(dim,n)=tfin-t;
        err_imbasefilter(dim,n)=mean2((R1-I).^2)%immse(R1,I);
        
        t=cputime;
        R2=imadvfilter2(R,i,noise,2);
        tfin=cputime;
        time2(dim,n)=tfin-t;        
        err_advfilter2(dim,n)=mean2((R2-I).^2);%immse(R2,I);
        
        t=cputime;
        R3= wiener2(R,[i i],noise); 
        tfin=cputime;
        time3(dim,n)=tfin-t;       
        err_Wiener2(dim,n)=mean2((R3-I).^2);%immse(R3,I);
        
    end
end
TempoMedio_imbasefilter=mean(time1(:))
TempoMedio_imavdflter2=mean(time2(:))
TempoTotale_imbasefilter=sum(time1(:))
TempoTotale_imavdflter2=sum(time2(:))
TempoTotaleWiener2=sum(time3(:))
TempoMedioWiener2=mean(time3(:))
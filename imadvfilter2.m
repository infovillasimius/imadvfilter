% Funzione filtro adattivo locale avanzato
% function R=imadvfilter(I,dim,vR,d)
% 
% Input: 
% I = matrice contenente l'immagine
% dim = dimensione filtro
% vR = varianza rumore immagine
% d = valore di soglia per riduzione ampiezza filtro (valori consigliati 1.1<d<2.5 )

function R=imadvfilter2(varargin)

[I,dim,vR,d]=arginput(varargin{:});

[~,~,c]=size(I);
if c==3
  R(:,:,1)=imadvfilter2(I(:,:,1),dim,vR,d);
  R(:,:,2)=imadvfilter2(I(:,:,2),dim,vR,d);
  R(:,:,3)=imadvfilter2(I(:,:,3),dim,vR,d);
  return;
end

if vR==0
    R=I;
    return;
end

pd=(dim-1)/2;
padI=im2double(I);

[x,y]=size(padI);
vR0= ones(x,y)*vR;
p=pd;
i=1;
pdp=ceil(log2(pd))+1;
passi=zeros(1,pdp);

while p>1
    passi(i)=p;
    p=ceil(p/2);
    i=i+1;
end

passi(pdp)=1;
padI2=padI.^2;
padIR=zeros(x,y);
just=zeros(x,y);

for ciclo= 1 : pdp-1 
    
    l=2*passi(ciclo)+1;
    F=ones(l) / (l*l);
    aml = filter2(F, padI);
    avl = filter2(F, padI2) - aml.^2;
    f0=avl>vR;
    avl=(avl.*f0) + vR0 .* ~f0;
    flag=avl/vR<=d;
    
    padIR = padIR + ((padI-vR0./avl.*(padI-aml)).*~just .* flag);
    just=or(just,flag);
       
end

l=2*passi(pdp)+1;
F=ones(l)/(l*l);
aml = filter2(F, padI);
avl = filter2(F, padI2) - aml.^2;
f0=avl>vR;
avl=(avl.*f0) + vR0 .* ~f0;
padIR = padIR + ((padI-vR0./avl.*(padI-aml)).*~just);

if isa(I,'double')
    depadI=im2double(padIR);
    else
    depadI=im2uint8(padIR);
end
R=depadI;
end



function v=stima(I)
for p=10:-1:1    
    vp(p)=stimavarianza(I,p+5);
end
v=mean(vp);
end

function v=stimavarianza(I,p)
I=im2double(I);
[x,~]=size(I);
pd=(ceil(x/p));
padI=padarray(I,[pd,pd],'replicate','both');
[xmax, ymax]= size(padI);
xp=1;
for i=pd+1:pd:xmax-pd
    for j=pd+1:pd:ymax-pd
        S=padI(i-pd:i+pd,j-pd:j+pd);          
        vl(xp)=var(S(:));
        xp=xp+1;          
    end
end
v=min(vl(:));
end

function [I,dim,vR,d]=arginput(varargin)
dim=-1;
vR=-1;
d=2;

switch nargin
    case 0
        error("First argument must be the image matrix");
    case 1
        I=varargin{1};
    case 2
        I=varargin{1};
        dim=varargin{2};
    case 3
        I=varargin{1};
        dim=varargin{2};
        vR=varargin{3};
    case 4
        I=varargin{1};
        dim=varargin{2};
        vR=varargin{3};
        d=varargin{4};
    otherwise
        error('To many arguments')
end

if vR<0
    vR=stima(im2double(I));
end

if dim<3
    dim=ceil(33+log2(vR)*3)*2-1;
    if dim>25
        dim=25;
    end
    if dim < 3
        dim = 3;
    end
end

if d<1
    d=1;
end

if mod(dim,2)==0
    dim=dim+1;
end

end

function [R,stat]=adaptivefilter(varargin)

% Funzione: adaptivefilter
% Scopo: esegue il filtraggio adattivo di un'immagine
% Parametri: immagine,dimmaxvalue,tipoFiltro,varianzaRumore,soglia
% immagine: Matrice contenente l'immagine
% dimmaxvalue: dimensione massima del filtro 
% (intero dispari positivo) - default 7
% tipoFiltro: 'avg' | 'median' | 'advavg' - default = 'median' 
% varianzaRumore: varianza del rumore (solo per i filtri 'avg' e 'advavg'). 
% Se non è specificato un valore viene eseguita una stima con una scansione        
% sull'immagine con una maschera pari a 1/5 della sua dimensione per trovare 
% il valore locale minimo della varianza
% Al filtro 'advavg' si può passare il parametro numerico soglia>=2 che è
% utilizzato per effettuare un ulteriore passo di analisi locale per
% migliorare l'effetto di pulizia dal rumore.


switch nargin
    case 0
        error("Occorre inserire in input almeno la matrice contenente l'immagine!");
    case 1
        tmp1=varargin{1};
    case 2
        tmp1=varargin{1};
        tmp2=varargin{2};
    case 3
        tmp1=varargin{1};
        tmp2=varargin{2};
        tmp3=varargin{3};
    case 4
        tmp1=varargin{1};
        tmp2=varargin{2};
        tmp3=varargin{3};
        tmp4=varargin{4};
    case 5
        tmp1=varargin{1};
        tmp2=varargin{2};
        tmp3=varargin{3};
        tmp4=varargin{4};
        tmp5=varargin{5};
    otherwise
        error("Troppi argomenti");
end

dim=size(tmp1);
if isnumeric(tmp1) & dim(1)>1 & dim(2)>1 & size(dim)<3
    I=im2double(tmp1);
else
    error("Il primo argomento deve essere la matrice contenente l'immagine greyscale");
end

tipofiltro="median";
maxvalue=7;
varianzaRumore=0.01;
d=4;

if nargin>1 
    if isnumeric(tmp2) & size(tmp2)==1
        maxvalue=tmp2;
    end
    if mod(maxvalue,2)==0
        maxvalue=maxvalue+1;
    end
    
    if maxvalue<3
        maxvalue=3;
    end
    
    if isstring(tmp2)
        tipofiltro=string(tmp2);
    end 
end

if nargin>2
     if isnumeric(tmp3) & size(tmp3)==1
        maxvalue=tmp3;
    end
    if mod(maxvalue,2)==0
        maxvalue=maxvalue+1;
    end
    
    if ischar(tmp3)  
        tipofiltro=string(tmp3);     
    end
end

if nargin>3 & (tipofiltro=='avg' | tipofiltro=='advavg')
    if isnumeric(tmp4) & size(tmp4)==1
        varianzaRumore=tmp4;
    else 
        error ('Il quarto argomento deve essere la varianza del rumore');
    end
    if isnan(tmp4)
        varianzaRumore=stimavarianza(I);
    end
end

if nargin>4
    if isnumeric(tmp5) & size(tmp5)==1
        d=tmp5;
    else
        d=2;
    end
    
    if d<2
        d=2;
    end
    
end


if (tipofiltro=='avg' | tipofiltro=='advavg') & nargin < 4
    varianzaRumore=stimavarianza(I);
end

if maxvalue<3
  maxvalue=3;
end

pd=(maxvalue-1)/2;
padI=padarray(I,[pd,pd],'replicate','both');

switch tipofiltro
    case 'avg'
        padIR=avg(padI,pd,varianzaRumore);
        st=varianzaRumore;
    case 'median'
        [padIR,st]=med(padI,maxvalue);
    case 'advavg'
        padIR=advavg(padI,pd,varianzaRumore,d);
        st=varianzaRumore;
    otherwise
        error("Filtro sconosciuto");
end

depadI=(padIR(pd+1:end-pd,pd+1:end-pd));
depadI=im2uint8(depadI);

if isa(tmp1,'double')
    depadI=im2double(depadI);
end
R=depadI;
stat=st;
end

% Applica il filtro adattivo locale
function I=avg(padI,pd,vR)
[xmax, ymax]= size(padI);
padIR=padI;
for i=pd+1:xmax-pd
    for j=pd+1:ymax-pd
        S=padI(i-pd:i+pd,j-pd:j+pd);  
        ml=mean(S(:));
        vl=var(S(:));
        if vR>vl
            vl=vR;
        end   
        padIR(i,j)=padI(i,j)-vR/vl*(padI(i,j)-ml);       
    end
end
I=padIR;
end

% Applica il filtro mediano adattivo
function [I,stat]=med(padI,maxvalue)
Smax=(maxvalue-1)/2;

[xmax, ymax]= size(padI);
padIR=padI;
st=[3:2:maxvalue;zeros(1,Smax)];
for i=Smax+1:xmax-Smax
    for j=Smax+1:ymax-Smax
        flag=0;
        pd=1;
        while pd<=Smax          
            S=padI(i-pd:i+pd,j-pd:j+pd);
            zmin=min(S(:));
            zmax=max(S(:));
            zmed=median(S(:));
            zxy=padI(i,j);           
            A1=zmed-zmin;
            A2=zmed-zmax;        
            if A1>0 & A2<0
                flag=1;
                B1=zxy-zmin;
                B2=zxy-zmax;
                if B1>0 & B2<0
                    padIR(i,j)=zxy;
                else
                    padIR(i,j)=zmed;
                end
                
                st(2,pd)=st(2,pd)+1;
                pd=Smax+1;
            else
                pd=pd+1;
            end
        end
        if flag==0
            padIR(i,j)=zmed;
            st(2,Smax)=st(2,Smax)+1;
        end
    end
end
stat=st;
I=padIR;
end

% Stima varianza rumore
function v=stimavarianza(I)
[x,~]=size(I);
pd=(ceil(x/20));
padI=padarray(I,[pd,pd],'replicate','both');
[xmax, ymax]= size(padI);
minvar=100000;
for i=pd+1:pd:xmax-pd
    for j=pd+1:pd:ymax-pd
        S=padI(i-pd:i+pd,j-pd:j+pd);          
        vl=var(S(:));
        if vl<minvar
            minvar=vl;
        end             
    end
end
v=minvar;
end

% Applica il filtro adattivo locale avanzato
function I=advavg(padI,pd,vR,d)
if vR==0
	I=padI;
    return
end
[xmax, ymax]= size(padI);
padIR=padI;
for i=pd+1:xmax-pd
    for j=pd+1:ymax-pd
        S=padI(i-pd:i+pd,j-pd:j+pd);      
        vl=var(S(:),1);
        
        if vl/vR>d & pd>1
            padIR(i,j)=centerpoint(S,pd,vR,d);
        else
            if vR>vl
                vl=vR;
            end
                 
            ml=mean(S(:));
            z=padIR(i,j);
            padIR(i,j)=z-vR/vl*(z-ml);
        end
    end
end
I=padIR;
end

% funzione aggiuntiva per il filtro adattivo locale avanzato
function p=centerpoint(I,pd,vR,d)

center=pd+1;
newpd=ceil(pd/2);
padI=I(center-newpd:center+newpd,center-newpd:center+newpd);
vl=var(padI(:),1);
if vl/vR>d & newpd>1
    
    p=centerpoint(padI,newpd,vR,d);
else
    z=I(center,center);
    ml=mean(padI(:));
    if vl/vR>(d*0.5)
        p=z-vR/vl*(z-ml);
    else
        p=ml;
    end
end
end



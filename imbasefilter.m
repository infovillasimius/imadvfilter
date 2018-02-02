% Funzione filtro adattivo locale 
% function R=imadvfilter(I,dim,vR)
% 
% Input: 
% I = matrice contenente l'immagine
% dim = dimensione filtro
% vR = varianza rumore immagine


function R=imbasefilter(I,dim,vR)

[~,~,c]=size(I);
if c==3
  R(:,:,1)=imbasefilter(I(:,:,1),dim,vR);
  R(:,:,2)=imbasefilter(I(:,:,2),dim,vR);
  R(:,:,3)=imbasefilter(I(:,:,3),dim,vR);
  return;
end

if vR==0
    R=I;
    return;
end

if mod(dim,2)==0
    dim=dim+1;
end

padI=im2double(I);

[x,y]=size(padI);
vR0= ones(x,y)*vR;

F=ones(dim)/(dim*dim);

aml = filter2(F, padI);
avl = filter2(F, padI.^2) - aml.^2;

f0=avl>vR;
avl=(avl.*f0) + vR0 .* ~f0;

padIR = padI - vR0./avl.*(padI - aml);

if isa(I,'double')
    depadI=im2double(padIR);
    else
    depadI=im2uint8(padIR);
end

R=depadI;

end


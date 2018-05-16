function X = pga( Y,D,ncla,claindex,lam1,lam2,lam3)
%UNTITLED Summary of this function goes here
%   proximal gradient algotithm
%   objective function: (y-Dx)^2+lam*|x|
% ncla:number of class
% claindex: current class
subsize=size(D,2)/ncla;
lam=ones(size(D,2),1)*lam3;  %0.35
lam((claindex-1)*subsize+1:claindex*subsize,1)=lam1;
lam(ncla*subsize+1:(ncla+1)*200,1)=lam2;
numiter=5;
stepsize=0.95/max(eig(D*D'));
X=zeros(size(D,2),size(Y,2));
b=size(Y,2);
h=waitbar(0,'begin');
for jj=1:b
    y=Y(:,jj);
    x=zeros(size(D,2),1);
    for i=1:numiter
        cx=x+2*stepsize*D'*(y-D*x);
        x=(max(abs(cx)-lam*stepsize,0)).*sign(cx);
    end
    X(:,jj)=x;
    waitbar(jj/b,h,['number of feature completed ' num2str(round(jj*100/b)) '%']);
end
close(h);
end


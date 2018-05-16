function X = fistpga( Y,D,ncla,claindex,lam1,lam2,lam3)
%UNTITLED Summary of this function goes here
%   proximal gradient algotithm
%   objective function: (y-Dx)^2+lam*|x|
% ncla:number of class
% claindex: current class
tic;
subsize=size(D,2)/ncla;

lam=ones(size(D,2),1)*lam3;  %0.35
lam((claindex-1)*subsize+1:claindex*subsize,1)=lam1;
lam(ncla*subsize+1:(ncla+1)*200,1)=lam2;
numiter=5;
lip=1/max(eig(D*D'));
X=zeros(size(D,2),size(Y,2));
a=size(Y,2);
hwait=waitbar(0,'begin');
for jj=1:a
    y=Y(:,jj);
    thk=zeros(size(D,2),1);
    yk=thk;
    tk=1;
    for i=1:numiter
        ck=yk-2*lip*D'*(D*yk-y);
        thk1=(max(abs(ck)-lam*lip,0)).*sign(ck);
        tk1=.5+.5*sqrt(1+4*tk^2);
        tt=(tk-1)/tk1;
        yk=thk1-tt*(thk1-thk);
        tk=tk1;
        thk=thk1;
    end
    X(:,jj)=thk1;
    disj=round(jj/a*100);
    waitbar(jj/a,hwait,['number of feature completed ' num2str(disj) '%'])
end
close(hwait);
fprintf('time elapsed %d\n',toc);
end

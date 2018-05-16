function X = fistff( Y,D,ncla,claindex,lam1,lam2,lam3)

NUM=3; % 分组编码数目，内存不足，则增大该数字
a=size(Y,2);
b=round(a/NUM);
c=round(2*a/NUM);
Y1=Y(:,1:b);
Y2=Y(:,b+1:c);
Y3=Y(:,c+1:a);
X1=fistpgaff( Y1,D,ncla,claindex,lam1,lam2,lam3);
X2=fistpgaff( Y2,D,ncla,claindex,lam1,lam2,lam3);
X3=fistpgaff( Y3,D,ncla,claindex,lam1,lam2,lam3);
X=[X1 X2 X3];
end
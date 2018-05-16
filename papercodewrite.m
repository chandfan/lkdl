%*********************************** 论文程序编写记录*******************
% 1 另外编写一个函数trainconca，训练级联字典，1 2 3 。。。11 其中11为所有局部特征训练出来的字典，然后保存在当前目录
% 2 稀疏编码 逐类
% 3 字典更新
%
%
%
%
%
%
%
%
%
%
%
%
%
%*********************************************************************
clc,clear;
load 'data\concatenatdic.mat';    %DD
load 'data\traindescriptor.mat';  %trlowdimfeat
%******************************** 训练字典 ***************************
%*********************************************************************
%    第一部分：稀疏编码 ***********************************

%****************** 变量定义*************************
NUMCLASS=10;
subsize=size(DD,2)/(NUMCLASS+1);          %2200/11
lam1=.8;
lam2=.8;
lam3=1.2;
beta=.01;
numiter=15;


%****************变量定义结束***********************

%  **************    程序开始   ***********

%  注释掉 date 2016 09 18 

XX=cell(1,NUMCLASS);
% for i=1:NUMCLASS
%     XX{1,i}=zeros(size(DD,2),size(trlowdimfeat{1,i},2));
% end
objvalue=zeros(numiter,1);

%**********************************************************************
%*****第一层循环，训练字典过程，包括稀疏编码和字典更新********************
for iter=11:numiter
fprintf('iter %d/%d\n',iter,numiter);
tic;
for i=1:10
    Y=trlowdimfeat{1,i};  % 某一行为的降维数据。
    scmode=2;
    switch scmode;
        case 0
            X=fistpga(Y,DD,NUMCLASS,i,lam1,lam2,lam3);  %迫近梯度，fista     效率慢
        case 0.5
            X=fistff(Y,DD,NUMCLASS,i,lam1,lam2,lam3);  %fista  改进版本，批量运算 收敛性与lambda值有关
         % 上述两种情况相似   
            
        case 1
            X=pga(Y,DD,NUMCLASS,i,lam1,lam2,lam3);    % 稀疏编码： 迫近梯度，单个执行   效率慢
        case 2
            X=groupsc(Y,DD,i,lam1,lam2,lam3);         %贪婪算法
    end
%     %*****************************************
%     test=0;               % 测试系数是否分组分布
%     if(test)
%       subsize=200; numclass=10;
%       d=zeros(1,numclass);
%       for mm=1:numclass+1
%           d(1,mm)=nnz(X((mm-1)*subsize+1:mm*subsize,:));
%       end
%       bar(d);
%     end
%     %*****************************************
    XX{1,i}=X;
%   save('data\sparcodesXX.mat' , 'XX');
fprintf('sparse coding completed :  class %d/%d\n',i,NUMCLASS);
end

%***************************** 测试proximal gradient algorithm 稀疏编码
%***************************编写一个函数 pga
% y=trlowdimfeat{1,1}(:,1);
% x=fistpga(y,DD,10,1);
% plot(x);











%***********************************************************
%    第二部分 字典更新 **************************************
  for mm=1:NUMCLASS
      Y=trlowdimfeat{1,mm};  % 某一行为的降维数据。
      D2=DD;
      D1=DD(:,(mm-1)*200+1:mm*200);
      D2(:,(mm-1)*200+1:mm*200)=[];
      CX=XX{1,mm};
      CX1=CX((mm-1)*200+1:mm*200,:);
%       CX((mm-1)*200+1:mm*200,:)=[];
%     
%       newY=Y-D2*CX;  %现在优化  |newY-D1*CX1|^2+ |D1'*D2|^2
      % use sylvester equation
 
     % CC=newY*CX1';
       CC=Y*CX1'; %效果不好，测试直接逼近Y,加快速度可以注释掉上面7行
      AA=beta*D2*D2';
      BB=CX1*CX1';
      solu=sylvester(AA,BB,CC);
      DD(:,(mm-1)*200+1:mm*200)=solu;
      fprintf('dictioanry update completed %d/10 \n ',mm);
  end
  
 % *******************字典归一化,对应系数也变化******************
 %************************非常重要*****************************
 for ni=1:size(DD,2)
     normcol=norm(DD(:,ni),2);
     DD(:,ni)=DD(:,ni)/(normcol+eps);   
 end
  
 
 %******** 目标函数值
fobj=0;
 for ii=1:NUMCLASS
     Y=trlowdimfeat{1,ii};
     coeff=XX{1,ii};
     valuerec=norm(Y-DD*coeff,'fro')^2;  % 数据保真项
     
     % ***********************************惩罚项，一范数
     coeff1=coeff((ii-1)*subsize+1:ii*subsize,:);
     valuecoeff1=sum(sum(abs(coeff1)));
     coeff2=coeff(NUMCLASS*subsize+1:(NUMCLASS+1)*200,:);
     valuecoeff2=sum(sum(abs(coeff2)));
     valuecoeff3=sum(sum(abs(coeff)))-valuecoeff1-valuecoeff2;
     
     %******************* inchohenrence term
     D2=DD;
     D1=DD(:,(ii-1)*200+1:ii*200);
     D2(:,(ii-1)*200+1:ii*200)=[];
     valueincohe=norm(D1'*D2,'fro')^2;
     %******************* fobj 目标函数值
     fobj=valuerec+lam1*valuecoeff1+lam2*valuecoeff2+lam3*valuecoeff3+beta*valueincohe;
 end
 objvalue(iter,1)=fobj;
 timcount=toc;
 fprintf('time used %d\n',timcount);
 plot(objvalue);
 
end    % end*********结束字典训练的单次循环*********************




%*******************识别阶段**************************date: 2016 09 21
%**********************************************************************
load 'data\testfe.mat';                    %  testfeat{1,10}
for i=1:NUMCLASS
    testf=testfeat{1,i};
    fprintf('true label %d ',i);
    label=recog(testf,DD,NUMCLASS); 
    fprintf('recognized as %d \n',label);
end


















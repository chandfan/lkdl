%%
addpath('E:\程序\piotr_toolbox_V3.02\toolbox\matlab')
cliptypes = { 'anger','disgust','fear','joy','sadness','surprise' };

 cm=[1 0 0 0 0 0;
     0.02 0.97 0.01 0 0 0;
     0 0 1 0 0 0;
     0 0 0 1 0 0
     0 0 0 0 1 0;
     0 0 0 0 0 1];
 figure,
a=subplot(1,3,1);
 confmatrix_show( cm, cliptypes, {'FontSize',12} )
% set(gcf,'Position',[100 100 200 200]);
%  set(gca,'Position',[.4 .1 .8 .6]);
%  
% set(gcf,'Position',[100 100 200 200]);
%  set(gca,'Position',[.20 .17 .80 .74]);
PPP=get(a,'pos');%第NN张子图的当前位置
PPP(1)=PPP(1)-0.04;%向右边延展0.04
PPP(4)=PPP(4)+0.07;%向右边延展0.04
% %PPP(4)=PPP(4)+0.03;;%向上方延展0.03
set(a,'Position',PPP)%根据新的边界设置。
%  
 %%
 
 cm=[0.58 0.3 .12 0 0 0;
     .02 .98 0 0 0 0;
     .12 .05 .83 0 0 0;
     0 0 0 1 0 0;
     .05 0 0 0 .95 0;
     0 0 0 0 0 1];
b=subplot(1,3,2);
 confmatrix_show( cm, cliptypes, {'FontSize',12} )
 PPP=get(b,'pos');%第NN张子图的当前位置
PPP(4)=PPP(4)+0.07;%向右边延展0.04
%PPP(4)=PPP(4)+0.03;;%向上方延展0.03
set(b,'Position',PPP)%根据新的边界设置。
 %set(gcf,'Position',[100 100 200 200]);
 %set(gca,'Position',[.20 .17 .80 .74]);
%  set(gca,'Position',[.2 .1 .80 .7]);
 %%
 cm=[1 0 0 0 0 0;
     .15 .85 0 0 0 0;
     0 .15 .85 0 0 0;
     0 0 0 1 0 0
     .20 0 .20 0 .6 0 ;
     0 0 0 0  0 1];
c=subplot(1,3,3);
  confmatrix_show( cm, cliptypes, {'FontSize',12})
  PPP=get(c,'pos');%第NN张子图的当前位置
PPP(1)=PPP(1)+0.04;%向右边延展0.04
PPP(4)=PPP(4)+0.07;%向右边延展0.04
%PPP(4)=PPP(4)+0.03;;%向上方延展0.03
set(c,'Position',PPP)%根据新的边界设置。



%%
cliptypes={ 'Bend','Jack','F-jump','P-jump','Run','S-walk' ,'Skip','Walk','Wave1','Wave2'};
cm=[1 0 0 0 0 0 0 0 0 0;
     0 1 0 0 0 0 0 0 0 0;
     0 0 1 0 0 0 0 0 0 0;
     0 0 0 .97 .02 .01 0 0 0 0;
     0 0 0 0 1 0 0 0 0 0;
     0 0 0 0 0 1 0 0 0 0;
     0 0 0 0 0 0 1 0 0 0;
     0 0 0 0 0 0 0 1 0 0;
     0 0 0 0 0 0 0 0 .99 .01;
     0 0 0 0 0 0 0 0 0 1];
  confmatrix_show( cm, cliptypes, {'FontSize',12} )
  set(gcf,'Position',[100 100 200 200]);
 set(gca,'Position',[.20 .17 .7 .74]);
 
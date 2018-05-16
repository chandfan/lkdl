% % 首先运行papercodewrite
% X=[];sp=[];
% for i=1:10
%     X1=testfeat{1,i};
% 
% %X1=testfeat{1,10};
% sparseatom=30;
% D=DD;
% spcoeff=omp(D'*X1,D'*D,sparseatom);
% sp=[sp spcoeff];
% end
% 
% figure
% aa=full(min(min(abs(sp))));
% bb=full(max(max(abs(sp))));
% img=full(abs(sp));
% %img=imresize(img,0.25);
% thresh=.3*bb;
% for m=size(img,1)
%     for n=size(img,2)
%         if(img(m,n)<=thresh)
%             img(m,n)=0;
%         else
%             img(m,n)=1
%         end
%     end
% end


%%
%重构误差方块能量图
% sparseatom=10;
%  reconerr=zeros(10,10);
% for kk=1:10
%     X1=testfeat{1,kk};
%    
%     spcoeff=omp(D'*X1,D'*D,sparseatom);
%     for i=1:10
%         reconerr(kk,i)=norm(D(:,(i-1)*subsize+1:i*subsize)*spcoeff((i-1)*subsize+1:i*subsize,:),'fro')/norm(X1,'fro');
%     end
%     
% end
% img=reconerr;
% img=imresize(img,20);
% imshow(img,[]);
% colormap;
% 
% 
% %%
% %  guha learned dictionary
% sparseatom=10;
% subsize=256;
% reconerr=zeros(10,10);
% for j = 1:size(WIStest,1)
%     disp(j);
%     fprintf(1,'Original class = %s \n', WIStest{j,1});
%     names = fieldnames(WIStest{j,2});  
%     
%     for jj = 1:size(names,1)
%         % get the test video
%         V = double(WIStest{j,2}.(names{jj,1}));
%         
%         % extract LMP features
%         des = [];                                                                                                                                                                                                                                                                                                  
%         % loop for each temporal scale
%         for k = 1:length(N_sq)
%             % detect keypoints in the video 
%             [Patch Pts_sq Patch_sq] = lmpDetect(V, N_sq(k), w);
%             % compute descriptors
%             p = lmpDes(Patch, Patch_sq, Pts_sq, N_sq(k));
%             des = [des p]; 
%         end
%         
%         % reduce dimenionality of the descriptors
%         des = R*des; 
%         
%         % classify using RSR %
%         % parameters
%         X1 = des; 
%         % concatenate all class-specific dictionaries
%         D =[]; D = [D Tr{1,:}];
%         Tparams.dict = D; 
%         Tparams.Tdata = 10; 
%         Tparams.Nclass = 10;
%         spcoeff=omp(D'*X1,D'*D,sparseatom);
%         
%         
%         for i=1:10
%         reconerr(j,i)=norm(D(:,(i-1)*subsize+1:i*subsize)*spcoeff((i-1)*subsize+1:i*subsize,:),'fro')/norm(X1,'fro');
%         end
% 
%         
%     end
% end
% 
% img=reconerr;
% img=imresize(img,20);
% imshow(img,[]);
% colormap;

load('E:\程序\结构字典学习\16年8月\plotcolorfig\smallimg2.mat')
img=imresize(reconerr,20);
imshow(img,[]);
colormap;
colorbar;
set(gca,'position',[0 0 1 1]);


load('E:\程序\结构字典学习\16年8月\plotcolorfig\srcmethod.mat')
img2=reconerr;
img2=imresize(img2,20);
figure,
imshow(img2,[]);
colormap;
colorbar;
% set(gcf,'Position',[100 100 200 200]);
%  set(gca,'Position',[.20 .17 .8 .74]);
 
set(gca,'position',[0 0 1 1]);

% for i=1:10
%     reconerr(i,i)=reconerr(i,i)*1.5;
% end

%% plot convergence figure
load('E:\程序\结构字典学习\16年8月\plotcolorfig\converg2.mat')
figure,
plot([1:1:15]',objvalue,'-b*','MarkerEdgeColor','r','LineWidth',2);
xlabel('迭代次数')
ylabel('目标函数值')

set(gca,'xtick',[1:15]);
grid on
% 





   
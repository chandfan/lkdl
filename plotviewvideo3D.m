function viewvideo3D
%load('E:\程序\动作识别cuboids_Apr19_2006\新建文件夹\set02\clip_walk007.mat')  % left
load('E:\程序\动作识别cuboids_Apr19_2006\新建文件夹\set00\clip_bend008.mat')    %right
% load('E:\数据库\facial expriment\set01\clip_joy006.mat')
%I = double(I);
scaratio=.5;
startframe=1;
stepframe=10;

img1=imresize( I(:,:,1),scaratio);
vidi=zeros(size(img1,1),size(img1,2),size(I,3));
for j=1:size(I,3)
    tem=imresize(I(:,:,j),scaratio);
    vidi(:,:,j)=tem;
end
figure(1); clf; axis vis3d;
% samplei=vidi;
% samplei(:,:,:)=0;
% samplei(:,:,startframe:stepframe:size(I,3))=vidi(:,:,startframe:stepframe:size(I,3));

stvolume_I(vidi,0.6,stepframe);
stvolume_cameraset;
    
  %%% used to display the spatiotemporal volume I, with transperancy set by alpha  
    function stvolume_I( I, alpha,stepframe )
    if( nargin<2 || isempty(alpha) ) alpha=1; end;
    siz=size(I);
    hold on; 
    %hslice=slice( I, [1 siz(2)-1], [1 siz(1)-1], [ 1:stepframe:siz(3)-1] );
%     hslice=slice( I, [1 ], [siz(2)-1], [ 1:stepframe:siz(3)-1] );  % view(30,-30)
%     
     hslice=slice( I, [], [1], [ siz(3)-1:-stepframe:1] ); %view(120,-30)
    set(hslice,'EdgeColor', 'none'); set(hslice,'FaceAlpha', alpha ); 
    hold off;
    
    
    bnds = [1 siz(2); 1 siz(1); 1 siz(3) ];
    stvolume_bnds( bnds );
    set(gca,'position',[0 0 1 1]);
    
   %%% used to draw boundaries around a stvolume - the black lines 
    function stvolume_bnds( bnds, color )
    if( nargin<2 ) color = 'b'; end;
    hold on;
    for i=1:2 for j=1:2
        h=line( [bnds(1,1) bnds(1,2)], [bnds(2,i) bnds(2,i)], [bnds(3,j) bnds(3,j)] );
        set(h,'Color',color); set(h,'LineWidth',1.2); 
        h=line( [bnds(1,i) bnds(1,i)], [bnds(2,1) bnds(2,2)], [bnds(3,j) bnds(3,j)] );
        set(h,'Color',color); set(h,'LineWidth',1.2);
        h=line( [bnds(1,i) bnds(1,i)], [bnds(2,j) bnds(2,j)], [bnds(3,1) bnds(3,2)] );
        set(h,'Color',color); set(h,'LineWidth',1.2);
    end; end;
    hold off;
    
    
    function stvolume_cameraset
    colormap gray; axis off;
    camproj('perspective');
    set(gca,'DataAspectRatio',[1 1 1/3] );
%     view([30 -30]); camup([0 -1 0])
    view([140 -30]); camup([0 -1 0])

clear all; close all;
addpath('./LMP Descriptors')
load('WISdemo.mat');

%% TRAINING %%

%% Feature extraction %%

% set parameters
% specify temporal resolutions (multiscale)
N_sq = [8, 10];
% specify spatial resolution (single scale demo)
w = 24;
% initialize cell structure to store descriptors
DesTr = cell(10,10);

% extract LMP features from each video
disp('*TRAINING*');
disp('Extracting features ...');
for j = 1:size(WIStrain,1)
    disp(WIStrain{j,1});
    names = fieldnames(WIStrain{j,2});  
    DesTr{1,j}= char(WIStrain{j,1});
    for jj = 1:size(names,1)
        % get the clip
        fprintf(1,'video %d \n',jj);
        V = double(WIStrain{j,2}.(names{jj,1}));
        des = [];
        % loop for each temporal scale
        for k = 1:length(N_sq)
            % detect keypoints in the video 
            [Patch Pts_sq Patch_sq] = lmpDetect(V, N_sq(k), w);
         %  [Patch Pts_sq Patch_sq NP] = periodsample(V, 5,3, w);
            % compute descriptors
           p = lmpDes(Patch, Patch_sq, Pts_sq, N_sq(k));
           %p = lmpDes(Patch, Patch_sq, Pts_sq, NP);
            des = [des p]; 
        end
        fprintf(1,'computed %d LMP descriptors! \n', size(des,2));
        DesTr{jj+1,j} = des;
    end
end

%% Dictionary Learning %% 

%clc;
% create a random matrix
R = randn(100,1728);
R = normc(R);

% Initialize
Tr = cell(1,11);
trlowdimfeat=cell(1,10);
% loop for each class
disp('TRAINING');
disp('Learning class-specific dictionaries ...');
for j = 1:size(WIStrain,1)
    fprintf(1,' class %s \n', DesTr{1,j});
     
    % collect all descriptors from a class
    Y = [];
    Y = [Y DesTr{2:9,j}];
     
    % remove mean
    Y = Y - repmat(mean(Y,2),[1,size(Y,2)]);   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%怎么是沿着行求平均  
    
    % reduce dimensionality by random projection
    Y = R*Y;
    
    % learn dictionary using KSVD algorithm
    % ** requires KSVDbox and OMPbox ** %
    params.data = Y;
    params.dictsize = size(Y,1)*2; % overcompleteness factor 2
    params.Tdata = 12;
    [D,X] = ksvd(params); % to mute this function use  ksvd(params,'');
    Tr{1,j} = D;
    trlowdimfeat{1,j}=Y;
end
 Y = [];
for j=1:size(Tr,2)    %直接用先前学习到的字典学习共同字典
    Y = [Y Tr{1,j}];     
end

% 学习共同的字典
params.data = Y;
params.dictsize = size(Y,1)*2; % overcompleteness factor 2
params.Tdata = 12;
[D,X] = ksvd(params);
Tr{1,11} = D;
DD=[];
for i=1:11
    DD=[DD Tr{1,i}];
end
%****************************************************************************
%*******************训练后测试视频，降维的局部特征，保存。*******************
testfeat=cell(1,10);
for j = 1:size(WIStest,1)
    names = fieldnames(WIStest{j,2}); 
    for jj = 1:size(names,1)
        % get the test video
        V = double(WIStest{j,2}.(names{jj,1}));
        
        % extract LMP features
        des = [];
        % loop for each temporal scale
        for k = 1:length(N_sq)
            % detect keypoints in the video 
            [Patch Pts_sq Patch_sq] = lmpDetect(V, N_sq(k), w);
            % compute descriptors
            p = lmpDes(Patch, Patch_sq, Pts_sq, N_sq(k));
            des = [des p]; 
        end
        
        % reduce dimenionality of the descriptors
        des = R*des; 
        testfeat{1,j}=des;
       
        
    end
end



%******************************************************************************
%*************************保存 数据******************************************
save 'data/traindescriptor.mat' trlowdimfeat;
save 'data/testfe.mat' testfeat;
save 'data/concatenatdic.mat' DD;



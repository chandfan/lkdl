%% DEMO: Action Recognition on the Weizmann Dataset %
                                                  
% Reference: T. Guha and R. Ward, "Learning sparse representations for
% action recognition", IEEE Trans. PAMI, 2012.
%


% Load demo data file

% clear; close all;
addpath('./LMP Descriptors')
load('WISdemo.mat');

% TRAINING %%

% Feature extraction %%

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
R = randn(128,1728);
R = normc(R);

% Initialize
Tr = cell(1,10);

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
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alldic =[]; alldic = [alldic Tr{1,:}];
params.data = alldic;
params.dictsize = size(alldic,1)*2; % overcompleteness factor 2
params.Tdata = 12;
params.iternum=20;
[comdic,Xcom] = ksvd(params); % to mute this function use  ksvd(params,'');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% %% CLASSIFICATION by RSR %%
% 
% %clc;
% rec = 0;
% % set feature extraction parameters
% % specify temporal resolutions (multiscale)
% N_sq = [8, 10];
% % specify spatial resolution (single scale demo)
% w = 24;
% 
% 
% % classify
% disp('CLASSIFICATION');
% disp('RSR algortihm');
% for j = 1:size(WIStest,1)
%     disp(j);
%     fprintf(1,'Original class = %s \n', WIStest{j,1});
%     names = fieldnames(WIStest{j,2});  
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
%         Tparams.data = des; 
%         % concatenate all class-specific dictionaries
%         D =[]; D = [D Tr{1,:}];
%         Tparams.dict = D; 
%         Tparams.Tdata = 12; 
%         Tparams.Nclass = 10;
%         Tparams.thresh = 0.4; 
%         
%         Label = RSR(Tparams);
%         if(strcmp(WIStest{Label,1},WIStest{j,1})),rec=rec+1;end
%         fprintf(1,'Classified as = %s \n \n', WIStest{Label,1});
%         
%     end
% end
% fprintf(1,'classification accuracy %d%% \n',rec*100/10);

%% CLASSIFICATION using CONCATENATED DICTIONARY %%

%clc;
rec = 0;
% set feature extraction parameters
% specify temporal resolutions (multiscale)
N_sq = [8, 10];
% specify spatial resolution (single scale demo)
w = 24;

% classify
disp('CLASSIFICATION');
disp('concatenated dictionary');

for j = 1:size(WIStest,1)
    disp(j);
    fprintf(1,'Original class = %s \n', WIStest{j,1});
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
        
        % classify using RSR %
        % parameters
        Tparams.data = des; 
        % concatenate all class-specific dictionaries
        D =[]; D = [D Tr{1,:}];
        Tparams.dict = D; 
        Tparams.Tdata = 2; 
        Tparams.Nclass = 10;
        
        Label = concat(Tparams);
        if(strcmp(WIStest{Label,1},WIStest{j,1})),rec=rec+1;end
        fprintf(1,'Classified as = %s \n \n', WIStest{Label,1});
        
    end
end
fprintf(1,'classification accuracy %d%% \n',rec*100/10);

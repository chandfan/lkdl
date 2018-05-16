%% Demo: Local Motion Pattern (LMP) feature extraction %%

% Reference: T. Guha and R. Ward, "Learning sparse representations for
% action recognition", IEEE Trans. PAMI, 2012.
%
% Author: Tanaya Guha, UBC
%--------------------------------------------------------------------------
clear all; close all; clc;

% load demo video
load('demoAction.mat');

% set temporal resolution
N_sq = 8;
% set spatial resolution (patch size)
w = 12;

% detect keypoints in the video 
disp('detecting keypoints in the video...'); 
[Patch Pts_sq Patch_sq] = lmpDetect(demoAction, N_sq, w);

fprintf(1,'%d keypoints found...\n', sum(Pts_sq));

% compute descriptors
Des = lmpDes(Patch, Patch_sq, Pts_sq, N_sq);
fprintf(1,'computed %d LMP descriptors!', sum(Pts_sq));

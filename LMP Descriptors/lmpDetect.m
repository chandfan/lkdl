function [Patch Pts_sq Patch_sq] = lmpDetect(V, N_sq, w)

% This function detects the local spatio-temporal keypoints, known as
% the Local Motion Patterns (LMP).
%_-------------------------------------------------------------------------
% Input:
%       V = the video sequence, 3D array
%       N_sq = temporal resolution i.e. the number of subsequences V should
%       be divided into
%       w = spatial resolution i.e. patch size. A patch size of w implies
%       a window of size w x w.

% Output: 
%       Patch = patches extracted centered at the spatio-temporal interest
%               points, M x N array, where M (= w^2) is the vectorized 2d 
%               patch dimension, and N is the total number of patches
%               extracted from the video.
%
%       Pts_sq = keypoints detected per subsequence, a vector of
%                dimension N_sq, (Finally, we get one descriptor per
%                keypoint).
%            
%       Patch_sq = patches extracted per subsequence (no. of keypoints
%       times the no. of frames per subsequence). Note, that
%       sum(Patch_sq)= N.

% Example: [Patch Pts_sq Patch_sq] = lmpDetect(V, 8, 12);
%--------------------------------------------------------------------------
% Author: T. Guha, ECE, UBC
% Reference: T. Guha and R. Ward, "Learning sparse representations for
% action recognition", IEEE Trans. PAMI, 2012.
%--------------------------------------------------------------------------

% STEP #1 Divide video sequence into a number of subsequences %

% length of the video sequence
L = size(V,3);

% # of frames per sub-sequence
F_sq = floor(L/N_sq);

% initialize %
Patch = []; Pts_sq = []; Patch_sq = [];

% loop for every subsequence %
    
    for j = 1:N_sq
        
        % get the first frame of the first block
        V0 = V(:,:,(j-1)*F_sq +1);
      
        % STEP #2 : detect spatial keypoints at the 1st frame %
              
        % Harris keypoint detector - single scale
        % // kp_harris function is written by Vincent Garcia, see kp_harris.m
        % for more information// %
        
        % Note that any 2D keypoint detector can be used        
        pts = kp_harris(V0); 
        
        % get rid of the points close to the edge of the image
        xp1 = pts(:,1)+w/2 <= size(V0,1);
        xp2 = pts(:,1)-w/2 >= 1;
        xp = xp1.*xp2;
        yp1 = pts(:,2)+ w/2<= size(V0,2);
        yp2 = pts(:,2)- w/2 >= 1;
        yp = yp1.*yp2;
        goodind = (xp.*yp==1); % goodkeypoints
        STpts = pts(goodind,:);

        % # of good keypoints
        m = size(STpts,1);
    
        % store the keypoint locations
        x = zeros(1,1,m); y = zeros(1,1,m);
        x(1,1,:) = STpts(:,1); y(1,1,:) = STpts(:,2);
        
         % STEP #3 extract patches centered at those points %
        if (rem(w,2)== 0)
            [dY,dX] = meshgrid(-(w/2-1):w/2,-(w/2-1):w/2);
            Xp = repmat(dX,[1 1 m]) + repmat(x, [w w 1]);
            Yp = repmat(dY,[1 1 m]) + repmat(y, [w w 1]);  
        else
            [dY,dX] = meshgrid(-(w-1)/2:(w-1)/2,-(w-1)/2:(w-1)/2);
            Xp = repmat(dX,[1 1 m]) + repmat(x, [w w 1]);
            Yp = repmat(dY,[1 1 m]) + repmat(y, [w w 1]);  
        end            
        
        
        if (j == N_sq) % adjustments for the last block 
            count = abs(L-(N_sq-1)*F_sq);
            Patch_sq = [Patch_sq m*count];
        else
            count = F_sq;
            Patch_sq = [Patch_sq m*count];
        end
        % extract patches at the same location at every frame of a subsequence
        for k = 1:count
            V0 = V(:,:,(j-1)*F_sq +k);        
            p = V0(Xp+(Yp-1)*size(V,1));
            p = reshape(p, [w^2, m]);
            Patch = [Patch p];
        end
        Pts_sq = [Pts_sq m];
    end
    
    % rearrange the patch vectors such that the patches extracted at the same
    % location at different frames are together
    clear p;
    P = [];
    for j = 1:N_sq
        if (j==1)
            k_start = 0;
        else
            k_start = sum(Patch_sq(1:j-1));
        end
        for k = 1:Pts_sq(j)
            P = [P Patch(:,k+k_start:Pts_sq(j):k_start+Patch_sq(j))];
        end
    end
    Patch = P;
                   
return
            




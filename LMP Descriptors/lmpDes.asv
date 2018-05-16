function Des = lmpDes(Patch, Patch_sq, Pts_sq, N_sq)

% This function computes a descriptor for each spatio-temporal cube,
% detcted by lmpDetect.
%--------------------------------------------------------------------------
% INPUT:
%       Patch, Patch_sq, Pts_sq = outputs of lmpDetect
%       N_sq = temporal resolution i.e. the number of subsequences V should
%       be divided into.

% OUTPUT: 
%       Des = descriptors computed from the spatio-temporal cubes
%             points, P x D array, where P is the descriptor dimension 
%             and D is the total number of descriptors i.e. the total 
%             number of keypoints (sum(Pts_sq)) extracted by lmpDetect.

% Example: Des = lmpDes(Patch, Patch_sq, Pts_sq, 12);
%--------------------------------------------------------------------------
% Author: T. Guha, ECE, UBC
% Reference: T. Guha and R. Ward, "Learning sparse representations for
% action recognition", IEEE Trans. PAMI, 2012.
%--------------------------------------------------------------------------
if (nargin<4)
    error('not enough input parameters');
end

% initialize
Des = [];

% get the patch size used
w = sqrt(size(Patch,1));

% loop for every subsequence
for j = 1:N_sq
    if (j~=1)
        j_start = sum(Patch_sq(1:j-1));
    else
        j_start = 0;
    end
    P_sq = Patch(:,j_start+1:j_start+Patch_sq(j));
    n = Patch_sq(j)/Pts_sq(j);
    for k = 1:Pts_sq(j)
        % get the patch volume
        p = P_sq(:,(k-1)*n+1:k*n);
        
        % gaussian smoothing in space not in temporal direction
        p = reshape(p,[w,w,size(p,2)]);
        p = filt3Gaussian(p,[0.5,0.5,0.1]);
        p = reshape(p,[w^2,size(p,3)]);
        
        % remove mean
        p_mean = mean(p,2);
        p_mean = repmat(p_mean,[1,size(p,2)]);
        p = p - p_mean;
                
        % compute moemnts
        var_p = moment(p,2,2);
        skew_p = moment(p,3,2);
        kurt_p = moment(p,4,2);
        
        % combine them into one vector
        p = [var_p skew_p kurt_p];
                
        Des = [Des p(:)];
    end
end
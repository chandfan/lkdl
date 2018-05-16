function J = filt3Gaussian(I,sigma,Ksize)
% 
% This function filters a 3D grayscale image with a Gaussian filter. 
% It uses separable linear 1D Gaussian filters and the matlab function 
% IMFILTER for filtering.
% 
% J = filt3Gaussian(I,SIGMA,SIZE)
%
% inputs,
%   I: The 3D grayscale input image
%   SIGMA: The sigma used for the Gaussian kernel
%   Ksize: Kernel size, default value: [5 5 5]
% 
% outputs,
%   J: The Gaussian blurred image
%
% Author: Tanaya Guha, UBC
% Acknowledgement: D. Kroon, University of Twente

if(~exist('Ksize','var')), Ksize = [ceil(6*sigma(1)) ceil(6*sigma(2)) ceil(6*sigma(3))]; end

    % 1D Gaussian kernel in X direction
    x = -ceil(Ksize(1)/2):ceil(Ksize(1)/2);
    H = exp(-(x.^2/(2*sigma(1)^2)));
    Hx = H/sum(H(:));
    
    % 1D Gaussian kernel in Y direction
    x = -ceil(Ksize(2)/2):ceil(Ksize(2)/2);
    H = exp(-(x.^2/(2*sigma(2)^2)));
    Hy = H/sum(H(:));
    
    % 1D Gaussian kernel in Z direction
    x = -ceil(Ksize(3)/2):ceil(Ksize(3)/2);
    H = exp(-(x.^2/(2*sigma(3)^2)));
    Hz = H/sum(H(:));  


    % Filter each dimension with the 1D Gaussian kernels\
    if(ndims(I)<3)
        disp('Error: The input array is not 3D');
    else
        Hx = reshape(Hx,[length(Hx) 1 1]);
        Hy = reshape(Hy,[1 length(Hy) 1]);
        Hz = reshape(Hz,[1 1 length(Hz)]);
        J = imfilter(imfilter(imfilter(I,Hx, 'same' ,'replicate'),Hy, 'same' ,'replicate'),Hz, 'same' ,'replicate');  
    end
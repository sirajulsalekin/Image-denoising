function [rms, psnr] = calcsnr(x,y)
[m n] = size(x);
% snr - signal to noise ratio
%
%   v = snr(x,y);
%
% v = 20*log10( norm(x(:)) / norm(x(:)-y(:)) )
%
%   x is the original clean signal (reference).
%   y is the denoised signal.
% 
%   Copyright (c) 2008 Gabriel Peyre
error = x(:)-y(:);
rms = sqrt((error' * error)/(m*n));
psnr = 20*log10(1/rms);

%psnr = 20*log10(norm(x(:))/norm(x(:)-y(:)))
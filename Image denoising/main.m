clc
clear all;
close all;

orig = im2double(imread('lena512.bmp'));

figure
imshow(orig)
title('Original Image')
[m n] = size(orig);

i1= imnoise(im2double(orig),'salt & pepper',0.01);

figure
imshow(i1)
title('Noisy Image')

medfiltimg = medfilt2(i1);%noise_detection(i1,1,'sqr');

%%%%%%%%% Decomposition %%%%%%%%%

d1L = i1(2:2:m,:); % Low-pass of 1st level decomposition
d1Med = weightedmed(d1L,'r');
d1H = d1Med-i1(1:2:m,:); % High-pass of 1st level decomposition

LL = d1L(:,2:2:n);
d2Med = weightedmed(LL,'c');
LH = d2Med-d1L(:,1:2:n);

HL = d1H(:,2:2:n);
w2Med = weightedmed(HL,'c');
HH = w2Med-d1H(:,1:2:n);

figure
imshow(LL)
title('Noisy LL')
figure
imshow(10*abs(LH))
title('Noisy LH')
figure
imshow(10*abs(HL))
title('Noisy HL')
figure
imshow(10*abs(HH))
title('Noisy HH')

%%%%%%%%%%% Denoising %%%%%%%%%%%

%  LL = noise_detection_se(LL,1,'LL',.15, 3);   % for LL theta=.09, s=1, iteration count=1, 3x3 median filter works perfect.
%  LH = noise_detection_se(LH,2,'HH',.15, 5);    % for LH theta=.06, s=2,2 iteration count=2, 3x3 median filter works fine
%  LH = (noise_detection_se(LH,2,'LH',.25, 5));
%  HL = noise_detection_se(HL,2,'HH',.15, 5); % for HL theta=.07, s=2,2 iteration count=2, 3x3 median filter works fine
%  HL = (noise_detection_se(HL,2,'LH',.25, 5));
%  HH = noise_detection_se(HH,2,'HH',.15, 5);
%  HH = (noise_detection_se(HH,2,'LH',.25, 5));

LL = noise_detection_se(LL,1,'LL',.12, 3);   % for LL theta=.09, s=1, iteration count=1, 3x3 median filter works perfect.
[LHa, rlh, clh] = noise_detection_se(abs(LH),2,'HH',.15, 5);    % for LH theta=.06, s=2,2 iteration count=2, 3x3 median filter works fine
LH = noise_remove( LH, rlh, clh );
[HLa, rhl, chl] = noise_detection_se(abs(HL),2,'HH',.15, 5); % for HL theta=.07, s=2,2 iteration count=2, 3x3 median filter works fine
HL = noise_remove( HL, rhl, chl );
[HHa, rhh, chh] = noise_detection_se(abs(HH),2,'HH',.15, 5);
HH = noise_remove( HH, rhh, chh );

%%%%%%%%% Recconstruction %%%%%%%%%

d1M = weightedmed(LL,'c'); % d1 = LL
d = kron(LL,[0 1]);
[md nd] = size(d);
d(:,1:2:nd) = d1M-LH; %d1M-LH;
d(:,2:2:nd) = LL;  % changed here

w1M = weightedmed(HL,'c'); % d1 = HL
w = kron(HL,[0 1]);
[mw nw] = size(w);
w(:,1:2:nw) = w1M-HH; %w1M-HH;
w(:,2:2:nw) = HL;

d2M = weightedmed(d,'r'); % d1 = d
d2 = kron(d,[1;0]);
[m2 n2] = size(d2);
d2(1:2:m2,:) = d2M-w; %d2M-w;
d2(2:2:m2,:) = d;
%d2 = uint8(d2);
izen = noise_detection(i1,1,'sqr',.15);

[rms_izen, psnr_izen] = calcsnr(im2double(orig),im2double(izen))

[rms_decomposition, psnr_decomposition] = calcsnr(im2double(orig),im2double(d2))

[rms_medfilt, psnr_medfilt] = calcsnr(im2double(orig),im2double(medfiltimg))

[rms_noisy, psnr_noisy] = calcsnr(im2double(orig),im2double(i1))

figure
imshow(d2)
title('Reconstructed Image')

figure
imshow(medfiltimg)
title('Median Filtered only')

figure
imshow(izen)
title('Izen')

figure
imshow(LL)
title('LL')
figure
imshow(3*abs(LH))
title('LH')
figure
imshow(3*HL)
title('HL')
figure
imshow(3*HH)
title('HH')

diff = abs(orig-d2);
figure
imshow(5*diff)
title('Difference')

% figure(9)
% imshow(test)
% title('Test')

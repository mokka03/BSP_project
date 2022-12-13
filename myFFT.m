function [f,P1] = myFFT(A,fs)
%MYFFT
%   Normalized onesided FFT
%   A variable will be transformed
%   fs is the sampling frequency

L = length (A); % Length of A
Y = fft (A) ; % Compute the FFT

P2 = abs (Y/L ); % Compute the two - sided spectrum
P1 = P2 (1: L /2+1) ; % Compute the single - sided spectrum
P1 (2: end -1) = 2* P1 (2: end -1) ; % Compute the single - sided spectrum
P1 = P1/max(P1); % Normalize

f = fs *(0:( L /2) )/L ; % Define the frequency
end
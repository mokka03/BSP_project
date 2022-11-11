% BSP final project
clear all;

%% Load data
sig = audioread("data/normal/85033_TV.wav")';
labels = readtable("data/normal/85033_TV.tsv","FileType","text","Delimiter","tab");
fs = 4000; % Hz
t_length = length(sig)/fs; % s
t = linspace(0, t_length, t_length*fs); % s

%% FFT
A = (sig); % This variable will be transformed
L = length (A); % Length of A
Y = fft (A) ; % Compute the FFT

P2 = abs (Y/L ); % Compute the two - sided spectrum
P1 = P2 (1: L /2+1) ; % Compute the single - sided spectrum
P1 (2: end -1) = 2* P1 (2: end -1) ; % Compute the single - sided spectrum

f = fs *(0:( L /2) )/L ; % Define the frequency

%% Plot
figure(1)
subplot(2,1,1)
plot(t,sig);

subplot(2,1,2)
plot(f,P1);
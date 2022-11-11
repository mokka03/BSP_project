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

%% STFT
% Short-time Fourier transform
[s,f2,t2] = stft(sig,fs,'Window',hann(1024));
sdb = mag2db(abs(s)); % Amplitude spectrum to dB

%% Plot
figure(1)
% Plot signal
subplot(2,1,1)
plot(t,sig);
xlim([t(1) t(end)]);
xlabel('Time [s]');
ylabel('Amplitude [a.u.]');

% Plot FFT
subplot(2,1,2)
plot(f,P1/max(P1));
xlabel('Frequency [Hz]');
ylabel('|A(f)|_{norm} [a. u.]');

% Plot the Short-time Fourier spectrum of the filtered signal
figure(2)
mesh(t2/60,f2,sdb);
cc = max(sdb(:))+[-60 0];
ax = gca;
ax.CLim = cc;
view(2)
c = colorbar;
c.Label.String = 'Amplitude [dB]';
% xlim([0 60]);
% ylim([-1 1]);
xlabel('Time [min]');
ylabel('Frequency [Hz]');
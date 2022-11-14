% BSP final project
clear all;

%% Load data
fileName = '85029';
sig = audioread(strcat("data/normal/", fileName, "_TV.wav"))';
tlabels = readtable(strcat("data/normal/", fileName, "_TV.tsv"),"FileType","text","Delimiter","tab");
fs = 4000; % Hz
t_length = length(sig)/fs; % s
t = linspace(0, t_length, t_length*fs); % s

%% Get labels
labelArray = getLabels(tlabels,fs,t_length);
%% Filtering
% Filtering out the frequencies above 60 Hz
[b_low,a_low] = butter(6,60/(fs/2),'low');
fsig = filter(b_low,a_low,sig);
% % Filtering out the frequencies under ... Hz
% [b_high,a_high] = butter(3,0.1/(fs/2),'high');
% fsig = filter(b_high,a_high,fsig);
% freqz(b1,a1);

%% FFT
[f, sig_FFT] = myFFT(sig,fs);
[f_filtered, fsig_FFT] = myFFT(fsig,fs);

%% STFT
% Short-time Fourier transform
[s,f2_stft,t2] = stft(fsig,fs,'Window',hann(1024));
sdb = mag2db(abs(s)); % Amplitude spectrum to dB

%% Hilbert
fsig_hat = hilbert(fsig);
e = sqrt(fsig.^2 + fsig_hat.^2);


%% Plot
figure(1)
% Plot filtered signal
subplot(2,1,1)
plot(t,fsig);
hold on;
plot(t,abs(e));
plot(t,labelArray/4*max(abs(e)));
hold off;
xlim([t(1) t(end)]);
xlabel('Time [s]');
ylabel('Amplitude [a.u.]');
legend('Signal','Envelope');

% Plot filtered FFT
subplot(2,1,2)
plot(f_filtered,fsig_FFT);
xlim([0 100]);
xlabel('Frequency [Hz]');
ylabel('|A(f)|_{norm} [a. u.]');

%%
% Plot the Short-time Fourier spectrum of the filtered signal
figure(2)
p = pcolor(t2/60,f2_stft,sdb);
set(p, 'EdgeColor', 'none');    % Turn off gtid
cc = max(sdb(:))+[-60 0];
ax = gca;
ax.CLim = cc;
view(2)
c = colorbar;
c.Label.String = 'Amplitude [dB]';
% xlim([0 60]);
ylim([-100 100]);
xlabel('Time [min]');
ylabel('Frequency [Hz]');
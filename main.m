% BSP final project
clear all;

%% Load data
% % fileName = '69141_MV';
% fileName = '85033_TV';
% sig = audioread(strcat("data/normal/", fileName, ".wav"))';
% tlabels = readtable(strcat("data/normal/", fileName, ".tsv"),"FileType","text","Delimiter","tab");

% fileName = '9979_TV';
fileName = '49748_TV';
sig = audioread(strcat("data/murmur/", fileName, ".wav"))';
tlabels = readtable(strcat("data/murmur/", fileName, ".tsv"),"FileType","text","Delimiter","tab");

%% fs and t
fs = 4000; % Hz
t_length = length(sig)/fs; % s
t = linspace(0, t_length, t_length*fs); % s

%% Get labels
labelArray = getLabels(tlabels,fs,t_length);
%% Filtering
f1 = 45; % Hz
f2 = 30; % Hz
% f1 = 100; % Hz
% f2 = 500; % Hz
% Filtering out the frequencies above f1 Hz
[b_low,a_low] = butter(5,f1/(fs/2),'low');
fsig = filter(b_low,a_low,sig);
% Filtering out the frequencies under f2 Hz
[b_high,a_high] = butter(6,f2/(fs/2),'high');
fsig = filter(b_high,a_high,fsig);
% freqz(b1,a1);

%% FFT
[f, sig_FFT] = myFFT(sig,fs);
[f_filtered, fsig_FFT] = myFFT(fsig,fs);

%% STFT
% Short-time Fourier transform
[s,f2_stft,t2] = stft(fsig,fs,'Window',hann(512));
sdb = mag2db(abs(s)); % Amplitude spectrum to dB

%% Envelope using Hilbert transformation
fsig_hat = hilbert(fsig);
analitic = sqrt(fsig.^2 + fsig_hat.^2);
envelope = abs(analitic);
envelope = movmean(envelope,200); %30
envelope = envelope/max(envelope);

%% Find peaks on envelope
[pks, locs] = findpeaks(envelope,'MinPeakDistance',0.17*fs,'MinPeakHeight',mean(envelope)*1); % 0.2s

%% Get heart rate
HeartRate = getHeartRate(envelope,locs,fs);

%% Binary systolic/Diastolic regions
SD = ones(1,length(fsig));

for loc = locs
    if round(loc-(0.1331/2)*fs)>0 && round(loc+(0.1331/2)*fs) < length(fsig)
        SD(round(loc-(0.1331/2)*fs):round(loc+(0.1331/2)*fs)) = 0;
    end
end

%% Murmur detection
pathology = murmur2(sig,fs,SD);

%% Plot
% figure(1)
% % Plot filtered signal
% subplot(2,1,1)
% plot(t,fsig/max(fsig));
% hold on;
% plot(t,envelope*5);
% plot(t,5*labelArray/4*max(envelope));
% plot(locs/fs,pks*5,'.');
% plot(t,SD);
% hold off;
% % xlim([0 10]);
% xlim([t(1) t(end)]);
% xlabel('Time [s]');
% ylabel('Amplitude [a.u.]');
% legend('Signal','Envelope [a.u.]','Hert cycle','S1 and S2', 'S/D regions');
% 
% % Plot filtered FFT
% subplot(2,1,2)
% plot(f_filtered,fsig_FFT);
% xlim([0 100]);
% xlabel('Frequency [Hz]');
% ylabel('|A(f)|_{norm} [a. u.]');
% 
% 
% % Plot the Short-time Fourier spectrum of the filtered signal
% figure(2)
% p = pcolor(t2,f2_stft,sdb);
% set(p, 'EdgeColor', 'none');    % Turn off gtid
% cc = max(sdb(:))+[-60 0];
% ax = gca;
% ax.CLim = cc;
% view(2)
% c = colorbar;
% c.Label.String = 'Amplitude [dB]';
% % xlim([0 60]);
% ylim([-100 100]);
% xlabel('Time [s]');
% ylabel('Frequency [Hz]');

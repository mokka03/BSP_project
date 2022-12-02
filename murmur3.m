function pathology = murmur2(sig,fs)
    %MURMUR2 Summary of this function goes here
    %   Detailed explanation goes here
    pathology = 0;
    %% Filtering
    f1 = 400; % Hz
    f2 = 10; % Hz
    % Filtering out the frequencies above f1 Hz
    [b_low,a_low] = butter(5,f1/(fs/2),'low');
    fsig = filter(b_low,a_low,sig);
    % Filtering out the frequencies under f2 Hz
    [b_high,a_high] = butter(6,f2/(fs/2),'high');
    fsig = filter(b_high,a_high,fsig);
    % freqz(b1,a1);
    
    %% STFT
    % Short-time Fourier transform
    [s,f2_stft,t2] = stft(fsig,fs,'Window',hann(5012));
    sdb = mag2db(abs(s)); % Amplitude spectrum to dB
    
    %% Pathology
    lowfreq = mean(mean(abs(sdb(2520:2657,:))));
    highfreq = mean(mean(abs(sdb(2658:3008,:))));
    ratio = highfreq/lowfreq;
    fprintf('%f\n',ratio);
    
end



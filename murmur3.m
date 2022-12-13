function pathology = murmur3(sig,fs)
    %MURMUR3
    %   Classification based on the ratio of power of low and high
    %   frequencies  on the STFT.
    
    % Inputs:
    % sig: Signal
    % fs: Sampling frequency
    
    % Outputs:
    % pathology: 0 if nurmal, 1 if murmur
    
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
    
    %% STFT
    % Short-time Fourier transform
    [s,f2_stft,t2] = stft(fsig,fs,'Window',hann(800));
    sdb = mag2db(abs(s)); % Amplitude spectrum to dB
    
    %% Pathology
    % Check the ratio of power on STFT from 0 to 120 Hz and from 120 to 400
    % Hz
    lowfreq = mean(mean(abs(sdb(round(size(sdb,1)/2):round(size(sdb,1)/10*5.3),:))));
    highfreq = mean(mean(abs(sdb(round(size(sdb,1)/10*5.3):round(size(sdb,1)/10*6),:))));
    ratio = highfreq/lowfreq;
    if ratio<1.325
        pathology = 1;
    end
end



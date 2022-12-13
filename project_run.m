function properties = project_run(sig)
    %PROJECT_RUN This should be the main function of your project.
    %   Input: PCG signal (fs: 4000 Hz)
    %   Output: properties struct
    %           S_loc:      heartsound locations (samples)
    %           HR:         heartrate (bpm)
    %           ib_seg:     systole/diastole regions (binary mask, 1-s at given samples)
    %           pathology:  normal/murmur (0-normal, 1-murmur)
    
    %% fs and t
    sig = sig';
    fs = 4000; % Hz
    t_length = length(sig)/fs; % s
    t = linspace(0, t_length, t_length*fs); % s
    
    %% Get labels
%     labelArray = getLabels(tlabels,fs,t_length);
    
    %% Filtering
%     f1 = 45; % Hz
%     f2 = 30; % Hz
    f1 = 500; % Hz
    f2 = 10; % Hz
    % Filtering out the frequencies above f1 Hz
    [b_low,a_low] = butter(5,f1/(fs/2),'low');
    fsig = filter(b_low,a_low,sig);
    % Filtering out the frequencies under f2 Hz
    [b_high,a_high] = butter(6,f2/(fs/2),'high');
    fsig = filter(b_high,a_high,fsig);
    
    %% FFT
    [f, sig_FFT] = myFFT(sig,fs);
    [f_filtered, fsig_FFT] = myFFT(fsig,fs);

    %% STFT
    % Short-time Fourier transform
    [s,f2_stft,t2] = stft(fsig,fs,'Window',hann(5012));
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
    
    %% Systolic/Diastolic regions
    SD = ones(1,length(fsig));
    a = 0.11;
%     a = 0.2;
    for loc = locs
        if round(loc-(a/2)*fs)>0 && round(loc+(a/2)*fs) < length(fsig)
            SD(round(loc-(a/2)*fs):round(loc+(a/2)*fs)) = 0;
        end
    end
    
    %% Murmur detection
%     pathology = murmur2(sig,fs,SD,length(pks));
%     fprintf('%i\n',pathology);
    pathology = murmur3(sig,fs);
    
    %% Properties
    properties.S_loc = locs';
    properties.HR = HeartRate;
    properties.ib_seg = SD';
    properties.pathology = pathology;
    properties.len = length(sig);
    
%     %% Plot
%     % Plot the Short-time Fourier spectrum of the filtered signal
%     figure(2)
%     p = pcolor(t2,f2_stft,sdb);
%     set(p, 'EdgeColor', 'none');    % Turn off gtid
%     cc = max(sdb(:))+[-60 0];
%     ax = gca;
%     ax.CLim = cc;
%     view(2)
%     c = colorbar;
%     c.Label.String = 'Amplitude [dB]';
%     len = size(t2,1);
%     xlim([round(1*len/10)*t_length/len round(len-2*len/10)*t_length/len]);
%     ylim([-400 400]);
%     xlabel('Time [s]');
%     ylabel('Frequency [Hz]');
    
end
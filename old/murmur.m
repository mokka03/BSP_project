function pathology = murmur(sig,fs,SD)
    %MURMUR Summary of this function goes here
    %   Detailed explanation goes here
    sig = sig(round(length(sig)/10) : round(length(sig)-length(sig)/10));
    SD = SD(round(length(SD)/10) : round(length(SD)-length(SD)/10));
    pathology = 0;
    t_length = length(sig)/fs; % s
    t = linspace(0, t_length, t_length*fs); % s
    %% Filtering
    f1 = 500; % Hz
    f2 = 10; % Hz
    % Filtering out the frequencies above f1 Hz
    [b_low,a_low] = butter(5,f1/(fs/2),'low');
    fsig = filter(b_low,a_low,sig);
    % Filtering out the frequencies under f2 Hz
    [b_high,a_high] = butter(6,f2/(fs/2),'high');
    fsig = filter(b_high,a_high,fsig);
    % freqz(b1,a1);
    %% FFT
%     [f, sig_FFT] = myFFT(sig,fs);
%     [f_filtered, fsig_FFT] = myFFT(fsig,fs);

    %% STFT
    % Short-time Fourier transform
    [s,f2_stft,t2] = stft(fsig,fs,'Window',hann(512));
    sdb = mag2db(abs(s)); % Amplitude spectrum to dB
    
    %% 'Energy'
    E = sdb(509,:);
    for i = (512-128):508 % ~ 20-500 Hz
        E = E + sdb(i,:);
    end

    
    % E sample rate
    fs2 = 1/(t_length/length(E));
    [P,Q] = rat(fs/fs2);
    E = resample(E,P,Q);
    E = E-min(E); % Shift the curve to be positive
    E = E/max(E); % Normalize
    
    % murmur detection
    l = min(length(E),length(SD)); % If E and SD would be different size
    E_SD = E(:,1:l).*SD(:,1:l);
    fprintf('%f\n',sum(E_SD(:,l))*1000/t_length);
%     if sum(E(:,l))/t_length < 1000
%         pathology = 1;
%     end

%     ratio = sum(E(:,1:l).*sounds(:,1:l))/sum(E(:,1:l))

    %% Plot
%     figure(3)
%     % Plot filtered signal
%     subplot(2,1,1)
%     plot(t,fsig/max(fsig));
%     hold on;
%     hold off;
%     % xlim([0 10]);
%     xlim([t(1) t(end)]);
%     xlabel('Time [s]');
%     ylabel('Amplitude [a.u.]');
%     legend('Signal');
%     
%     % Plot filtered FFT
%     subplot(2,1,2)
%     plot(f_filtered,fsig_FFT);
%     xlim([0 600]);
%     xlabel('Frequency [Hz]');
%     ylabel('|A(f)|_{norm} [a. u.]');
%     
%     
%     % Plot the Short-time Fourier spectrum of the filtered signal
%     figure(4)
%     p = pcolor(t2,f2_stft,sdb);
%     set(p, 'EdgeColor', 'none');    % Turn off gtid
%     cc = max(sdb(:))+[-60 0];
%     ax = gca;
%     ax.CLim = cc;
%     view(2)
%     c = colorbar;
%     c.Label.String = 'Amplitude [dB]';
%     % xlim([0 60]);
%     ylim([-600 600]);
%     xlabel('Time [s]');
%     ylabel('Frequency [Hz]');
end


function pathology = murmur2(sig,fs,SD,peaknum)
    %MURMUR2 Summary of this function goes here
    %   Detailed explanation goes here
    pathology = 0;
    %% Filtering
    f1 = 500; % Hz
    f2 = 200; % Hz
    % Filtering out the frequencies above f1 Hz
    [b_low,a_low] = butter(5,f1/(fs/2),'low');
    fsig = filter(b_low,a_low,sig);
    % Filtering out the frequencies under f2 Hz
    [b_high,a_high] = butter(6,f2/(fs/2),'high');
    fsig = filter(b_high,a_high,fsig);
    % freqz(b1,a1);
    
    %% Cut
    fsig = fsig(round(1*length(fsig)/5) : round(length(fsig)-3*length(fsig)/5));
    SD = SD(round(1*length(SD)/5) : round(length(SD)-3*length(SD)/5));
    t_length = length(fsig)/fs; % s
    
    %% Envelope using Hilbert transformation
    fsig_hat = hilbert(fsig);
    analitic = sqrt(fsig.^2 + fsig_hat.^2);
    envelope = abs(analitic);
    envelope = movmean(envelope,200); %30
    envelope = envelope-min(envelope);
    envelope = envelope/max(envelope); % normalize
    
    %% murmur
    envelope_SD = envelope.*SD;
%     fprintf('%f\n',sum(envelope_SD)/length(envelope_SD)*1000);
    if sum(envelope_SD)/length(envelope_SD)*1000 > 20
%     if sum(envelope_SD)/sum(envelope) > 1.5
        pathology = 1;
    end
    %% Plot
%     figure(1)
%     plot(envelope);
%     hold on;
%     plot(envelope_SD,'-.');
%     hold off;
%     legend('env','SD');
    
end


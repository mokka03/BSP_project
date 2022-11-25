function pathology = murmur2(sig,fs,SD,peaknum)
    %MURMUR2 Summary of this function goes here
    %   Detailed explanation goes here
    pathology = 0;
    sig = sig(round(length(sig)/10) : round(length(sig)-length(sig)/10));
    SD = SD(round(length(SD)/10) : round(length(SD)-length(SD)/10));
    t_length = length(sig)/fs; % s
    %% Filtering
    f1 = 200; % Hz
    f2 = 60; % Hz
    % Filtering out the frequencies above f1 Hz
    [b_low,a_low] = butter(5,f1/(fs/2),'low');
    fsig = filter(b_low,a_low,sig);
    % Filtering out the frequencies under f2 Hz
    [b_high,a_high] = butter(6,f2/(fs/2),'high');
    fsig = filter(b_high,a_high,fsig);
    % freqz(b1,a1);
    
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
%     figure(1)
%     plot(envelope);
%     hold on;
%     plot(envelope_SD,'-.');
%     hold off;
%     legend('env','SD');
    
end


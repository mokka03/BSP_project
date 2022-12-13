function [y] = getLabels(tlabels,fs,t_length)
    %GETLABELS 
    % Get the labels to the signal as an array
    
    % Inputs:
    % tlabels: Labels from the .tsv files as a table
    % fs: Sampling frequency
    % t_length: Length of the signal in s
    
    % Outputs:
    % y: Label mask as an array

    labels = table2array(tlabels);
    length = t_length*fs; % number of data points
    y = zeros(1,length);
    for i = 1:size(labels,1)
        t0 = labels(i,1);
        if t0 == 0 t0 = 1/fs; end
        t1 = labels(i,2);
        sound = labels(i,3);
        y(round(t0*fs):round(t1*fs)) = sound;
    end
end


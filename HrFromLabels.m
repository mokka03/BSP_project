% https://matlab.fandom.com/wiki/FAQ#How_can_I_process_a_sequence_of_files.3F
clear all;

wavfiles = dir(['data\normal\' '*.wav']);
fs = 4000; % Hz
figure(5)
for file = wavfiles'
    fprintf(1, 'Doing something with %s.\n', file.name);
    
    sig = audioread(strcat("data/normal/", file.name))';
    tlabels = readtable(strcat("data/normal/", file.name(1:end-4), ".tsv"),"FileType","text","Delimiter","tab");
    
%     fileName = '85031_TV';
%     sig = audioread(strcat("data/murmur/", fileName, ".wav"))';
%     tlabels = readtable(strcat("data/murmur/", fileName, ".tsv"),"FileType","text","Delimiter","tab");
    
    t_length = length(sig)/fs; % s
    t = linspace(0, t_length, t_length*fs); % s
    
    labelArray = getLabels(tlabels,fs,t_length);
    labelArray = labelArray(labelArray > 0);
    % % S1
    labelS1 = labelArray;
    labelS1(labelS1 > 1) = 0;
    [pks, locs] = findpeaks(labelS1,'MinPeakDistance',0.17*fs);
    HeartRate = 1/((locs(end)-locs(1))/fs/size(locs,2))*60
    
    
    plot(labelS1);
    hold on;
    plot(locs,pks,'.');
    hold off;
end
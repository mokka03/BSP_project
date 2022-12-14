clear all;

dirName = 'data\murmur\';
% dirName = 'data\murmur\';
% https://matlab.fandom.com/wiki/FAQ#How_can_I_process_a_sequence_of_files.3F
wavfiles = dir([dirName '*.wav']); % Get the files from the folder
fs = 4000; % Hz

HR = HrFromCsv("data\HR_murmur.csv");
HR{1,3} = 0;    % Just to create a nwe column in the table
HR.Properties.VariableNames = ["Signal","HR","HR from labels"];


figure(5)

%%
for file = wavfiles' % Iterate through the files of the folder
    fprintf(1, 'Doing something with %s.\n', file.name);
    
    % Read input
    sig = audioread(strcat(dirName, file.name))';
    tlabels = readtable(strcat(dirName, file.name(1:end-4), ".tsv"),"FileType","text","Delimiter","tab");
    
    % Create time axis
    t_length = length(sig)/fs; % s
    t = linspace(0, t_length, t_length*fs); % s
    
    % Get the labels as an array
    labelArray = getLabels(tlabels,fs,t_length);
    labelArray = labelArray(labelArray > 0);
    
    % S1 detection
    labelS1 = labelArray;
    labelS1(labelS1 > 1) = 0;
    [pks, locs] = findpeaks(labelS1,'MinPeakDistance',0.17*fs);
    
    % Calculate heart rate
    HeartRate = 1/((locs(end)-locs(1))/fs/size(locs,2))*60;
    
    % Writ heart rate data into the table
    for i = 1:length(wavfiles)
        if file.name(1:end-4) == HR{i,1}
            HR{i,3} = HeartRate;
        end
    end
    
    % Plot
    plot(labelS1);
    hold on;
    plot(locs,pks,'.');
    hold off;
end

% writetable(HR, "data/HR_murmur.xls")
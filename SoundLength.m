clear all;

% Choose directory: normal or murmur
% dirName = 'data\normal\';
dirName = 'data\murmur\';

% https://matlab.fandom.com/wiki/FAQ#How_can_I_process_a_sequence_of_files.3F
wavfiles = dir([dirName '*.wav']); % Get the files from the directory
fs = 4000; % Hz

% Create array for the result
HrVsSound = zeros(length(wavfiles),3);
i = 1;

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
    labelS1(labelS1 ~= 1) = 0;
    [pks, locs] = findpeaks(labelS1,'MinPeakDistance',0.17*fs);
    
    % Calculate heart rate
    HeartRate = 1/((locs(end)-locs(1))/fs/size(locs,2))*60;
    
    % Calculate average length of S1 sound
    S1 = labelS1(labelS1 > 0);  % Contains only the S1 part of the labaels
    S1_length = length(S1)/fs/length(locs);
    
    % Calculate average length of S1 sound
    labelS2 = labelArray;
    labelS2(labelS2 ~= 3) = 0;
    [pks2, locs2] = findpeaks(labelS2,'MinPeakDistance',0.17*fs);
    S2 = labelS2(labelS2 > 0);  % Contains only the S1 part of the labaels
    S2_length = length(S2)/fs/length(locs);
    
    % Store result
    HrVsSound(i,:) = [HeartRate S1_length S2_length];
    i = i+1;
end

%%
HrVsSound = sortrows(HrVsSound,1);  % Ascending order based on HR

% Correlation of HR and sound length
R1 = corrcoef(HrVsSound(:,1),HrVsSound(:,2));
R2 = corrcoef(HrVsSound(:,1),HrVsSound(:,3));

% Average of heart sound length
S1_av = mean(HrVsSound(:,2));
S2_av = mean(HrVsSound(:,3));

figure(6)
xlabel('Patient');
yyaxis left
plot(HrVsSound(:,1));
ylabel('[bpm]');

yyaxis right
plot(HrVsSound(:,2),'--');
hold on;
plot(HrVsSound(:,3),'.-');
hold off;
ylabel('Time [s]');
legend('Heart rate','S1 length','S2 length')
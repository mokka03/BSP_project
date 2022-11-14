% % Get the state transition matrix of the Hidden Markov model
clear all;
tlabels = readtable("data/normal/85033_TV.tsv","FileType","text","Delimiter","tab");

labels = table2array(tlabels);
t_length = 21.088; % s
fs = 4000; % Hz
length = t_length*fs; % number of data points
t = linspace(0, t_length, t_length*fs); % s
y = zeros(1,length);
for i = 1:size(labels,1)
    t0 = labels(i,1);
    if t0 == 0 t0 = 1/fs; end
    t1 = labels(i,2);
    sound = labels(i,3);
    y(round(t0*fs):round(t1*fs)) = sound;
end
%%
figure(4)
plot(t,y)

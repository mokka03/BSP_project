% BSP final project
clear all;

%% Load data
sig = audioread("data/normal/85033_TV.wav")';
labels = readtable("data/normal/85033_TV.tsv","FileType","text","Delimiter","tab");
fs = 4000; % Hz
t_length = length(sig)/fs; % s
t = linspace(0, t_length, t_length*fs); % s

%% FFT



%% Plot
figure(1)
plot(t,sig);
%% EXAMPLE
clear all; close all;
%% Single file
sig = audioread("data/normal/85033_TV.wav");
labels = readtable("data/normal/85033_TV.tsv","FileType","text","Delimiter","tab");

props = project_run(sig);
%% Folder
folder = 'data/normal/';
[props_n,labels_n] = run_for_folder(folder);
folder = 'data/murmur/';
[props_m,labels_m] = run_for_folder(folder);

props = [props_n,props_m];
labels = [labels_n;labels_m];
%%
[hit_percent,miss_percent,multihit_percent,hrdiff_percent,ibsegdiff_percent,Se,Sp] = ...
    calc_score(props,props,labels);

avg_percent = mean([hit_percent;miss_percent;multihit_percent;hrdiff_percent;ibsegdiff_percent]);
avg_hit_percent = avg_percent(1);
avg_miss_percent = avg_percent(2);
avg_multihit_percent = avg_percent(3);
avg_hrdiff_percent = avg_percent(4);
avg_ibsegdiff_percent = avg_percent(5);
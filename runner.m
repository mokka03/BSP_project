%% EXAMPLE
clear all; close all;
%% Single file
% sig = audioread("data/normal/85033_TV.wav");
% labels = readtable("data/normal/85033_TV.tsv","FileType","text","Delimiter","tab");
% 
% props = project_run(sig);
%% Folder

% Normal signals
folder = 'data/normal/';
fprintf('%s\n',['Processing ' folder ' ...']);
[props_n,labels_n,hr_n] = run_for_folder(folder);

% Murmur signals
folder = 'data/murmur/';
fprintf('%s\n',['Processing ' folder ' ...']);
[props_m,labels_m,hr_m] = run_for_folder(folder);

props = [props_n,props_m];
labels = [labels_n;labels_m];
hrs = [hr_n;hr_m];

%setting ground truth array
pathology = zeros(1,length(hrs));
pathology(51:end) = 1;

%clearing variables
clear temp
clear props_true

%setting up the ground truth struct array
for k=1:length(hrs)
    temp.HR = hrs(k);
    temp.pathology = pathology(k);
    props_true(k) = temp;
end
%% Calculation
[hit_percent,miss_percent,multihit_percent,hrdiff_percent,ibsegdiff_percent,Se,Sp] = ...
    calc_score(props,props_true,labels);

avg_percent = mean([hit_percent;miss_percent;multihit_percent;hrdiff_percent;ibsegdiff_percent],2);
avg_hit_percent = avg_percent(1);
avg_miss_percent = avg_percent(2);
avg_multihit_percent = avg_percent(3);
avg_hrdiff_percent = avg_percent(4);
avg_ibsegdiff_percent = avg_percent(5);
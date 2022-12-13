function [hit_percent,miss_percent,multihit_percent,hrdiff_percent,ibsegdiff_percent,Se,Sp] = calc_score(props_predict,props_true,labels)
%CALC_SCORE Evaluate your submission
%   Input:
%       props_predict   - predicted properties (struct)
%       props_true      - ground truth properties (struct)
%       labels          - heart cycle labels (cell)
%
%   Output:
%       hit/miss/multihit_percent      - found/missed/multi-detection heartsound (percent)
%       hrdiff_percent                 - heartrate error (percent)
%       ibsegdiff_percent              - inbetween segment overlap error (percent)
%       Se/Sp                          - sensitivity/specificity

conf = [0,0;
        0,0];
for k=1:length(labels)
    ids = cell2mat(labels{k}(:,3));
    starts = cell2mat(labels{k}(:,1));
    stops = cell2mat(labels{k}(:,2));
    
    % S_loc test
    % hit/miss/multihit
    s1s = starts(ids==1 | ids==3)*4000;
    s1e = stops(ids==1 | ids==3)*4000;
    hit=0; miss=0; multi=0;
    for kk=1:length(s1s)
        s = sum(s1s(kk)<=props_predict(k).S_loc);
        e = sum(s1e(kk)>=props_predict(k).S_loc);
        if s>0 && e>0
            hit=hit+1;
            if s>1 || e>1
                multi=multi+1;
            end
        else
            miss=miss+1;
        end
    end

    hit_percent(k) = hit/length(s1s) *100;
    miss_percent(k) = miss/length(s1s) *100;
    multihit_percent(k) = multi/hit *100;

    % HR test
    hrdiff = abs(props_predict(k).HR - props_true(k).HR);
    hrdiff_percent(k) = props_true(k).HR/hrdiff *100;

    % ib_seg test
    ibsegdiff = sum(abs(props_predict(k).ib_seg - props_true(k).ib_seg));
    ibsegdiff_percent(k) = sum(props_true(k).ib_seg)/ibsegdiff *100;

    % pathology test
    x = abs(props_predict(k).pathology-1)+1;
    y = abs(props_true(k).pathology-1)+1;
    conf(x,y) = conf(x,y)+1;
end
Se = conf(1,1)/(conf(1,1)+conf(2,1));
Sp = conf(2,2)/(conf(1,2)+conf(2,2));
end
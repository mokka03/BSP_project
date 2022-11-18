function [HeartRate] = getHeartRate(envelope,locs,fs)
%GETHEARTRATE Get heart rate
%   The idea here is that we need only the S1 and S2 noises if we want to
%   calculate the heart rate.
%   We assume that we have all of S1 and S2 sounds, none of them is
%   missing.

% Cut down the beginning and end, just to get rid of noisy part
start_ = round(size(envelope,2)/5);
end_ = start_*4;
locs_short = locs(locs>start_); % Peak locations after start_
locs_short = locs_short(locs_short<end_); % Peak locations between start_ and end_

% Calculate the time of a heart cycle
peak_num = size(locs_short,2);
if  rem(peak_num, 2) == 0
    tCycle = (locs_short(end)-locs_short(1))/peak_num*2;
else
    tCycle = (locs_short(end-1)-locs_short(1))/(peak_num-1)*2;
end

% Calculate heart rate
HeartRate = (1/tCycle)*fs;
HeartRate = HeartRate*60;

end


function properties = project_run(signal)
    %PROJECT_RUN This should be the main function of your project.
    %   Input: PCG signal (fs: 4000 Hz)
    %   Output: properties struct
    %           S_loc:      heartsound locations (samples)
    %           HR:         heartrate (bpm)
    %           ib_seg:     systole/diastole regions (binary mask, 1-s at given samples)
    %           pathology:  normal/murmur (0-normal, 1-murmur)
    properties.S_loc = [];
    properties.HR = 0;
    properties.ib_seg = [];
    properties.pathology = 0;

    properties.len = length(signal);
end
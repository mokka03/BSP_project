function [props,labels,HRFromTable] = run_for_folder(folder)
%RUN_FOR_FOLDER Runs your project_run function for all files in a folder
%   Requires that the wav and tsv files have the same name

    files = dir([folder '*.wav']);
    files = struct2table(files);
    
    i = strfind(folder,'/');
    folder_name = folder(i(1)+1:end-1); % 'normal' or 'murmur'
    hr_table = readtable(['data/HR_' folder_name '.csv']);
    
    HRFromTable = zeros(length(files.name),1);

    for k=1:length(files.name)
        % Run for signal
        fname = files.name(k);
        fname = [fname{:}];
        sig = audioread([folder fname]);
        lab = readtable([folder fname(1:end-4) '.tsv'],"FileType","text","Delimiter","tab");
        lab = table2cell(lab);
        labels{k,:} = lab;
%         fprintf('%s\n',fname);
        props(k) = project_run(sig);
        
        % Get HR from table
        fnameStr = convertCharsToStrings(fname);
        fnameStr = erase(fnameStr,".wav");
        temp = hr_table.Signal==fnameStr;
        hr = table2array(hr_table(temp,2));
        HRFromTable(k) = hr;
    end

end
function [props,labels,hr_truth] = run_for_folder(folder)
%RUN_FOR_FOLDER Runs your project_run function for all files in a folder
%   Requires that the wav and tsv files have the same name

    files = dir([folder '*.wav']);
    files = struct2table(files);
    HR_m = HrFromCsv("data\HR_murmur.csv"); % murmur heart rate from csv file
    HR_n = HrFromCsv("data\HR_normal.csv"); % normal heart rate from csv file
    HR = union(HR_n,HR_m);
    hr_truth = zeros(1,length(files.name));
    for k=1:length(files.name)
        fname = files.name(k);
        fname = fname{:};
        sig = audioread([folder fname]);
        lab = readtable([folder fname(1:end-4) '.tsv'],"FileType","text","Delimiter","tab");
        lab = table2cell(lab);
        labels{k,:} = lab;
        props(k) = project_run(sig);
        hr_truth(k) = HR.HR(HR.Signal == fname(1:end-4));
        fprintf('%s\n',fname);
%         fprintf('%d\n',hr_truth);
%         saveas(gcf,strcat('figure/murmur',num2str(k),".png"))
    end

end
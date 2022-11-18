function HRnormal = HrFromCsv(filename, dataLines)
%IMPORTFILE Import data from a text file
%  HRNORMAL = IMPORTFILE(FILENAME) reads data from text file FILENAME
%  for the default selection.  Returns the data as a table.
%
%  HRNORMAL = IMPORTFILE(FILE, DATALINES) reads data for the specified
%  row interval(s) of text file FILENAME. Specify DATALINES as a
%  positive scalar integer or a N-by-2 array of positive scalar integers
%  for dis-contiguous row intervals.
%
%  Example:
%  HRnormal = importfile("C:\Users\mauch\Desktop\2_f�l�v\BSP\Project\data\HR_normal.csv", [2, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 18-Nov-2022 15:32:38

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ";";

% Specify column names and types
opts.VariableNames = ["Signal", "HR"];
opts.VariableTypes = ["string", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Signal", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Signal", "EmptyFieldRule", "auto");

% Import the data
HRnormal = readtable(filename, opts);

end
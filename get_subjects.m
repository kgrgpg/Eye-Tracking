function[] = get_subjects(in_data, out_data, subjects)
% Get subset of subjects needed from the in_data file (.csv)
% and save them into out_data file (.mat)
%
% in_data  - input .csv file with the samples from all the subjects
% subjects - subset of wanted subjects
% out_data - output .mat file where the data of wanted subjects are saved

% boolean values in the file that need to be converted to 0 or 1
bool = {'false' 'true'};

% open the file, scan its lines and close it
fid = fopen(in_data);
train = textscan(fid, '%s', 'delimiter', '\n', 'BufSize', 524288);
fclose(fid);

% flatten 1 x 1 cell array to n_all_subjects x 1 cell array
train = train{:};
% prepare cell arrays and matrices for the data we actually need
% sid       cell array with sid strings
% known     binary list that indicates, whether the object was found (1)
%           or not (0)
% pts       N x 2 array of x, y coordinates of N points in 1 path
sid = {};
known = [];
pts = {};

% for each line of the input file
for i = 1:length(train)
    % scan the line
    line = textscan(train{i}, '%s', 'delimiter', ',');
    % flatten cell array
    line = line{:};
    
    % if the line belongs to 1 of our wanted subjects, add the data
    if ismember(line(1), subjects)
        sid{end+1} = line{1};
        known = [known find(strcmp(bool, line(2))) - 1];
        nums = str2double(line(3:end));
        pts{end+1} = horzcat(nums(1:2:end), nums(2:2:end));        
    end
    
end

% save into the mat file
save(out_data, 'sid', 'known', 'pts');

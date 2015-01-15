%
% Project - Eye Tracking 2014 
% Eye-tracking data analysis
%
% Date: 19. 5. 2014
% Group: C
% Group Members:
%   Filip Povolny   filipp@student.uef.fi
%   Keshav Gupta    keshav.pg@gmail.com
%   Kritika Katwal  yeskritika@gmail.com
%   Sami Pietinen   sami.pietinen@uef.fi

clear all; clc; close all;

data_all = 'train.csv';             % input file with all the subjects
data_in = 'train_s15-s20.mat';      % input file with subjects s15-s20
data_out = 'mfd_msa_s15-s20.csv';   % output file with mfd and msa values
subjects = {'s15' 's16' 's17' ...   % subject IDs for our group
    's18' 's19' 's20'};

% extract samples just from wanted subjects
% (if not already extrated)
if ~exist(data_in, 'file')
    get_subjects(data_all, data_in, subjects);
end

% load input data
load(data_in);

dx = 97;    % units per angle in x dimension
dy = 56;    % units per angle in y dimension

% initialize saccade cell array
sacc = {length(sid)};
mfd = zeros(1, length(sid));
msa = zeros(1, length(sid));

% for each sample
% problematic = [29 34 54 56 60 93 116 125];
for i = 1:length(sid)
    % get the points (xi, yi) in degrees
    p = pts{i};
    p(:,1) = p(:,1) ./ dx;
    p(:,2) = p(:,2) ./ dy;
    % detect saccades
    [sacc{i}, vel, iva] = get_saccades(p);
    [mfd(i), msa(i)] = get_mfd_msa(sacc{i}, iva);
end

% save the results into csv file
save_results(sid, known, mfd, msa, data_out);

% plot 'em!
plot_results(data_out);








function[] = save_results(sid, known, mfd, msa, data_out)
% Saves Mean Fixation Duration (MFD) & Mean Saccade Amplitude (MSA),
% including their standard deviations (MFD_SD & MSA_FD) into a csv file.
%
% sid       List of the Subject IDs for each of N paths
% known     Binary list that indicates, whether the object was found (1)
%           or not (0) for each of N paths
% mfd       List of the MFDs for each of N paths
% msa       List of the MSAs for each of N paths
% data_out  Name of the output csv file, where data are stored in format:
%           sid MFD_known MFD_known_SD MFD_unknown MFD_unknown_SD ...
%               MSA_known MSA_known_SD MSA_unknown MSA_unknown_SD ...
%               MFD_overall MFD_overall_SD MSA_overall MSA_overall_SD

% get unique subject IDs
subjects = unique(sid);
% number of subjects, in our case = 6
n_subjects = length(subjects);

% prepare matrices for mfd & msa and their standard deviations
% n_subjects x 3 matrix:
%   1st col: known
%   2nd col: unknown
%   3rd col: overall
s_mfd_mean = zeros(n_subjects, 3);
s_mfd_std = zeros(n_subjects, 3);
s_msa_mean = zeros(n_subjects, 3);
s_msa_std = zeros(n_subjects, 3);

% open the file for writing
fid = fopen(data_out, 'wt');

% for each subject
for i = 1:n_subjects;
    s = subjects{i};
    % get indices of his/her paths
    s_idx = strcmp(sid, s) == 1;
    
    % compute mfds & mfd_sds for known, unknown & overall
    s_mfd_mean(i,1) = mean(mfd(s_idx & known==1));
    s_mfd_mean(i,2) = mean(mfd(s_idx & known==0));
    s_mfd_mean(i,3) = mean(mfd(s_idx));
    s_mfd_std(i,1) = std(mfd(s_idx & known==1));
    s_mfd_std(i,2) = std(mfd(s_idx & known==0));
    s_mfd_std(i,3) = std(mfd(s_idx));
    % compute msas & msa_sds for known, unknown & overall
    s_msa_mean(i,1) = mean(msa(s_idx & known==1));
    s_msa_mean(i,2) = mean(msa(s_idx & known==0));
    s_msa_mean(i,3) = mean(msa(s_idx));
    s_msa_std(i,1) = std(msa(s_idx & known==1));
    s_msa_std(i,2) = std(msa(s_idx & known==0));
    s_msa_std(i,3) = std(msa(s_idx));
    
    % write into the file
    fprintf(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f\n', s, ...
        s_mfd_mean(i,1), s_mfd_std(i,1), ...
        s_mfd_mean(i,2), s_mfd_std(i,2), ...
        s_msa_mean(i,1), s_msa_std(i,1), ...
        s_msa_mean(i,2), s_msa_std(i,2), ...
        s_mfd_mean(i,3), s_mfd_std(i,3), ...
        s_msa_mean(i,3), s_msa_std(i,3));
end

% close the file
fclose(fid);


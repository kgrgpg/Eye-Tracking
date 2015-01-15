function[] = plot_results(data_out)
% Plots Mean Fixation Duration (MFD) & Mean Saccade Amplitude (MSA),
% including their standard deviations (MFD_SD & MSA_FD):
% Separately for each subject: known, unknown & overall
% Agregated for all subjects: known, unknown & overall
%
% data_out  Name of the input csv file, where data are stored in format:
%           sid MFD_known MFD_known_SD MFD_unknown MFD_unknown_SD ...
%               MSA_known MSA_known_SD MSA_unknown MSA_unknown_SD ...
%               MFD_overall MFD_overall_SD MSA_overall MSA_overall_SD

% read the csv file with mfd & msa data
fid = fopen(data_out);
data = textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f');
fclose(fid);

% set nice colormap
cm = colormap([0.2 0.8 0.4; 0.9 0.2 0.2; 0.2 0.4 0.9]);
% get subject IDs
subjects = data{1};
% number of subjects, our case = 6
n_subjects = length(subjects);

% get mdfs & msas from data
s_mfd_mean = [data{2} data{4} data{10}];
s_mfd_std = [data{3} data{5} data{11}];
s_msa_mean = [data{6} data{8} data{12}];
s_msa_std = [data{7} data{9} data{13}];

% modified x coordinates for plotting standard error of mean
s_x = zeros(n_subjects, 3);
% like sid, but just numbers (without 's')
s_nums = zeros(n_subjects, 1);
% find out those
for i = 1:n_subjects;
    s = subjects{i};
    s_nums(i) = sscanf(s, 's%d');
    s_x(i,:) = [s_nums(i)-0.22 s_nums(i) s_nums(i)+0.22];
end

% plot known, unknown & overall mfds in one chart
ax(1) = subplot(211);
bar(s_nums, s_mfd_mean); hold on;
errorbar(s_x, s_mfd_mean, s_mfd_std, 'k.'); hold off;
ylabel('MFD [ms]');

% plot known, unknown & overall msas in other chart
ax(2) = subplot(212);
ln = bar(s_nums, s_msa_mean); hold on;
errorbar(s_x, s_msa_mean, s_msa_std, 'k.'); hold off;
ylabel('MSA [deg]');

xlabel('Subject ID');
linkaxes(ax, 'x');
legend(ln, 'known', 'unknown', 'overall');
set(ax, 'YGrid', 'on', 'XTickLabel', subjects);

% in another figure, plot aggregated mfd & msa for known, unknown & overall
figure('Name', 'MFD & MSA of all subjects aggregated');

% mfd
ax(1) = subplot(121);
bar(0, mean(s_mfd_mean(:,1)), 'FaceColor', cm(1,:)); hold on;
errorbar(0, mean(s_mfd_mean(:,1)), std(s_mfd_mean(:,1)), 'k.');
bar(1, mean(s_mfd_mean(:,2)), 'FaceColor', cm(2,:));
errorbar(1, mean(s_mfd_mean(:,2)), std(s_mfd_mean(:,2)), 'k.');
bar(2, mean(s_mfd_mean(:,3)), 'FaceColor', cm(3,:));
errorbar(2, mean(s_mfd_mean(:,3)), std(s_mfd_mean(:,3)), 'k.'); hold off;
ylabel('Aggregated MFD [ms]');

% msa
ax(2) = subplot(122);
bar(0, mean(s_msa_mean(:,1)), 'FaceColor', cm(1,:)); hold on;
errorbar(0, mean(s_msa_mean(:,1)), std(s_msa_mean(:,1)), 'k.');
bar(1, mean(s_msa_mean(:,2)), 'FaceColor', cm(2,:));
errorbar(1, mean(s_msa_mean(:,2)), std(s_msa_mean(:,2)), 'k.');
bar(2, mean(s_msa_mean(:,3)), 'FaceColor', cm(3,:));
errorbar(2, mean(s_msa_mean(:,3)), std(s_msa_mean(:,3)), 'k.'); hold off;
ylabel('Aggregated MSA [deg]');
set(ax, 'YGrid', 'on', 'Xtick', 0:2, ...
    'XTickLabel', {'known' 'unknown' 'overall'});

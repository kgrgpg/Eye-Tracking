function[sacc, vel, iva] = get_saccades(p)
    % Detect saccades from sequence of points (x, y - coordinates)
    %
    % p     vector of size N with x,y coordinates of the screen in degrees
    % sacc  binary vector of size N-1 with classifies the points as:
    %           1 - saccade or
    %           0 - fixation
    % vel   vector of size N-1 with velocities [deg/s]
    % iva   vecoter of size N-1 with instantanous visual angles [deg]
    
    Fs = 1000;              % sampling rate
    h = [1 2 3 2 1];        % velocity filter
    %h = [1 2 3 4 3 2 1];    % velocity filter
    h = h ./ sum(abs(h));   % normalization of velocity filter
    vel_max = 1000;         % maximum velocity
    noise_amp = 100;        % threshold parameter - noise amplitude
    
    % compute instantanous visual angles:
    % euclidean distance between subsequent points
    iva = sqrt(sum((p(2:end, :) - p(1:end-1, :)) .^2, 2));
    % filter IVAs with velocity filter h
    vel = conv(iva, h, 'same') .* Fs;
    % clip the impossible velocities
    vel(vel > vel_max) = vel_max;
    
    % compute saccade peak threshold for saccade peaks detection
    sacc_peak_thres = mean(vel(vel < noise_amp)) + ...
        3 * std(vel(vel < noise_amp));
    % compute saccade onset threshold for detection of the start of
    % saccades
    sacc_onset_thres = mean(vel(vel < noise_amp)) + std(vel(vel < noise_amp));
    % set the saccade offset threshold equal to saccade onset threshold for
    % deterction of the end of the saccade
    sacc_offset_thres = sacc_onset_thres;
    
    % initialize binary vector with classification of the velocities either
    % as saccades (1) or fixations (0)
    sacc = zeros(1, length(vel));
    % consider all the velocities higher than peak velocity threshold as
    % saccade peaks
    sacc(vel >= sacc_peak_thres) = 1;
    
%     plot(find(sacc==0), vel(sacc==0), 'r.'); hold on;
%     plot(find(sacc==1), vel(sacc==1), 'b.');
%     plot(1:length(vel), sacc_peak_thres, 'k'); hold off;
%     ylabel('Velocity [deg/s]');
%     xlabel('t [ms]');
%     legend('Fixation', 'Saccade', 'Saccade Peak Threshold');
        
    % for each saccade peak, find its
    %
    % 1) 1st point and scan velocity backwards to find the start of the
    % saccade = velocity that is lower than saccade onset threshold and
    % the previous velocity is higher than the current one
    %
    % 2) last point and scan velocity forwards to find the end of the
    % saccade = velocity that is higher than saccade offset threshold and
    % the following velocity is higher that the current one
    j = 2;
    while j <= length(sacc)
        % 1st point of the saccade peak
        if sacc(j-1) == 0 && sacc(j) == 1
            sacc_onset = j; 
            while sacc_onset > 1 && ...
                (vel(sacc_onset-1) > sacc_onset_thres || ...
                vel(sacc_onset-1) < vel(sacc_onset))
                sacc_onset = sacc_onset - 1;
            end
            sacc(sacc_onset:j) = 1;
        end
        % saccade_offset
        if (sacc(j-1) == 1 && sacc(j) == 0)
            sacc_offset = j;
            while sacc_offset < length(vel) && ...
                (vel(sacc_offset) > sacc_offset_thres || ...
                vel(sacc_offset-1) > vel(sacc_offset))
                    sacc_offset = sacc_offset + 1;
            end
            sacc(j:sacc_offset-1) = 1;
        end
        j = j + 1;
    end
    
%     % plot 'em!
%     figure();
%     plot(p(:,1), p(:,2));
%     xlabel('x [deg]');
%     ylabel('y [deg]');
%     figure();
%     plot(1:length(iva), iva);
%     ylabel('Instantaneous Visual Angle [deg]');
%     xlabel('t [ms]');
%     figure();
%     plot(1:length(vel), vel);
%     ylabel('Velocity [deg/s]');
%     xlabel('t [ms]');
%     figure();
%     plot(find(sacc==0), vel(sacc==0), 'r.'); hold on;
%     plot(find(sacc==1), vel(sacc==1), 'b.');
%     plot(1:length(vel), sacc_onset_thres, 'k'); hold off;
%     ylabel('Velocity [deg/s]');
%     xlabel('t [ms]');
%     legend('Fixation', 'Saccade', 'Saccade Onset/Offset Threshold');
%     figure();
%     plot(p(sacc==0,1), p(sacc==0,2), 'r.'); hold on;
%     plot(p(sacc==1,1), p(sacc==1,2), 'b.'); hold off;
%     xlabel('x [deg]');
%     ylabel('y [deg]');
%     legend('Fixation', 'Saccade');
%     pause;

    
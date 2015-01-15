function[mfd, msa] = get_mfd_msa(sacc, iva)
    % For Instantanous Visual Angles (IVAs) classified as saccades
    % or fixations compute:
    % Mean Fixation Duration (MFD):
    %   Average time spent in a fiaxtion = time spent in all fixations
    %   divided by number of fixations.
    % Mean Saccade Amplitude (MSA):
    %   Angular distance, that eye travels in a saccade = angular distance
    %   of all saccades divided by the number of saccades
    
    % MFD
    d = diff([1 sacc 1]);
    mfd = mean(find(d==1) - find(d==-1));
    
    %MSA
    d = diff([0 sacc 0]);
    n_sacc = length(find(d==-1) - find(d==1));
    msa = sum(iva(sacc==1)) / n_sacc;
    
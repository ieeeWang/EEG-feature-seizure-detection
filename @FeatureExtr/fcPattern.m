function results=fcPattern(obj, settings, inEEG)

% calculate parameters for analysis
windowSize = settings.T * settings.fs;  % [samples]
stepSize   = settings.dT * settings.fs; % [samples]

%% devide EEG into subbands and compute the analytical signal
analitEEG = single(extractBandFFT2008( obj, inEEG, settings, 'analit'));

%% initialization 
EEGLength = size(inEEG,2);
nWindows = floor((EEGLength - windowSize) / stepSize) + 1;
nBands = size(settings.subbands,1);
nCh = size(inEEG,1);
pairs = nchoosek(1:nCh, 2);
nPairs = size(pairs,1);
PLI = zeros(nWindows, nPairs, nBands, 'single');

PLI_matrix = zeros(nCh);
FC_pattern = zeros(nCh, nWindows, nBands, 'single');
SIG = zeros(nCh, nWindows, nBands, 'single');

%% 
    for subband_index = 1: nBands
        for pair_index = 1: nPairs
            ch1 = pairs(pair_index, 1);
            ch2 = pairs(pair_index, 2);
            % compute PLI for ch1, ch2, subband and for given epoch
            s1 = analitEEG(ch1,:, subband_index);
            s2 = analitEEG(ch2,:, subband_index);
            % compute the smoothed or single-trial phase locking value(S-PLV) [Lachaux. 2000]             
            PLI(pair_index, subband_index) = abs(mean( exp(1i*(angle(s1)-angle(s2))  ) ));
        end    
        %% compute the variance of the analitical signal
        for ch1 = 1:nCh
            SIG(ch1, subband_index) = std(analitEEG(ch1, subband_index));
        end
        %% Compute the FC-pattern for a single subband
        % first translate PLIs into the matrix
        for i = 1:size(pairs,1)
           PLI_matrix(pairs(i,1),pairs(i,2)) = PLI(i, subband_index);
        end
        % and now compute/detect the FC-pattern
        FC_pattern(:, subband_index) = detect_fc_pattern(obj, settings.sensitivity, PLI_matrix);  
        FC_mean(:, subband_index) = sum(sum(PLI_matrix,1),2)/nPairs; % sum of all elements in PLI_matrix

    end  

%% here we have two things ready:
% 1) Set of PLIs: PLI(window_i, pair_i, band_i)
% 2) Set of FC_patterns: FC_pattern(pattern[], window_i, band_i)
% The pairs has been sorted by nchoosek()

%% Compute FC-pattern-based features
% initialize with zeros
f_mean_strength = zeros(size(FC_pattern, 2), size(FC_pattern, 3));
f_max_strength  = zeros(size(FC_pattern, 2), size(FC_pattern, 3));
f_size          = zeros(size(FC_pattern, 2), size(FC_pattern, 3));
f_total_mass    = zeros(size(FC_pattern, 2), size(FC_pattern, 3));

% compute f_size for each subband
f_size = sum(FC_pattern, 1);
f_size = squeeze(f_size);
f_size = f_size';
% compute features for each subband
for subband_index = 1:size(FC_pattern,3)
        plis = get_plis(obj, FC_pattern(:,subband_index), PLI( :,subband_index), pairs);
        plis_less_zeros = plis(plis>0);
        if ( ~isempty(plis_less_zeros) )
            f_mean_strength ( subband_index) =mean(plis_less_zeros);
            f_max_strength ( subband_index) = max(plis_less_zeros);
            f_total_mass ( subband_index) =  sum(plis_less_zeros);
        else
        end
end


% results=[f_size; f_mean_strength; f_max_strength; f_total_mass; FC_mean]';
results=[f_size; FC_mean]';

%% Plot data 
% for measure_index = 1:5
%     switch (measure_index)
%         case 1 
%             data_to_plot = f_size; title_str = 'FC-pattern size';
%         case 2
%             data_to_plot = f_mean_strength; title_str = 'mean strength';
%         case 3
%             data_to_plot = f_max_strength; title_str = 'max strength';
%         case 4 
%             data_to_plot = f_total_mass; title_str = 'total mass';
%         case 5 
%             data_to_plot = std_mean; title_str = 'sigma';
%     end
%     
%     for band_index = 1:nBands %band_index
%         figure(100+measure_index)
%         subplot(nBands,1,band_index);
%         %title('subband');
%         hold on
%         plot(data_to_plot(:,band_index));
%         ylim = get(gca,'ylim');
%         xlim = get(gca,'xlim');
%         legend( [title_str, '; subband: ', num2str(settings.subbands(band_index,:))]);
%         % plot event: start - end
%         plot([(before_seizure)/settings.dT, (before_seizure)/settings.dT], [max(ylim), min(ylim)], '--r'); 
%         plot([(before_seizure+seizure_end-seizure_start)/settings.dT, (before_seizure+seizure_end-seizure_start)/settings.dT], [max(ylim), min(ylim)], '--r'); 
%     end
% end







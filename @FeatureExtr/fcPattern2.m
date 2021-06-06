function results=fcPattern2(obj)
% compute average PLI 

inEEG=obj.data;
settings=obj.setting2;
% devide EEG into subbands and compute the analytical signal
analitEEG = extractBandFFT2008( obj, inEEG, settings, 'analit');
analitEEG = single(analitEEG);

% initialization 
nBands = size(settings.subbands,1);
nCh = size(inEEG,1);
pairs = nchoosek(1:nCh, 2); nPairs = size(pairs,1);

PLI = zeros(nPairs, nBands, 'single');
PLI_matrix = zeros(nCh);
FC_pattern = zeros(nCh, nBands, 'single');

% compute f_size & fc_mean
for subband_index = 1: nBands
    for pair_index = 1: nPairs
        ch1 = pairs(pair_index, 1);
        ch2 = pairs(pair_index, 2);
        % compute PLI for ch1, ch2, subband and for given epoch
        s1 = analitEEG(ch1,:, subband_index);
        s2 = analitEEG(ch2,:, subband_index);
        % compute the smoothed or single-trial phase locking value(S-PLV) [Lachaux. 2000]             
        PLI(pair_index, subband_index) = abs(mean( exp(1i*(angle(s1)-angle(s2)))));
    end    
    % Compute the FC-pattern for a single subband
    % first translate PLIs into the matrix
    for i = 1:size(pairs,1)
       PLI_matrix(pairs(i,1),pairs(i,2)) = PLI(i, subband_index);
    end
    % and now compute/detect the FC-pattern
    FC_pattern(:, subband_index) = detect_fc_pattern(obj, settings.sensitivity, PLI_matrix);  
    FC_mean(:, subband_index) = sum(sum(PLI_matrix,1),2)/nPairs; % sum of all elements in PLI_matrix
end  

% compute f_size for each subband
f_size = sum(FC_pattern, 1);
results=[f_size; FC_mean]'; % [subands*(f1,f2)] (f1:f_size,f2:FC_mean)







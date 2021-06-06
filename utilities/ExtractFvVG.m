function Fv = ExtractFvVG(segments,srate)
% get feature vector (Fv) from the EEG segments in a sliding window
% segments: [ch*samples], (ch>=2).

N=15; % update N if new features are added below!
if isnan(segments)
    Fv=nan(N,1);
else   
    % creat an object
    FE1 = FeatureExtr(segments, srate); % the input has at least 2 Ch

    VG_ch=FE1.FvExtr_VG_multiEEG(); % [ch*15]
    Fv= nanmean(VG_ch,1); % mean value of all channels
    Fv= Fv(:);
end




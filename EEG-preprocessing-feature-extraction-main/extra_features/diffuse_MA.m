function [eeg_featuresMean_segment, eeg_featuresChan_segment] = diffuse_MA(eeg,Fs)

eeg_featuresMean_segment = struct();
eeg_featuresChan_segment = struct();

channels = size(eeg,1);

%loop through channels
for j=1:channels
    x = eeg(j,:)';
    
    for k = 1:(Fs/2 - 1)
        pow(k) = bandpower(x,Fs,[k-1 k]);
    end
    [a, ind] = max(pow);

    eeg_featuresChan_segment.DiffuseNormal(j,1) = ind >=8;
    eeg_featuresChan_segment.DiffuseSlow(j,1) = ind < 8;
end

eeg_featuresMean_segment.DiffuseNormal = mean(eeg_featuresChan_segment.DiffuseNormal);
eeg_featuresMean_segment.DiffuseSlow = mean(eeg_featuresChan_segment.DiffuseSlow);

end

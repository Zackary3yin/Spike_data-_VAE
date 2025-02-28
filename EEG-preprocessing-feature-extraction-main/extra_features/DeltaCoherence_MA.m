function [eeg_featuresMean_segment, eeg_featuresChan_segment] = DeltaCoherence_MA(eeg,Fs)
eeg_featuresMean_segment = struct();
eeg_featuresChan_segment = struct();
channels = size(eeg,1);
nfft = 500;
%loop through channels
for j=1:channels-1
    x = eeg(j,:)';
    x1 = eeg(j+1,:)';

%     nearestpow2(length(x)); % what is this line even doing?
    
    [Cxy, F] = mscohere(x,x1,hanning(nfft),nfft/2,nfft,Fs);
    
    eeg_featuresChan_segment.CONCoherenceDelta(j,1) =  mean(Cxy(find(F >= 0.5 & F<=4)));
    eeg_featuresChan_segment.CONCoherenceAll(j,1) = mean(Cxy);    
end
eeg_featuresMean_segment.CONCoherenceDelta = mean(eeg_featuresChan_segment.CONCoherenceDelta);
eeg_featuresMean_segment.CONCoherenceAll = mean(eeg_featuresChan_segment.CONCoherenceAll);
end

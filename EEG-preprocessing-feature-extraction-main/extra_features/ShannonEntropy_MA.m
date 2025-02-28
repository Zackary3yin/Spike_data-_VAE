function [sig_out,sig_out_chan] = ShannonEntropy_MA(eeg, bin_min, bin_max, binWidth)
eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
channels = size(eeg,1);

%loop through channels
for j=1:channels
    x = eeg(j,:);
    x = x';
    
    [counts,binCenters] = hist(x,[bin_min:binWidth:bin_max]);
    binWidth = diff(binCenters);
    binWidth = [binWidth(end),binWidth]; % Replicate last bin width for first, which is indeterminate.
    nz = counts>0; % Index to non-zero bins
    prob = counts(nz)/sum(counts(nz));
    H = -sum(prob.*log2(prob./binWidth(nz)));
    
    eeg_chan(j).feat = H;
    eeg_chan(j).channel = j;
    
end

sig_out_chan = [eeg_chan.feat];
sig_out = mean([eeg_chan.feat]);
end

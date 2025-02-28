function [sig_out,sig_out_chan] = PhaseLagIndex_MA(eeg)
eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
channels = size(eeg,1);

%loop through channels
for j=1:channels-1
    
    x = eeg(j,:);
    x = x';
    x1 = eeg(j+1,:);
    x1 = x1';
    
    hxi = hilbert(x);
    hxj = hilbert(x1);
    % calculating the INSTANTANEOUS PHASE
    inst_phasei = atan(angle(hxi));
    inst_phasej = atan(angle(hxj));
    out = abs(mean(sign(inst_phasej - inst_phasei)));
    
    eeg_chan(j).feat = out;
    eeg_chan(j).channel = j;
    
end
sig_out_chan = [eeg_chan.feat];
sig_out = mean([eeg_chan.feat]);
end

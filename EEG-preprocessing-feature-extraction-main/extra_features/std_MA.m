function [sig_out,sig_out_chan] = std_MA(eeg)

eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
channels = size(eeg,1);

%loop through channels
for j=1:channels
    x = eeg(j,:);
    x = x';
    
    sstd = std(x);

    
    eeg_chan(j).feat = sstd;
    eeg_chan(j).channel = j;
    %eeg_chan(j).org_set = tmp_EEG.setname;

end
sig_out = mean([eeg_chan.feat]);
sig_out_chan = [eeg_chan.feat];
end
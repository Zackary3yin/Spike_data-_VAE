function [sig_out,sig_out_chan] = DeltatoAlphaRatio_MA(eeg,Fs)

eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
channels = size(eeg,1);

    
%loop through channels
for j=1:channels
    
    x = eeg(j,:);
    x = x';
    
    window=Fs*2;
    noverlap=32;
    h = spectrum.welch('Hamming',window);
    hpsd = psd(h,x,'Fs',Fs);
    Pw = hpsd.Data;
    Fw = hpsd.Frequencies;
    out = bandpower(x,Fs,[8,13])/bandpower(x,Fs,[0.5,4]);

    eeg_chan(j).feat = out;
    eeg_chan(j).channel = j;
end
sig_out = mean([eeg_chan.feat]);
sig_out_chan = [eeg_chan.feat];
end

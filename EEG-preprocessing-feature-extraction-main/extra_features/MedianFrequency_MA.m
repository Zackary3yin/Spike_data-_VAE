function [sig_out,sig_out_chan] = MedianFrequency_MA(eeg,leftcutoff,rightcutoff)
eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
channels = size(eeg,1);

if nargin==2
    rightcutoff = 0.5;
elseif nargin==1
    rightcutoff = 0.5;
    leftcutoff = 0.0;
end

%loop through channels
for j=1:channels
    xV = eeg(j,:);
    xV = xV';
    
    errormsg = [];
    [psV,freqV]=periodogram(xV); 
    MedFreq = [];
    if length((find(isnan(psV))))==0
        d=length(psV(find(freqV<leftcutoff)));
        op=find(cumsum(psV(find(freqV>=leftcutoff)))>0.5*sum(psV(find(freqV>=leftcutoff & freqV<=rightcutoff))));
        if length(op)>0
            MedFreq=freqV(op(1)+d);
        end
    else
        errormsg = 'The periodogram could not be computed or cutoff values are not proper.';
    end
    
    eeg_chan(j).feat = MedFreq;
    eeg_chan(j).channel = j;
end
sig_out = mean([eeg_chan.feat]);
sig_out_chan = [eeg_chan.feat];
end

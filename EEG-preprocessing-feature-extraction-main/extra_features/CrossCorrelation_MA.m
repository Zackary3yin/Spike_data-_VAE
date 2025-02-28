function [siq_out,siq_out_chan]  = CrossCorrelation_MA(eeg,Fs,varargin)
eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
channels = size(eeg,1);

if nargin > 2
    band = varargin{1};
end
%loop through channels
for j=1:channels-1
    x = eeg(j,:);
    x = x';
    x1 = eeg(j+1,:);
    x1 = x1';
    
    [acor,lag] = (xcorr(x,x1));
    [~, uu] = max(abs(acor));
       
    eeg_chan(j).ACOR_MAG = (max(abs(acor)) - mean(abs(acor)))/std(abs(acor));
    eeg_chan(j).ACOR_LAG = lag(uu)/Fs; 
    eeg_chan(j).channel = j;
    
end

ACOR_MAG = mean([eeg_chan.ACOR_MAG]);
ACOR_LAG = mean([eeg_chan.ACOR_LAG]);

siq_out_chan = ['eeg_chan.' band];
siq_out_chan = sprintf('[%s]''',siq_out_chan);
siq_out_chan = eval(siq_out_chan);
siq_out = eval(band);
end

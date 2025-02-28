function [sig_out,sig_out_chan]= regularity_MA(eeg,Fs)
eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
channels = size(eeg,1);

    
%loop through channels
for j=1:channels
    
    x = eeg(j,:);
    x = x';
    
    in_x = x.^2;
    num_wts = Fs/2;
    
    a = 1;
    wts = ones(1,num_wts)/num_wts;
    q = filter(wts,a,in_x);
    %Subsequently, we sorted the values of the smoothed signal in ?descending? order
    q = sort(q,'descend');
    N = length(q);
    u = 1:N;
    %COMPUTE THE REG
    %var(q)
    out = sqrt(sum(u.^2.* q')/(sum(q)*N^2*1/3));
    
    eeg_chan(j).feat = out;
    eeg_chan(j).channel = j;

end
sig_out = mean([eeg_chan.feat]);
sig_out_chan = [eeg_chan.feat];

end

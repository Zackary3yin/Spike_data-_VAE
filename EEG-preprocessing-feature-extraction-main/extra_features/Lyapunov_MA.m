function [sig_out, sig_out_chan] = Lyapunov_MA(eeg,Fs)

eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
channels = size(eeg,1);

TOL = 1.0e-6;
steps_forward = 5;
[nvars ndata]=size(eeg);

dt = 1/Fs;

N2 = floor(ndata/2);
N4 = floor(ndata/4);

for j=1:channels
% calculate lyapunov coefficient of time series
    x = eeg(j,:)';

    exponent = zeros(N4+1,1);
    for i=N4:N2  % second quartile of data should be sufficiently evolved
       %get all points but this one.
       js = setdiff(1:ndata-steps_forward,i);
       %find the index of the nearest neighbor
       [idx] = knnsearch(x(js,:),x);
       indx = js(idx);
       expn = 0.0; % estimate local rate of expansion (i.e. largest eigenvalue)
       for k=1:steps_forward
           if norm(x(i+k,:)-x(indx+k,:))>TOL && norm(x(i,:)-x(indx,:))>TOL
               expn = expn + (log(norm(x(i+k,:)-x(indx+k,:)))-log(norm(x(i,:)-x(indx,:))))/k;
           end
       end
       exponent(i-N4+1)=expn/steps_forward;   
    end
    sum=0;  % now, calculate the overal average over N4 data points ...
    for i=1:N4+1
        sum = sum+exponent(i);
    end
    lam=sum/((N4+1)*dt);  
    % return the average value
    % if lam > 0, then system is chaotic

    eeg_chan(j).feat = lam;

    
end
sig_out = mean([eeg_chan.feat]);
sig_out_chan = [eeg_chan.feat];

end

function [sig_out, sig_out_chan] = HiguchiFD_MA(eeg) 
eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
channels = size(eeg,1);


%loop through channels
for j=1:channels
    serie = eeg(j,:);
    serie = serie';
    
    %% Checking the ipunt parameters:
    Kmax = 10;
    control = ~isempty(serie);
    assert(control,'The user must introduce a series (first inpunt).');
    control = ~isempty(Kmax);
    assert(control,'The user must introduce the Kmax parameter (second inpunt).');

    %% Processing:
    % Composing of the sub-series:
    N = length(serie); 
    X = NaN(Kmax,Kmax,N);
    for k = 1:Kmax
        for m = 1:k
            limit = floor((N-m)/k);
            t = 1;
            for i = m:k:(m + (limit*k))
                X(k,m,t) = serie(i);
                t = t + 1;
            end  
        end
    end

    % Computing the length of each sub-serie:
    L = NaN(1, Kmax);
    for k = 1:Kmax
        L_m = zeros(1,k);
        for m = 1:k
            R = (N - 1)/(floor((N - m)/k) * k);
            aux = squeeze(X(k,m,logical(~isnan(X(k,m,:))))); %We get the sub-serie without the NaNs.
            for i = 1:(length(aux) - 1)
                L_m(m) = L_m(m) + abs(aux(i+1) - aux(i));
            end
            L_m(m) = (L_m(m) * R)/k;
        end
        L(k) = sum(L_m)/k;
    end

    % Finally, we compute the HFD:
    x = 1./(1:Kmax);
    aux = polyfit(log(x),log(L),1);
    HFD = aux(1); %We only want the slope, not the independent term. 
    
    eeg_chan(j).feat = HFD;
    eeg_chan(j).channel = j;
end
sig_out = mean([eeg_chan.feat]);
sig_out_chan = [eeg_chan.feat];

end

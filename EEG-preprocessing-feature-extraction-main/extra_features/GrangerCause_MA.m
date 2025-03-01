function [sig_out,sig_out_chan]  = GrangerCause_MA(eeg,Fs)
eeg_chan = struct('channel',[], 'feat', [],'org_set', []);
channels = size(eeg,1);

%loop through channels
for chan=1:channels-1
    x = eeg(chan,:);
    x = x';
    x1 = eeg(chan+1,:);
    x1 = x1';
    
    out = granger_cause_orig(x,x1 ,0.05,Fs);
    
    eeg_chan(chan).feat = out;
    eeg_chan(chan).channel = chan;
    
end
sig_out_chan = [eeg_chan.feat];
sig_out = mean([eeg_chan.feat]);
end



function [F,c_v] = granger_cause_orig(x,y,alpha,max_lag)
%Make sure x & y are the same length
if (length(x) ~= length(y))
    error('x and y must be the same length');
end

%Make sure x is a column vector
[a,b] = size(x);
if (b>a)
    %x is a row vector -- fix this
    x = x';
end

%Make sure y is a column vector
[a,b] = size(y);
if (b>a)
    %y is a row vector -- fix this
    y = y';
end



%Make sure max_lag is >= 1
if max_lag < 1
    error('max_lag must be greater than or equal to one');
end

%First find the proper model specification using the Bayesian Information
%Criterion for the number of lags of x

T = length(x);

BIC = zeros(max_lag,1);

%Specify a matrix for the restricted RSS
RSS_R = zeros(max_lag,1);

i = 1;
while i <= max_lag
    ystar = x(i+1:T,:);
    xstar = [ones(T-i,1) zeros(T-i,i)];
    %Populate the xstar matrix with the corresponding vectors of lags
    j = 1;
    while j <= i
        xstar(:,j+1) = x(i+1-j:T-j);
        j = j+1;
    end
    %Apply the regress function. b = betahat, bint corresponds to the 95%
    %confidence intervals for the regression coefficients and r = residuals
    [b,bint,r] = regress(ystar,xstar);
    
    %Find the bayesian information criterion
    BIC(i,:) = T*log(r'*r/T) + (i+1)*log(T);
    
    %Put the restricted residual sum of squares in the RSS_R vector
    RSS_R(i,:) = r'*r;
    
    i = i+1;
    
end

[dummy,x_lag] = min(BIC);

%First find the proper model specification using the Bayesian Information
%Criterion for the number of lags of y

BIC = zeros(max_lag,1);

%Specify a matrix for the unrestricted RSS
RSS_U = zeros(max_lag,1);

i = 1;
while i <= max_lag
    
    ystar = x(i+x_lag+1:T,:);
    xstar = [ones(T-(i+x_lag),1) zeros(T-(i+x_lag),x_lag+i)];
    %Populate the xstar matrix with the corresponding vectors of lags of x
    j = 1;
    while j <= x_lag
        xstar(:,j+1) = x(i+x_lag+1-j:T-j,:);
        j = j+1;
    end
    %Populate the xstar matrix with the corresponding vectors of lags of y
    j = 1;
    while j <= i
        xstar(:,x_lag+j+1) = y(i+x_lag+1-j:T-j,:);
        j = j+1;
    end
    %Apply the regress function. b = betahat, bint corresponds to the 95%
    %confidence intervals for the regression coefficients and r = residuals
    [b,bint,r] = regress(ystar,xstar);
    
    %Find the bayesian information criterion
    BIC(i,:) = T*log(r'*r/T) + (i+1)*log(T);
    
    RSS_U(i,:) = r'*r;
    
    i = i+1;
    
end

[dummy,y_lag] =min(BIC);

%The numerator of the F-statistic
F_num = ((RSS_R(x_lag,:) - RSS_U(y_lag,:))/y_lag);

%The denominator of the F-statistic
F_den = RSS_U(y_lag,:)/(T-(x_lag+y_lag+1));

%The F-Statistic
F = F_num/F_den;

c_v = finv(1-alpha,y_lag,(T-(x_lag+y_lag+1)));
end


    
    
    
    



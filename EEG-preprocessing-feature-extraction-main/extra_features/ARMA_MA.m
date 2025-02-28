function [eeg_featuresMean_segment, eeg_featuresChan_segment] = ARMA_MA(eeg,varargin)
eeg_featuresMean_segment = struct();
eeg_featuresChan_segment = struct();

channels = size(eeg,1);

%loop through channels
for j=1:channels
    x = double(eeg(j,:)');
    
    mod{j} = arima(2,0,0);
    arma_mod{j} = estimate(mod{j},x,'Display','off');
    eeg_featuresChan_segment.ARMA_1(j,1) = arma_mod{j}.AR{1};
    eeg_featuresChan_segment.ARMA_2(j,1) = arma_mod{j}.AR{2};    
end
eeg_featuresMean_segment.ARMA_1 = mean(eeg_featuresChan_segment.ARMA_1);
eeg_featuresMean_segment.ARMA_2 = mean(eeg_featuresChan_segment.ARMA_2);
end

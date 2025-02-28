function [eeg_featuresMean_segment, eeg_featuresChan_segment] = AmplitudeFeatures_MA(eeg)
eeg_featuresMean_segment = struct();
eeg_featuresChan_segment = struct();
channels = size(eeg,1);



%loop through channels %% can rremove loop
for j=1:channels
    x = eeg(j,:);
    x = x';

    % TIME FEATURES
    eeg_featuresChan_segment.AmpMax(j,1) = max(abs(x));
    eeg_featuresChan_segment.AmpMean(j,1) = mean(abs(x));
    eeg_featuresChan_segment.AmpMin(j,1) = min(abs(x));
    eeg_featuresChan_segment.AmpVar(j,1) = var(abs(x));
    
    % SPECTRAL FEATURES
    eeg_featuresChan_segment.FourierAmpMax(j,1) = max(abs(fft(x)));
    eeg_featuresChan_segment.FourierAmpMean(j,1) = mean(abs(fft(x)));
    eeg_featuresChan_segment.FourierAmpMin(j,1) = min(abs(fft(x)));
    eeg_featuresChan_segment.FourierAmpVar(j,1) = var(abs(fft(x)));
    
    %% REPEAT FOR DERATIVE OF SIGNAL
    derivx = diff(x);
    % TIME FEATURES
    eeg_featuresChan_segment.DerivAmpMax(j,1) = max(abs(derivx));
    eeg_featuresChan_segment.DerivAmpMean(j,1) = mean(abs(derivx));
    eeg_featuresChan_segment.DerivAmpMin(j,1) = min(abs(derivx));
    eeg_featuresChan_segment.DerivAmpVar(j,1) = var(abs(derivx));
    
    % SPECTRAL FEATURES
    eeg_featuresChan_segment.DerivFourierAmpMax(j,1) = max(abs(fft(derivx)));
    eeg_featuresChan_segment.DerivFourierAmpMean(j,1) = mean(abs(fft(derivx)));
    eeg_featuresChan_segment.DerivFourierAmpMin(j,1) = min(abs(fft(derivx)));
    eeg_featuresChan_segment.DerivFourierAmpVar(j,1) = var(abs(fft(derivx)));
    
    %% TEMPORAL FEATURES FROM EEG_PLOTTING FOLDER
    eeg_featuresChan_segment.LineLengths(j,1) = sum(abs(diff(x))); 
    eeg_featuresChan_segment.Kurtavg(j,1) = mean(kurtosis(x));    
end

eeg_featuresMean_segment.AmpMax = mean(eeg_featuresChan_segment.AmpMax);
eeg_featuresMean_segment.AmpMean = mean(eeg_featuresChan_segment.AmpMean);
eeg_featuresMean_segment.AmpMin = mean(eeg_featuresChan_segment.AmpMin);
eeg_featuresMean_segment.AmpVar = mean(eeg_featuresChan_segment.AmpVar);

eeg_featuresMean_segment.FourierAmpMax = mean(eeg_featuresChan_segment.FourierAmpMax);
eeg_featuresMean_segment.FourierAmpMean = mean(eeg_featuresChan_segment.FourierAmpMean);
eeg_featuresMean_segment.FourierAmpMin = mean(eeg_featuresChan_segment.FourierAmpMin);
eeg_featuresMean_segment.FourierAmpVar = mean(eeg_featuresChan_segment.FourierAmpVar);

eeg_featuresMean_segment.DerivAmpMax = mean(eeg_featuresChan_segment.DerivAmpMax);
eeg_featuresMean_segment.DerivAmpMean = mean(eeg_featuresChan_segment.DerivAmpMean);
eeg_featuresMean_segment.DerivAmpMin = mean(eeg_featuresChan_segment.DerivAmpMin);
eeg_featuresMean_segment.DerivAmpVar = mean(eeg_featuresChan_segment.DerivAmpVar);

eeg_featuresMean_segment.DerivFourierAmpMax = mean(eeg_featuresChan_segment.DerivFourierAmpMax);
eeg_featuresMean_segment.DerivFourierAmpMean = mean(eeg_featuresChan_segment.DerivFourierAmpMean);
eeg_featuresMean_segment.DerivFourierAmpMin = mean(eeg_featuresChan_segment.DerivFourierAmpMin);
eeg_featuresMean_segment.DerivFourierAmpVar = mean(eeg_featuresChan_segment.DerivFourierAmpVar);

eeg_featuresMean_segment.LineLengths = mean(eeg_featuresChan_segment.LineLengths);
eeg_featuresMean_segment.Kurtavg = mean(eeg_featuresChan_segment.Kurtavg);

end

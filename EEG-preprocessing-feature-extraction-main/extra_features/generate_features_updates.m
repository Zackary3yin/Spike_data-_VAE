function [feature_eeg,feature_eeg_chan] = generate_features_updates(tmp_EEG)
eeg_featuresMean = struct('org_set', []);
eeg_featuresChan = struct('org_set', [],'channel',[]);

Fs = tmp_EEG.srate;
chan_labels = {tmp_EEG.chanlocs(:).labels}';

% fprintf('Progress:             ');

eeg_featuresMean.org_set = tmp_EEG.setname;
eeg_featuresChan.org_set = tmp_EEG.setname;
eeg_featuresChan.channel = chan_labels;

tenseconds =  10*Fs;
segmentstarttimer=tic;

% gen features per 10 second segment
segments=1:tenseconds:tmp_EEG.pnts;
sliced_EEG = zeros(length(segments),tmp_EEG.nbchan,tenseconds);
for n=1:length(segments)-1
    sliced_EEG(n,1:tmp_EEG.nbchan,1:tenseconds) = tmp_EEG.data(:,segments(n):segments(n)+tenseconds-1);
end
%% precreate feature size array
% emrpty_arr = zeros(1,length(segments)-1);
%todo
% test_fillwithzeroarr(empty_arr,eeg_featuresMean,eeg_featuresChan);


parfor n=1:size(sliced_EEG,1)
%     start_idx=segments(n-1);
%     end_idx=segments(n);
%     eeg = tmp_EEG.data(:,start_idx:end_idx);
%     eeg=[];
%     eeg(1:tmp_EEG.nbchan,1:tenseconds)= sliced_EEG(n,1:tmp_EEG.nbchan,1:tenseconds);
    %% ENTROPY FEATURS
    
    % Shannon
    [featMean, featChan] = ShannonEntropy_MA(squeeze(sliced_EEG(n,:,:)),-200,200,2);
    eeg_featuresMean(n).ShannonEntropy = featMean;
    eeg_featuresChan(n).ShannonEntropy = featChan;

% %     Shannon on FREQUENCY BANDS (SIQ)
%     [featMean, featChan] = qEEGSIQ_MA(squeeze(sliced_EEG(n,:,:)), -200, 200, 2, 'delta');
%     eeg_featuresMean.SIQDelta(n) = featMean;
%     eeg_featuresChan.SIQDelta(1:19,n) = featChan;
%     
%     [featMean, featChan] = qEEGSIQ_MA(squeeze(sliced_EEG(n,:,:)), -200, 200, 2, 'theta');
%     eeg_featuresMean.SIQTheta(n) = featMean;
%     eeg_featuresChan.SIQTheta(1:19,n) = featChan;
%     
%     [featMean, featChan] = qEEGSIQ_MA(squeeze(sliced_EEG(n,:,:)), -200, 200, 2, 'alpha');
%     eeg_featuresMean.SIQAlpha(n) = featMean;
%     eeg_featuresChan.SIQAlpha(1:19,n) = featChan;
%     
%     [featMean, featChan] = qEEGSIQ_MA(squeeze(sliced_EEG(n,:,:)), -200, 200, 2, 'beta');
%     eeg_featuresMean.SIQBeta(n) = featMean;
%     eeg_featuresChan.SIQBeta(1:19,n) = featChan;
%     
%     [featMean, featChan] = qEEGSIQ_MA(squeeze(sliced_EEG(n,:,:)), -200, 200, 2, 'gamma');
%     eeg_featuresMean.SIQGamma(n) = featMean;
%     eeg_featuresChan.SIQGamma(1:19,n) = featChan;
    
    % Tsallis
    features={'Tsallis1','Tsallis2','Tsallis3',...
    'Tsallis4','Tsallis5','Tsallis6','Tsallis7','Tsallis8',...
    'Tsallis9','Tsallis10'};
    [featMean, featChan] = TsallisEntropy_MA(squeeze(sliced_EEG(n,:,:)), -200, 200, 2);
    for feat_n=1:length(features)
       eeg_featuresMean(n).(features{1,feat_n}) = featMean.(features{1,feat_n});
       eeg_featuresChan(n).(features{1,feat_n}) = featChan.(features{1,feat_n});
    end

%     %% eeg has zeros error
%     % Cepstrum
%     [featMean, featChan] = Cepstrum_MA(squeeze(sliced_EEG(n,:,:)));
%     eeg_featuresMean.Cepstrum_1(n) = featMean;
%     eeg_featuresChan.Cepstrum_1(1:19,n) = featChan;
    
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
%     % Lyapunov
%     [featMean, featChan] = Lyapunov_MA(squeeze(sliced_EEG(n,:,:)),Fs);
%     eeg_featuresMean(n).lyapunov = featMean;
%     eeg_featuresChan(n).lyapunov = featChan;
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Higuchi Fractal Dimention
    [eeg_featuresMean(n).HiguchiFD, eeg_featuresChan(n).HiguchiFD] = HiguchiFD_MA(squeeze(sliced_EEG(n,:,:)));
    
    % Hjorth Parameters of mobility and complexity
    features={'HjorthParametersComplexity','HjorthParametersMobility'};
    [featMean, featChan] = HjorthParameters_MA(squeeze(sliced_EEG(n,:,:)));
    for feat_n=1:length(features)
       eeg_featuresMean(n).(features{1,feat_n}) = featMean.(features{1,feat_n});
       eeg_featuresChan(n).(features{1,feat_n}) = featChan.(features{1,feat_n});
    end
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     % False Nearest Neighbors
%     [featMean, featChan] = false_neighbors_kd_MA(squeeze(sliced_EEG(n,:,:)));
%     eeg_featuresMean.FalseNearestNeighbors(n) = featMean;
%     eeg_featuresChan.FalseNearestNeighbors(1:19,n) = featChan;
%     
%     % Autoregressive Models on each segment
%     features={'ARMA_1','ARMA_2'};
%     [featMean, featChan] = ARMA_MA(squeeze(sliced_EEG(n,:,:)));
%     for feature=features
%        eeg_featuresMean.(feature{1})(n) = featMean.(feature{1});
%        eeg_featuresChan.(feature{1})(1:19,n) = featChan.(feature{1});
%     end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     % Median Frequency of the Signal
%     [featMean, featChan] = MedianFrequency_MA(squeeze(sliced_EEG(n,:,:)),1,50);
%     eeg_featuresMean.MedianFrequency(n) = featMean;
%     eeg_featuresChan.MedianFrequency(1:19,n) = featChan;
    
%     % COMPUTE THE STANDARD DEVIAITON OF THE SIGNAL
%     [featMean, featChan] = std_MA(squeeze(sliced_EEG(n,:,:)));
%     eeg_featuresMean.Signalstd(n) = featMean;
%     eeg_featuresChan.Signalstd(1:19,n) = featChan;
    
    % ALPHA TO DELTA RATIO
    [featMean, featChan] = DeltatoAlphaRatio_MA(squeeze(sliced_EEG(n,:,:)),Fs);
    eeg_featuresMean(n).DeltatoAlphaRatio = featMean;
    eeg_featuresChan(n).DeltatoAlphaRatio = featChan;
    
    % REGULARITY
    [featMean, featChan] = regularity_MA(squeeze(sliced_EEG(n,:,:)),Fs);
    eeg_featuresMean(n).regularity = featMean;
    eeg_featuresChan(n).regularity = featChan;
    
%     % BAND POWERS
%     features={'DeltaPow','ThetaPow','AlphaPow','BetaPow',...
%         'DeltaPowRatio','ThetaPowRatio','AlphaPowRatio','BetaPowRatio'};
%     [featMean, featChan] = bandpower_MA(squeeze(sliced_EEG(n,:,:)),Fs);
%     for feature=features
%        eeg_featuresMean.(feature{1})(n) = featMean.(feature{1});
%        eeg_featuresChan.(feature{1})(1:19,n) = featChan.(feature{1});
%     end
%     
%     % FIND LOW VOLTAGE
%     [featMean, featChan]  = voltage_MA(squeeze(sliced_EEG(n,:,:)),5);
%     eeg_featuresMean.VoltageLessThan5(n) = featMean;
%     eeg_featuresChan.VoltageLessThan5(1:19,n) = featChan;
%     
%     [featMean, featChan]  = voltage_MA(squeeze(sliced_EEG(n,:,:)),10);
%     eeg_featuresMean.VoltageLessThanl0(n) = featMean;
%     eeg_featuresChan.VoltageLessThanl0(1:19,n) = featChan;
%     
%     [featMean, featChan]  = voltage_MA(squeeze(sliced_EEG(n,:,:)),20);
%     eeg_featuresMean.VoltageLessThan20(n) = featMean;
%     eeg_featuresChan.VoltageLessThan20(1:19,n) = featChan;
    
    % FIND DIFFUSED SLOWLY < 8Hz peak OR NORMAL >= 8Hz peak
    features={'DiffuseNormal','DiffuseSlow'};
    [featMean, featChan] = diffuse_MA(squeeze(sliced_EEG(n,:,:)),Fs);
    for feat_n=1:length(features)
       eeg_featuresMean(n).(features{1,feat_n}) = featMean.(features{1,feat_n});
       eeg_featuresChan(n).(features{1,feat_n}) = featChan.(features{1,feat_n});
    end

    % Epileptiform
    features={'EpiNumSpike','EpiPeakAfterDelta','EpiNumSharpWave'};
    [featMean, featChan] = Epileptiform_MA(squeeze(sliced_EEG(n,:,:)),Fs);
    for feat_n=1:length(features)
       eeg_featuresMean(n).(features{1,feat_n}) = featMean.(features{1,feat_n});
       eeg_featuresChan(n).(features{1,feat_n}) = featChan.(features{1,feat_n});
    end
    
    % Burst Supression
    features={'BurstLengthMean','BurstLengthStd',...
        'SupressionLengthMean','SupressionLengthStd',...
        'BurstSupressionTotal','NumBursts','NumSup',...
        'BurstDelta','BurstTheta','BurstAlpha','BurstBeta','BurstMu'};
    [featMean, featChan] = BurstSupression_MA(squeeze(sliced_EEG(n,:,:)), Fs);
    for feat_n=1:length(features)
       eeg_featuresMean(n).(features{1,feat_n}) = featMean.(features{1,feat_n});
       eeg_featuresChan(n).(features{1,feat_n}) = featChan.(features{1,feat_n});
    end
    
 
%     [featMean, featChan] = BurstSupression_MA( squeeze(sliced_EEG(n,:,:)), Fs ,'burst_gamma');
%     eeg_featuresMean.BurstGamma(n) = featMean;
%     eeg_featuresChan.BurstGamma(1:19,n) = featChan;
    
    
%     % BCI
%     [featMean, featChan] = qEEGBCI_MA(squeeze(sliced_EEG(n,:,:)), Fs);
%     eeg_featuresMean.BCI(n) = featMean;
%     eeg_featuresChan.BCI(1:19,n) = featChan;
% 
%     % Burst Suppression Amplitude ratio
%     [featMean, featChan] = qEEGBSAR_MA(squeeze(sliced_EEG(n,:,:)), Fs);
%     eeg_featuresMean.BSAR(n) = featMean;
%     eeg_featuresChan.BSAR(1:19,n) = featChan;
    
    
%     % Amp 
%     features={'AmpMax','AmpMean','AmpMin','AmpVar'...
%         'FourierAmpMax','FourierAmpMean','FourierAmpMin','FourierAmpVar'...
%         'DerivAmpMax','DerivAmpMean','DerivAmpMin','DerivAmpVar'...
%         'DerivFourierAmpMax','DerivFourierAmpMean',...
%         'DerivFourierAmpMin','DerivFourierAmpVar',...
%         'LineLengths','Kurtavg'};
%     [featMean, featChan] = AmplitudeFeatures_MA(squeeze(sliced_EEG(n,:,:)));
%     for feature=features
%        eeg_featuresMean.(feature{1})(n) = featMean.(feature{1});
%        eeg_featuresChan.(feature{1})(1:19,n) = featChan.(feature{1});
%     end

    %% CONNECTIVITY FEATURES (18chans)
    % COHERENCE IN THE DELTA BAND and ALL BANDS
    features={'CONCoherenceDelta','CONCoherenceAll'};
    [featMean, featChan] = DeltaCoherence_MA(squeeze(sliced_EEG(n,:,:)), Fs);
    for feat_n=1:length(features)
       eeg_featuresMean(n).(features{1,feat_n}) = featMean.(features{1,feat_n});
       eeg_featuresChan(n).(features{1,feat_n}) = featChan.(features{1,feat_n});
    end
    
    % Phase Lag Index 
    [featMean, featChan] = PhaseLagIndex_MA(squeeze(sliced_EEG(n,:,:)));
    eeg_featuresMean(n).CONPhaseLagIndex = featMean;
    eeg_featuresChan(n).CONPhaseLagIndex = featChan;
    
    % Cross-Correlation
    [featMean, featChan] = CrossCorrelation_MA(squeeze(sliced_EEG(n,:,:)),Fs,'ACOR_MAG');
    eeg_featuresMean(n).CONCrossCorrelationAcorMag = featMean;
    eeg_featuresChan(n).CONCrossCorrelationAcorMag = featChan;
    
    [featMean, featChan] = CrossCorrelation_MA(squeeze(sliced_EEG(n,:,:)),Fs,'ACOR_LAG');
    eeg_featuresMean(n).CONCrossCorrelationAcorLag = featMean;
    eeg_featuresChan(n).CONCrossCorrelationAcorLag = featChan;
    

%     % Granger Causality
%     [featMean, featChan] = GrangerCause_MA(squeeze(sliced_EEG(n,:,:)),Fs);
%     eeg_featuresMean.CONGrangerCause(n) = featMean;
%     eeg_featuresChan.CONGrangerCause(1:18,n) = featChan;
%     timeelapsed=toc(segmentstarttimer);
%     if ~(mod(n,5))
%     progress_str = sprintf('\nElapsed time is %7.2f seconds, %3.2f done, segment: %3d', timeelapsed, n/length(segments) * 100,n);
%     for delete_n = 1:strlength(progress_str)
%         fprintf('\b');
%     end
%     fprintf(progress_str); 
%     end
%     fprintf('n:%d', n); 
%     fprintf('start_idx:%d',start_idx);
    
%     fprintf('\n')
    
    
end

 timeelapsed=toc(segmentstarttimer);
fprintf('\nElapsed time is %7.2f seconds\n', timeelapsed);

feature_eeg = eeg_featuresMean;
feature_eeg_chan = eeg_featuresChan;
end

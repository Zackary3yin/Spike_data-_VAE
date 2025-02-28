function feature_eeg = EEG_extract_feature(tmp_EEG)
eeg_features = struct('org_set', []);

Fs = tmp_EEG.srate;
eeg_features.org_set = tmp_EEG.setname; % create struct for features

n = 1;
start_idx =1;
end_idx = start_idx + 10*Fs;  % using 10s time resolution

fprintf('in features script\r\n')
while true 
    if end_idx > tmp_EEG.pnts
        break
    end
    eeg = tmp_EEG.data(:,start_idx:end_idx);
    
    %% FEATURE ADDED BY MAHSA
    % standard deviation of signal
    eeg_features.SignalSD(n) = qEEGstd(eeg);
    fprintf('generated first feature\r\n')
    
    % low voltage 5, 10, 20
    eeg_features.lv_l5(n) = qEEGvoltage(eeg,5);
    eeg_features.lv_l10(n) = qEEGvoltage(eeg,10);
    eeg_features.lv_l20(n) = qEEGvoltage(eeg,20);
    
    % SIQ
    bin_min = -200; bin_max = 200; binWidth = 2;
    eeg_features.SIQ(n) = qEEGSIQ(eeg, bin_min, bin_max, binWidth);
    eeg_features.SIQ_delta(n) = qEEGSIQ(eeg, bin_min, bin_max, binWidth, 'delta');
    eeg_features.SIQ_theta(n) = qEEGSIQ(eeg, bin_min, bin_max, binWidth, 'theta');
    eeg_features.SIQ_alpha(n) = qEEGSIQ(eeg, bin_min, bin_max, binWidth, 'alpha');
    eeg_features.SIQ_beta(n) = qEEGSIQ(eeg, bin_min, bin_max, binWidth, 'beta');
    
    % BCI
    eeg_features.BCI(n) = qEEGBCI(eeg, Fs);

    % Burst Suppression Amplitude ratio
    eeg_features.BSAR(n) = qEEGBSAR(eeg, Fs);
    fprintf('generated all MAHSA features\r\n')
    
    %% FEATURE ADDED BY VISHNU / EDDY
    % Algo 3 0st derivative global features (Kaggle)
    %Max of channel max amplitudes (abs val amp)
    eeg_features.d0MaxAmp(n) = max(max(abs(eeg')));
    %Mean of channel max amplitudes (abs val amp)
    eeg_features.d0MeanMaxAmp(n) = mean(max(abs(eeg')));
    %Var of channel max ampltidues (abs val amp)
    eeg_features.d0VarMaxAmp(n) = var(max(abs(eeg')));
    %Var of mean channel amplitude (abs val amp)
    eeg_features.d0VarMeanAmp(n) = var(mean(abs(eeg')));
    %Var of individual channel var in amplitude 
    eeg_features.d0VarVarAmp(n) = var(var(abs(eeg')));
    %Mean of individual channel var in ampltiude
    eeg_features.d0MeanVarAmp(n) = mean(var(abs(eeg')));
    
    %Max of maxes of channel fourier ampltiudes
    eeg_features.d0MaxMaxFourAmp(n) = max(max(abs(fft(eeg'))));
    %Mean of maxes of channel fourier ampltiudes
    eeg_features.d0MeanMaxFourAmp(n) = mean(max(abs(fft(eeg'))));
    %Var of maxes of channel fourier ampltiudes
    eeg_features.d0VarMaxFourAmp(n) = var(max(abs(fft(eeg'))));
    
    % Algo 3 1st derivative global features (Kaggle)
    deriv1 = diff(eeg');
    %Max of channel max amplitudes 
    eeg_features.d1MaxAmp(n) = max(max(abs(deriv1)));
    %Mean of channel max amplitudes
    eeg_features.d1MeanMaxAmp(n) = mean(max(abs(deriv1)));
    %Var of channel max ampltidues 
    eeg_features.d1VarMaxAmp(n) = var(max(abs(deriv1)));
    %Var of mean channel amplitude 
    eeg_features.d1VarMeanAmp(n) = var(mean(abs(deriv1)));
    %Var of individual channel var in amplitude 
    eeg_features.d1VarVarAmp(n) = var(var(abs(deriv1)));
    %Mean of individual channel var in ampltiude 
    eeg_features.d1MeanVarAmp(n) = mean(var(abs(deriv1)));
    
    fft1d = fft(deriv1);
    %Max of maxes of channel fourier ampltiudes
    eeg_features.d1MaxMaxFourAmp(n) = max(max(abs(fft1d)));
    %Mean of maxes of channel fourier ampltiudes 
    eeg_features.d1MeanMaxFourAmp(n) = mean(max(abs(fft1d)));
    %Var of maxes of channel fourier ampltiudes 
    eeg_features.d1VarMaxFourAmp(n) = var(max(abs(fft1d))); 
    
    % Algo 3 2nd derivative global features (Kaggle)
    deriv2 = diff(diff(eeg'));
    %Max of channel max amplitudes 
    eeg_features.d2MaxAmp(n) = max(max(abs(deriv2)));
    %Mean of channel max amplitudes 
    eeg_features.d2MeanMaxAmp(n) = mean(max(abs(deriv2)));
    %Var of channel max ampltidues 
    eeg_features.d2VarMaxAmp(n) = var(max(abs(deriv2)));
    %Var of mean channel amplitude 
    eeg_features.d2VarMeanAmp(n) = var(mean(abs(deriv2)));
    %Var of individual channel var in amplitude 
    eeg_features.d2VarVarAmp(n) = var(var(abs(deriv2)));
    %Mean of individual channel var in ampltiude 
    eeg_features.d2MeanVarAmp(n) = mean(var(abs(deriv2)));
    
    fft2d = fft(deriv2);
    %Max of maxes of channel fourier ampltiudes
    eeg_features.d2MaxMaxFourAmp(n) = max(max(abs(fft2d)));
    %Mean of maxes of channel fourier ampltiudes 
    eeg_features.d2MeanMaxFourAmp(n) = mean(max(abs(fft2d)));
    %Var of maxes of channel fourier ampltiudes 
    eeg_features.d2VarMaxFourAmp(n) = var(max(abs(fft2d)));
    
    % TEMPORAL FEATURES FROM EEG_PLOTTING FOLDER
    %method of line length calculation assumes constant spacing of data in
    %time
    linelengths = sum(abs(diff(eeg')));
    
    %avgd line length across all channels
    eeg_features.linelengthmean(n) = mean(linelengths);
    
    %mean channel kurtosis
    eeg_features.kurtavg(n) = mean(kurtosis(eeg'));
    
    %average shannon entropy *magnitude* (i.e. absolute value)
    eeg_features.shanavg(n) = mean(abs(wentropy(eeg', 'shannon')));
    
    %non-linear energy (code is directly from EEG_plotting; slightly modified)
    nle = zeros(1,length(eeg)-3);
    for i=4:length(eeg)
        nle(i-3) = eeg(i-1)*eeg(i-2)-eeg(i)*eeg(i-3);
    end
    eeg_features.nlemean(n) = mean(mean(abs(nle)));
    eeg_features.nleavgstd(n) = mean(std(nle));
    
    % SPECTRAL FEATURES FROM EEG_PLOTTING FOLDER
    deltapow = bandpower(eeg', Fs,[1 4]);
    thetapow = bandpower(eeg', Fs,[4 8]);
    alphapow = bandpower(eeg', Fs,[8 12]);
    betapow = bandpower(eeg', Fs,[12 18]);
    
    total = bandpower(eeg', Fs, [1 18]); %total bandpower in bands above
    
    deltaratio = deltapow./total; %relative pow in delta band
    thetaratio = thetapow./total;%relative pow in theta band
    alpharatio = alphapow./total;%relative pow in alpha band
    betaratio = betapow./total;%relative pow in beta band
    
    deltatheta = deltapow./thetapow;
    deltaalpha = deltapow./alphapow;
    thetaalpha = thetapow./alphapow;
    
    eeg_features.deltakurtosis(n) = kurtosis(deltapow,0);
    eeg_features.thetakurtosis(n) = kurtosis(thetapow,0);
    eeg_features.alphakurtosis(n) = kurtosis(alphapow,0);
    eeg_features.betakurtosis(n) = kurtosis(betapow,0);
    
    eeg_features.deltameanrat(n) = mean(deltaratio);
    eeg_features.thetameanrat(n) = mean(thetaratio);
    eeg_features.alphameanrat(n) = mean(alpharatio);
    eeg_features.betameanrat(n) = mean(betaratio);
    
    eeg_features.deltaminrat(n) = min(deltaratio);
    eeg_features.thetaminrat(n) = min(thetaratio);
    eeg_features.alphaminrat(n) = min(alpharatio);
    eeg_features.betaminrat(n) = min(betaratio);
    
    eeg_features.deltastdrat(n) = std(deltaratio);
    eeg_features.thetastdrat(n) = std(thetaratio);
    eeg_features.alphastdrat(n) = std(alpharatio);
    eeg_features.betastdrat(n) = std(betaratio);
    
    eeg_features.deltapctrat(n) = prctile(deltaratio, 95);
    eeg_features.thetapctrat(n) = prctile(thetaratio, 95);
    eeg_features.alphapctrat(n) = prctile(alpharatio, 95);
    eeg_features.betapctrat(n) = prctile(betaratio, 95);
    
    %relative ratio features
    eeg_features.deltathetamean(n) = mean(deltatheta);
    eeg_features.deltaalphamean(n) = mean(deltaalpha);
    eeg_features.thetaalphamean(n) = mean(thetaalpha);
    
    eeg_features.deltathetamin(n) = min(deltatheta);
    eeg_features.deltaalphamin(n) = min(deltaalpha);
    eeg_features.thetaalphamin(n) = min(thetaalpha);
    
    eeg_features.deltathetastd(n) = std(deltatheta);
    eeg_features.deltaalphastd(n) = std(deltaalpha);
    eeg_features.thetaalphastd(n) = std(thetaalpha);
    
    eeg_features.deltathetapct(n) = prctile(deltatheta, 95);
    eeg_features.deltaalphapct(n) = prctile(deltaalpha, 95);
    eeg_features.thetaalphapct(n) = prctile(thetaalpha, 95);
    
    %log entropy magnitude
    log_entropy_magnitude = abs(wentropy(eeg', 'log energy'));
    eeg_features.meanlogentropy(n) = mean(log_entropy_magnitude);
    
    %magnitude of cross-correlation between channels (need to choose a lag)
    cross_correlation = abs(xcorr(eeg')); %abs cross-cor. between columns/channels
    eeg_features.xcorrmean(n) = mean(mean(cross_correlation));
    eeg_features.xcorrstd(n) = std(cross_correlation, 1, 'all'); %std of all elements
    
    corr = abs(corrcoef(eeg'));
    eeg_features.corrmean(n) = mean(mean(corr));
    eeg_features.xcorrstd(n) = std(corr, 1, 'all'); %std of all elements
    
    %amplitude calculations
    amp = abs(eeg');
    eeg_features.geomeanamp(n) = mean(geomean(amp));
    eeg_features.harmmeanamp(n) = mean(harmmean(amp));
 
    %skewness of amplitude distribution per channel
    eeg_features.meanskewamp(n) = mean(skewness(amp, 0));
    eeg_features.stdskewamp(n) = std(skewness(amp, 0));
    
    eeg_features.overallskewamp(n) = skewness(reshape(amp.',1,[]), 0);
    
    %iqr of amplitude
    eeg_features.meaniqrchannelamp(n) = mean(iqr(amp));
    
    %iqr of signal values
    eeg_features.overalliqramp(n) = iqr(eeg', 'all');
    
    %spectral entropy magnitude
    spect = [];
    spectkurt = [];
    changept_counter = 0;
    peak_counter = 0;
    for i = 1:size(eeg, 1)
        [se, te] = pentropy(abs(eeg(i, :)), Fs);
        spect(i, :) = se;
        spectkurt(i, :) = pkurtosis(abs(eeg(i,:)));
        changept_counter = changept_counter + numel(findchangepts(eeg(i, :)));
        peak_counter = peak_counter + numel(findpeaks(eeg(i, :)));
    end
    %average spectral entropy across time and channels
    eeg_features.avgspectent(n) = mean(mean(spect));
    eeg_features.sdspectent(n) = std(mean(spect'));
    %pct of points that are changepoints (via CPD algo)
    eeg_features.pctchangepoint(n) = changept_counter/numel(eeg);
    %pct of points taht are peaks via peak prominence
    eeg_features.pctpeakpoint(n) = peak_counter/numel(eeg);
    %SPECTRAL KURTOSIS
    eeg_features.avgspectkurt(n) = mean(mean(spectkurt));
    eeg_features.sdspectkurt(n) = std(mean(spectkurt'));
    
    % Features based off of EEG_features_MATLAB_donotshare FOLDER
    %rms amplitude
    rmsamp = sqrt(mean(eeg' .* eeg'));
    eeg_features.meanrms(n) = mean(rmsamp);
    eeg_features.sdrms(n) = std(rmsamp);

    %% update variables
    n = n+1;
    start_idx = end_idx;
    end_idx = start_idx + 10*Fs;
end

feature_eeg = eeg_features;
end

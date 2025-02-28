function [features] = calculate_features(eeg,fs)
%CALCULATE_FEATURES calculates EEG features given a matrix of EEG recording
%

features = {};

n_channels = size(eeg, 1);
n_samples = size(eeg, 2);

meanApEn = 0; meanNonlinearEnergyOperator = 0;

meanChannelAmp = 0; meanMaxChannelAmp = 0; meanStdChannelAmp=0; meanLineLength=0;
meanKurtosisAmp = 0; meanSkewnessAmp = 0;meanRMSAmp=0;

meanProportionBelow5uV=0;
meanProportionBelow10uV=0; meanProportionBelow25uV = 0; meanProportionBelow50uV = 0;

meandeltapow=0; meanthetapow=0; meanalphapow=0; meanbetapow=0;
meandelta2theta =0; meandelta2alpha =0; meandelta2beta =0;meandelta2total =0;
meantheta2delta =0;meantheta2alpha =0;meantheta2beta = 0;meantheta2total =0;
meanalpha2delta =0;meanalpha2theta =0;meanalpha2beta =0;meanalpha2total =0;
meanbeta2delta =0;meanbeta2theta =0;meanbeta2alpha =0;meanbeta2total =0;
meanSpectralEntropy=0;meanStdSpectralEntropy=0;meanSpectralKurtosis=0;meanStdSpectralKurtosis=0;

for i=1:size(eeg,1)
    recording = eeg(i,:);
    %% INFORMATION THEORETIC FEATURES
    meanApEn = meanApEn + approximateEntropy(recording);
    
    %% AMPLITUDE/TIME-DOMAIN FEATURES
    amp = abs(recording);
    
    meanChannelAmp = meanChannelAmp + mean(amp);
    meanMaxChannelAmp = meanMaxChannelAmp + max(amp);
    meanStdChannelAmp = meanStdChannelAmp + std(amp);

    %normalized linelength
    meanLineLength = meanLineLength + sum(abs(diff(recording)))/fs;

    meanKurtosisAmp = meanKurtosisAmp + kurtosis(amp);
    meanSkewnessAmp = meanSkewnessAmp + skewness(amp);
    meanRMSAmp = meanRMSAmp + rms(amp);

    meanProportionBelow5uV = meanProportionBelow5uV + mean(recording < 5);
    meanProportionBelow10uV = meanProportionBelow10uV + mean(recording < 10);
    meanProportionBelow25uV = meanProportionBelow25uV + mean(recording < 25);
    meanProportionBelow50uV = meanProportionBelow50uV + mean(recording < 50);
    
    %Teagar-Kaiser Energy Operator / NLEO
    TKEO = zeros(1,length(recording)-1);
    for i=2:length(recording) - 1
        TKEO(i) = recording(i)*recording(i)-recording(i+1)*recording(i-1);
    end
    meanNonlinearEnergyOperator = meanNonlinearEnergyOperator + mean(TKEO);


    %% SPECTRAL FEATURES
    deltapow = bandpower(recording, fs, [1 4]);
    thetapow = bandpower(recording, fs, [4 8]);
    alphapow = bandpower(recording, fs, [8 13]);
    betapow = bandpower(recording, fs, [13 30]);
    totalpow = bandpower(recording, fs, [1 30]);
    
    %raw bandpower features
    meandeltapow = meandeltapow + deltapow;
    meanthetapow = meanthetapow + thetapow;
    meanalphapow = meanalphapow + alphapow;
    meanbetapow = meanbetapow + betapow;
    
    %bandpower ratio features (all combos :D)
    meandelta2theta =  meandelta2theta + deltapow/thetapow;
    meandelta2alpha = meandelta2alpha + deltapow/alphapow;
    meandelta2beta = meandelta2beta + deltapow/betapow;
    meandelta2total = meandelta2total + deltapow/totalpow;

    meantheta2delta = meantheta2delta + thetapow/deltapow;
    meantheta2alpha = meantheta2alpha + thetapow/alphapow;
    meantheta2beta = meantheta2beta + thetapow/betapow;
    meantheta2total = meantheta2total + thetapow/totalpow;

    meanalpha2delta = meanalpha2delta + alphapow/deltapow;
    meanalpha2theta = meanalpha2theta + alphapow/thetapow;
    meanalpha2beta = meanalpha2beta + alphapow/betapow;
    meanalpha2total = meanalpha2total + alphapow/totalpow;

    meanbeta2delta = meanbeta2delta + betapow/deltapow;
    meanbeta2theta = meanbeta2theta + betapow/thetapow;
    meanbeta2alpha = meanbeta2alpha + betapow/alphapow;
    meanbeta2total = meanbeta2total + betapow/totalpow; 


    %spectral entropy (calculated per 1s epoch within matrix)
    spectralEntPerSec = pentropy(recording, fs);
    meanSpectralEntropy = meanSpectralEntropy + mean(spectralEntPerSec);
    meanStdSpectralEntropy = meanStdSpectralEntropy + std(spectralEntPerSec);

    %spectral kurtosis (calculated per 1s epoch within matrix)
    spectralKurtosisPerSec = pkurtosis(recording, fs);
    meanSpectralKurtosis = meanSpectralKurtosis + mean(spectralKurtosisPerSec);
    meanStdSpectralKurtosis = meanStdSpectralKurtosis + std(spectralKurtosisPerSec);
   
end

%average per channel features
features.meanApEn = meanApEn/n_channels; 
features.meanNonlinearEnergyOperator = meanNonlinearEnergyOperator/n_channels;

features.meanChannelAmp = meanChannelAmp/n_channels;
features.meanMaxChannelAmp = meanMaxChannelAmp/n_channels;
features.meanStdChannelAmp= meanStdChannelAmp/n_channels; 
features.meanLineLength= meanLineLength/n_channels;
features.meanKurtosisAmp = meanKurtosisAmp/n_channels; 
features.meanSkewnessAmp = meanSkewnessAmp/n_channels;
features.meanRMSAmp = meanRMSAmp / n_channels;
features.meanProportionBelow5uV= meanProportionBelow5uV/n_channels;
features.meanProportionBelow10uV= meanProportionBelow10uV/n_channels; 
features.meanProportionBelow25uV = meanProportionBelow25uV/n_channels; 
features.meanProportionBelow50uV = meanProportionBelow50uV/n_channels;

features.meandeltapow= meandeltapow/n_channels; 
features.meanthetapow=meanthetapow/n_channels; 
features.meanalphapow= meanalphapow/n_channels; 
features.meanbetapow= meanbetapow/n_channels;
features.meandelta2theta = meandelta2theta/n_channels; 
features.meandelta2alpha = meandelta2alpha/n_channels; 
features.meandelta2beta = meandelta2beta/n_channels;
features.meandelta2total = meandelta2total/n_channels;
features.meantheta2delta = meantheta2delta/n_channels;
features.meantheta2alpha = meantheta2alpha/n_channels;
features.meantheta2beta =  meantheta2beta/n_channels;
features.meantheta2total = meantheta2total/n_channels;
features.meanalpha2delta = meanalpha2delta/n_channels;
features.meanalpha2theta = meanalpha2theta/n_channels;
features.meanalpha2beta = meanalpha2beta/n_channels;
features.meanalpha2total = meanalpha2total/n_channels;
features.meanbeta2delta = meanbeta2delta/n_channels;
features.meanbeta2theta = meanbeta2theta/n_channels;
features.meanbeta2alpha = meanbeta2alpha/n_channels;
features.meanbeta2total = meanbeta2total/n_channels;

features.meanSpectralEntropy= meanSpectralEntropy/n_channels; %these features go to NaN for flat artifacts i believe
features.meanStdSpectralEntropy= meanStdSpectralEntropy/n_channels;
features.meanSpectralKurtosis= meanSpectralKurtosis/n_channels;
features.meanStdSpectralKurtosis= meanStdSpectralKurtosis/n_channels;

features = struct2array(features)';
end

function [eeg_featuresMean_segment, eeg_featuresChan_segment] = BurstSupression_MA( eeg, Fs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
eeg_featuresMean_segment = struct();
eeg_featuresChan_segment = struct();

supression_threshold = 10;%10;

channels = size(eeg,1);

%loop through channels
for j=1:channels
    x = eeg(j,:);
    x = x';
    
    % CALCULATE ENVELOPE
%     x = smooth(x,10);
    x = smooth(x,10);
    ME = abs(hilbert(x));
    % ME = smooth(e,Fs/4); % apply 1/2 second smoothing
    % e = ME;
    ME_temp = sort(ME);
    baseline = mean(ME_temp(1:Fs*1.5));
    ME = ME-baseline;
    % DETECT SUPRESSIONS
    % apply threshold -- 10uv
    z = (ME<supression_threshold);
    % remove too-short suppression segments
    z = fcnRemoveShortEvents(z,Fs/4);
    % remove too-short burst segments
    b = fcnRemoveShortEvents(1-z,Fs/4);
    z = 1-b;
    z = z';

    %% RUN 'BS' ALGORITHM
    went_low  = find((z(1:end-1) == 0) & (z(2:end) == 1));
    went_high  = find((z(1:end-1) == 1) & (z(2:end) == 0));

    if ~isempty(went_low)&&~isempty(went_high)
    starting = went_high(1) < went_low(1);
        if(starting == 1)
            sup =  [[1, went_low(1:length(went_high)-1)]; went_high]';
            bur = [went_high(1:length(went_low)); went_low]';
        end

        if(starting == 0)
            bur =  [[1, went_high(1:length(went_low)-1)]; went_low]';
            sup = [went_low(1:length(went_high)); went_high]';
        end    
    else
        bur = [];
        sup = [];
    end
    
    if ~isempty(bur)
        eeg_featuresChan_segment.BurstLengthMean(j,1) = mean(bur(:,2) - bur(:,1))/Fs;
        eeg_featuresChan_segment.BurstLengthStd(j,1) = std(bur(:,2) - bur(:,1))/Fs;
        eeg_featuresChan_segment.SupressionLengthMean(j,1) = mean(sup(:,2) - sup(:,1))/Fs;
        eeg_featuresChan_segment.SupressionLengthStd(j,1) = std(sup(:,2) - sup(:,1))/Fs;
        eeg_featuresChan_segment.BurstSupressionTotal(j,1) = sum(bur(:,2) - bur(:,1))/length(x);
        eeg_featuresChan_segment.NumBursts(j,1) = length(bur);
        eeg_featuresChan_segment.NumSup(j,1) = length(sup);

        burr_length = size(bur,1);
        for i = 1:burr_length
            this_burst = x(bur(i,1):bur(i,2));
            del(i) = bandpower(this_burst,Fs,[0.5,4]);
            the(i) = bandpower(this_burst,Fs,[4,7]);
            alp(i) = bandpower(this_burst,Fs,[8,15]);
            bet(i) = bandpower(this_burst,Fs,[16,31]);
            mu(i) = bandpower(this_burst,Fs,[8,12]);
        end
        eeg_featuresChan_segment.BurstDelta(j,1) = mean(del);
        eeg_featuresChan_segment.BurstTheta(j,1) = mean(the);
        eeg_featuresChan_segment.BurstAlpha(j,1) = mean(alp);
        eeg_featuresChan_segment.BurstBeta(j,1) = mean(bet);
        eeg_featuresChan_segment.BurstMu(j,1) = mean(mu);
        
    else
        eeg_featuresChan_segment.BurstLengthMean(j,1) = 0;
        eeg_featuresChan_segment.BurstLengthStd(j,1) = 0;
        eeg_featuresChan_segment.SupressionLengthMean(j,1) = 0;
        eeg_featuresChan_segment.SupressionLengthStd(j,1) = 0;
        eeg_featuresChan_segment.BurstSupressionTotal(j,1) = 0;
        eeg_featuresChan_segment.NumBursts(j,1) = 0;
        eeg_featuresChan_segment.NumSup(j,1) = 0;
        
        eeg_featuresChan_segment.BurstDelta(j,1) = 0;
        eeg_featuresChan_segment.BurstTheta(j,1) = 0;
        eeg_featuresChan_segment.BurstAlpha(j,1) = 0;
        eeg_featuresChan_segment.BurstBeta(j,1) =0;
        eeg_featuresChan_segment.BurstMu(j,1) = 0;
        
    end
    
    
end

eeg_featuresMean_segment.BurstLengthMean = mean(eeg_featuresChan_segment.BurstLengthMean);
eeg_featuresMean_segment.BurstLengthStd = mean(eeg_featuresChan_segment.BurstLengthStd);
eeg_featuresMean_segment.SupressionLengthMean = mean(eeg_featuresChan_segment.SupressionLengthMean);
eeg_featuresMean_segment.SupressionLengthStd = mean(eeg_featuresChan_segment.SupressionLengthStd);
eeg_featuresMean_segment.BurstSupressionTotal = mean(eeg_featuresChan_segment.BurstSupressionTotal);
eeg_featuresMean_segment.NumBursts = mean(eeg_featuresChan_segment.NumBursts);
eeg_featuresMean_segment.NumSup = mean(eeg_featuresChan_segment.NumSup);

eeg_featuresMean_segment.BurstDelta = mean(eeg_featuresChan_segment.BurstDelta);
eeg_featuresMean_segment.BurstTheta = mean(eeg_featuresChan_segment.BurstTheta);
eeg_featuresMean_segment.BurstAlpha = mean(eeg_featuresChan_segment.BurstAlpha);
eeg_featuresMean_segment.BurstBeta = mean(eeg_featuresChan_segment.BurstBeta);
eeg_featuresMean_segment.BurstMu = mean(eeg_featuresChan_segment.BurstMu);

end



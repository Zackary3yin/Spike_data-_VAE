function [eeg_featuresMean_segment, eeg_featuresChan_segment] = Epileptiform_MA(eeg,Fs)

eeg_featuresMean_segment = struct();
eeg_featuresChan_segment = struct();

channels = size(eeg,1);

stds_away = 3;
dealta_jumps = 2;
    
%loop through channels
for chan=1:channels
    x = eeg';
    
    
    %remove the mean from the signal and look for the spikes
    %Find a spikes lasting lt 70 ms -14 samples
    [pks, locs]=findpeaks(x(:,chan)-mean(x(:,chan)),'MaxPeakWidth',14,'SortStr', 'descend');
    pk_index = locs(find(stds_away * std(x(:,chan)) < pks));
    eeg_featuresChan_segment.EpiNumSpike(chan,1) = length(pk_index);
    %check for a stronger delta in the one second following the shark peak.
    try
        for j = 1:length(locs)
            %is the power in the preceeding second less than in the seconds before the spike.
            delta_jump = bandpower(x(locs(j)-Fs:locs(j),chan),Fs,[0.5 4])*dealta_jumps < bandpower(x(locs(j):locs(j)+Fs,chan),Fs,[0.5 4]);
        end
        eeg_featuresChan_segment.EpiPeakAfterDelta(chan,1) = length(delta_jump);
    catch
        eeg_featuresChan_segment.EpiPeakAfterDelta(chan,1) = 0;
    end
    [pks, locs]=findpeaks(x(chan,:)-mean(x(chan,:)),'MinPeakWidth',14, 'MaxPeakWidth', 40, 'SortStr', 'descend');
    pk_index = locs(find(stds_away * std(x(chan,:)) < pks));
    eeg_featuresChan_segment.EpiNumSharpWave(chan,1) = length(pk_index);    
end

eeg_featuresMean_segment.EpiNumSpike = mean(eeg_featuresChan_segment.EpiNumSpike);
eeg_featuresMean_segment.EpiPeakAfterDelta = mean(eeg_featuresChan_segment.EpiPeakAfterDelta);
eeg_featuresMean_segment.EpiNumSharpWave = mean(eeg_featuresChan_segment.EpiNumSharpWave);
end

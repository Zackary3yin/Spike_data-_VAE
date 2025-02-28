function [eeg_featuresMean_segment, eeg_featuresChan_segment] = bandpower_MA(eeg,Fs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
eeg_featuresMean_segment = struct();
eeg_featuresChan_segment = struct();

eeg_featuresChan_segment.DeltaPow = bandpower(eeg', Fs,[0.5 4])';
eeg_featuresChan_segment.ThetaPow = bandpower(eeg', Fs,[4 7])';
eeg_featuresChan_segment.AlphaPow = bandpower(eeg', Fs,[8 12])';
eeg_featuresChan_segment.BetaPow = bandpower(eeg', Fs,[12 30])';

total = bandpower(eeg', Fs, [0.5 30])';

eeg_featuresChan_segment.DeltaPowRatio = eeg_featuresChan_segment.DeltaPow./total;
eeg_featuresChan_segment.ThetaPowRatio = eeg_featuresChan_segment.ThetaPow./total;
eeg_featuresChan_segment.AlphaPowRatio = eeg_featuresChan_segment.AlphaPow./total;
eeg_featuresChan_segment.BetaPowRatio = eeg_featuresChan_segment.BetaPow./total;

eeg_featuresMean_segment.DeltaPow = mean(eeg_featuresChan_segment.DeltaPow);
eeg_featuresMean_segment.ThetaPow = mean(eeg_featuresChan_segment.ThetaPow);
eeg_featuresMean_segment.AlphaPow = mean(eeg_featuresChan_segment.AlphaPow);
eeg_featuresMean_segment.BetaPow = mean(eeg_featuresChan_segment.BetaPow);

eeg_featuresMean_segment.DeltaPowRatio = mean(eeg_featuresChan_segment.DeltaPowRatio);
eeg_featuresMean_segment.ThetaPowRatio = mean(eeg_featuresChan_segment.ThetaPowRatio);
eeg_featuresMean_segment.AlphaPowRatio = mean(eeg_featuresChan_segment.AlphaPowRatio);
eeg_featuresMean_segment.BetaPowRatio = mean(eeg_featuresChan_segment.BetaPowRatio);

end
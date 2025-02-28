function [eeg_featuresMean_segment, eeg_featuresChan_segment]=TsallisEntropy_MA(eeg,bin_min, bin_max, binWidth)
eeg_featuresMean_segment = struct();
eeg_featuresChan_segment = struct();

channels = size(eeg,1);

%loop through channels
for j=1:channels
    x = eeg(j,:)';
    
    % calculates shannon entropy
    [counts,binCenters] = hist(x,[bin_min:binWidth:bin_max]);
    binWidth = diff(binCenters);
    binWidth = [binWidth(end),binWidth]; % Replicate last bin width for first, which is indeterminate.
    nz = counts>0; % Index to non-zero bins
    prob = counts(nz)/sum(counts(nz));

    eeg_featuresChan_segment.Tsallis1(j,1) = Tsallis_entro_mini(prob',(1 + 0.01));
    eeg_featuresChan_segment.Tsallis2(j,1) = Tsallis_entro_mini(prob',(2 + 0.01));
    eeg_featuresChan_segment.Tsallis3(j,1) = Tsallis_entro_mini(prob',(3 + 0.01));
    eeg_featuresChan_segment.Tsallis4(j,1) = Tsallis_entro_mini(prob',(4 + 0.01));
    eeg_featuresChan_segment.Tsallis5(j,1) = Tsallis_entro_mini(prob',(5 + 0.01));
    eeg_featuresChan_segment.Tsallis6(j,1) = Tsallis_entro_mini(prob',(6 + 0.01));
    eeg_featuresChan_segment.Tsallis7(j,1) = Tsallis_entro_mini(prob',(7 + 0.01));
    eeg_featuresChan_segment.Tsallis8(j,1) = Tsallis_entro_mini(prob',(8 + 0.01));
    eeg_featuresChan_segment.Tsallis9(j,1) = Tsallis_entro_mini(prob',(9 + 0.01));
    eeg_featuresChan_segment.Tsallis10(j,1) = Tsallis_entro_mini(prob',(10 + 0.01));
    
end


eeg_featuresMean_segment.Tsallis1 = mean(eeg_featuresChan_segment.Tsallis1);
eeg_featuresMean_segment.Tsallis2 = mean(eeg_featuresChan_segment.Tsallis2);
eeg_featuresMean_segment.Tsallis3 = mean(eeg_featuresChan_segment.Tsallis3);
eeg_featuresMean_segment.Tsallis4 = mean(eeg_featuresChan_segment.Tsallis4);
eeg_featuresMean_segment.Tsallis5 = mean(eeg_featuresChan_segment.Tsallis5);
eeg_featuresMean_segment.Tsallis6 = mean(eeg_featuresChan_segment.Tsallis6);
eeg_featuresMean_segment.Tsallis7 = mean(eeg_featuresChan_segment.Tsallis7);
eeg_featuresMean_segment.Tsallis8 = mean(eeg_featuresChan_segment.Tsallis8);
eeg_featuresMean_segment.Tsallis9 = mean(eeg_featuresChan_segment.Tsallis9);
eeg_featuresMean_segment.Tsallis10 = mean(eeg_featuresChan_segment.Tsallis10);

end


function y=Tsallis_entro_mini(x,q)

[M,N]=size(x);
y=zeros(1,N);
for l=1:N
    sum1=sum(x(:,l)-(x(:,l)).^q);
    sum2=sum1/(q-1);
    y(1,l)=sum2;
end

end



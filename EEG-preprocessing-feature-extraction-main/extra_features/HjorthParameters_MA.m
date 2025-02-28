function [eeg_featuresMean_segment, eeg_featuresChan_segment]= HjorthParameters_MA(eeg)
eeg_featuresMean_segment = struct();
eeg_featuresChan_segment = struct();


channels = size(eeg,1);


%loop through channels
for j=1:channels
    xV = eeg(j,:);
    xV = xV';
    
%     n = length(xV);
    dxV = diff([0;xV]);
    ddxV = diff([0;dxV]);
    mx2 = mean(xV.^2);
    mdx2 = mean(dxV.^2);
    mddx2 = mean(ddxV.^2);

    mob = mdx2 / mx2;

    eeg_featuresChan_segment.HjorthParametersComplexity(j,1) = sqrt(mddx2 / mdx2 - mob);
    eeg_featuresChan_segment.HjorthParametersMobility(j,1) =  sqrt(mob);
end
eeg_featuresMean_segment.HjorthParametersComplexity = mean(eeg_featuresChan_segment.HjorthParametersComplexity);
eeg_featuresMean_segment.HjorthParametersMobility = mean(eeg_featuresChan_segment.HjorthParametersMobility);
end

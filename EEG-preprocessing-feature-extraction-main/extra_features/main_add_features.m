% addpath(genpath('C:\Users\maghaeeaval\Documents\MATLAB\eeglab2021.1'));
eeg_files_loc = 'F:\CDAC_Arrest_EEG_Project\CDAC_PROCESSED_EEG_MATs\MGH\';
myFolderSaveFeatures = 'F:\CDAC_extra_features\MGH\';
myFolderSaveFeaturesChan = 'F:\CDAC_extra_features_chan\MGH\';
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(eeg_files_loc, '*.mat'); % Change to whatever pattern you need.
theFiles = dir(filePattern);

for k=1:length(theFiles)
    
    %% load preprocessed mat file
    baseFileName = theFiles(k).name;
    baseFileName_path = [eeg_files_loc baseFileName];
    EEG_file = load(baseFileName_path);
    
    %% generating features
    fprintf('generating features\r\n')
    tic
    [features,feature_chan] = generate_features_updates(EEG_file.x);
    toc
    
    features(1).org_set = baseFileName;
    feature_chan(1).org_set = baseFileName;
    
    fprintf('\t...done.\r\n')
    fprintf('saving features\r\n')
    
    file_name_chan = [myFolderSaveFeaturesChan '\chan__features_' baseFileName '.mat'];
    file_name = [myFolderSaveFeatures '\features_' baseFileName '.mat'];
    
    save(file_name,'features','-v7.3');
    save(file_name_chan,'feature_chan','-v7.3');
    fprintf('\t...done.\r\n')
    
end
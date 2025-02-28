function dataset = EEG_preprocess_feature(eeg_folder,eeglab_folder,scalp_map,standard_BESA,avg152t1,standard_elp,channel_list)
    %% paths
    addpath(eeg_folder)
    addpath(eeglab_folder)
    eeglab nogui

    myFolder = eeg_folder; % location to save preprocessed mat files
    myFolderSave = [myFolder '/preprocessed'];
    if ~exist(myFolderSave, 'dir')
        mkdir(myFolderSave)
    end

    myFolderSaveFeatures = [myFolder '/features']; % location to save features mat file
    if ~exist(myFolderSaveFeatures, 'dir')
        mkdir(myFolderSaveFeatures)
    end

    error_files = [];% location to save error files list
    myFolderSaveErrorFilesCSV = [myFolder '/error_files.csv'];

    filePattern = fullfile(myFolder, '*.edf'); % list all EEGs
    theFiles = dir(filePattern);

    for k=1:length(theFiles) % also parfor compatible
        baseFileName = theFiles(k).name;

        %% check if file is already done
        prep_file_name = [myFolderSave '/preprocessed_' baseFileName '.mat'];
        feat_file_name = [myFolderSaveFeatures '/features_' baseFileName '.mat'];
        if exist(prep_file_name,'file') && exist(feat_file_name,'file')
            fprintf(1, 'FILE ALREADY DONE %s\n',baseFileName);
            continue;
        end

        %% import and preprocess EEG
        fullFileName = fullfile(myFolder, baseFileName);
        fprintf(1, 'READING FILE %s\n',baseFileName);
        try
            EEG = EEG_preprocess(fullFileName,channel_list,scalp_map,standard_BESA,avg152t1,standard_elp);
            fprintf(1, 'STARTING PREPROCESSING FOR FILE %s\n',baseFileName);
        catch e
            fprintf(1, 'Error for file %s\n',baseFileName);
            fprintf(1, 'The identifier was:\n%s',e.identifier);
            fprintf(1,'There was an error! The message was:\n%s',e.message);
            error_files = [error_files;baseFileName];
            continue;
        end

        %% save edf as preprocessed mat file 
        fprintf('saving preprocessed EEG\r\n')
        file_name = [myFolderSave '/preprocessed_' baseFileName '.mat'];
        parsave(file_name,EEG); 
        fprintf('\t...done.\r\n')

        %% generate features
        fprintf('generating features\r\n')
        features = EEG_extract_features(EEG);
        features.org_set = baseFileName;
        fprintf('\t...done.\r\n')
        fprintf('saving features\r\n')

        %% save features as mat file 
        parsave(feat_file_name,features);
        fprintf('\t...done.\r\n')
    end
    fprintf(1,'\n');
    % save flat error files
    writematrix(error_files, myFolderSaveErrorFilesCSV);
end

function parsave(fname, x)
  save(fname, 'x','-v7.3')
end

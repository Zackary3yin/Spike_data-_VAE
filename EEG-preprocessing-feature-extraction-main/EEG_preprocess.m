function EEG = EEG_preprocess(fullFileName,channel_list,scalp_map,standard_BESA,avg152t1,standard_elp)
    ALLEEG = [];
    EEG = [];
    CURRENTSET = [];
    ALLCOM = [];

    %% set parameters
    low_pass_freq = 1;
    high_pass_freq = 50;

    %% import EEG 
    [ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
    EEG = pop_biosig(fullFileName);
    EEG = eeg_checkset(EEG);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname','raw-eeg','gui','off');

    %% delete any annotations (often corrupted)
    EEG.event=[];
    EEG.urevent=[];
    EEG.eventdescription=[];

    %% resample (down sample to 100 Hz)
    EEG = pop_resample(EEG, 100);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'setname','re-sample','gui','off');

    %% keep channels of interest
    keep_channels = intersect(channel_list,{EEG.chanlocs.labels});
    EEG = pop_select( EEG, 'channel',keep_channels);
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'setname','channels-removed','gui','off');

    %% insert channel location (required for ICA later)
    EEG=pop_chanedit(EEG, 'lookup',scalp_map);
    [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);

    %% bandpass
    EEG = pop_eegfiltnew(EEG, low_pass_freq, [], [], false, [], 0); %high pass filter
    EEG = pop_eegfiltnew(EEG, [], high_pass_freq, [], false, [], 0); %low pass filter
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'setname','freq-filtered','gui','off');

    %% line noise removal
    EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1: EEG.nbchan],'computepower',1,'linefreqs',60,'newversion',0,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',0,'sigtype','Channels','taperbandwidth',2,'tau',100,'verb',1,'winsize',4,'winstep',1);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5,'setname','line-noise-removed','gui','off');

    %% run ICA (you can change ICA type)
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 6,'setname','ICA_runica','gui','off');
    fprintf('done ICA\r\n')
    
    %% automatic ICA rejection algorithm
    % fit dipole model  (BESA file found in eamorim_shared
    EEG = pop_dipfit_settings( EEG, 'hdmfile',standard_BESA,'coordformat','Spherical','mrifile',avg152t1,'chanfile',standard_elp,'coord_transform',[13.4299 0.74636 -0.65492 0.00087811 -0.081835 0.0023747 0.85283 0.94159 0.85887] ,'chansel',[1: EEG.nbchan] );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 7,'setname','dipfit','gui','off');
    EEG = pop_multifit(EEG, [1: EEG.nbchan] ,'threshold',40,'plotopt',{'normlen','on'});
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    
    % perform IC rejection using ICLabel scores and r.v. from dipole fitting
    EEG = iclabel(EEG, 'default');
    
    % obtain the most dominant class label and its label probability.
    brainIdx  = find(EEG.etc.ic_classification.ICLabel.classifications(:,1) >= 0.7);
    
    % perform IC rejection using residual variance of the IC scalp maps.
    rvList    = [EEG.dipfit.model.rv];
    goodRvIdx = find(rvList < 0.15); % < 15% residual variance == good ICs.
    goodIcIdx = intersect(brainIdx, goodRvIdx);
    
    % Perform IC rejection.
    EEG = pop_subcomp(EEG, goodIcIdx, 0, 1);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 8,'setname','ICs-removed','gui','off');

    % rereference (average montage)
    EEG = pop_reref(EEG, []);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 9,'setname','average_montage','gui','off');
end


# EEG preprocessing and feature extraction

#### takes EEG(folder) as input:
    - 1. preprocesses the EEG using artiafct removal techniques saving      preprocessed as mat file.
    - 2. extracts ~95 features with 10s time resolution (averaging 19 channels) saving results as mat file
    - 3. requires: EEGLAB (ver.2021), avg152t1.mat \ standard_1005.elc \ standard_BESA.mat \ standard-10-5-cap385.elp (eamorim_shared)
    - 4. run full pipeline by calling EEG_main.m

#### EEGLAB Required Extensions
- Can be added through the EEGLAB GUI > File > Manage EEGLAB extensions
    - Biosig v3.8.1
    - Fieldtrip-lite
    - ERPLAB v10
    - clean_rawdata
    - Cleanline v2.00
    - firfilt
    - ICLabel v1.4
    - dipfit

#### EEG_main.m
- prepares environment, calls EEG_preprocess_feature.m

#### EEG_preprocess_feature.m
- preprocesses EEG, saves as mat, extracts features, saves as mat. 
- calls EEG_preprocess.m, EEG_feature.m

#### EEG_preprocess.m (uses EEGLAB ver.2021)
- takes single EEG as input and preprocesses using steps below
    - resample EEG
    - only keep 19 channels of interest (list obtained from weilong)
    - frequency filtering (0.5-50 Hz)
    - remove line noise (60 Hz)
    - run ICA (runica/infomax algorithm)
    - automatically reject ICA components
        - fit dipole model
        - run icalabel algorithm to obtain "IClabel scores" (https://github.com/sccn/ICLabel)
        - perform IC rejection based on residual variance of the IC scalp maps
    - re-reference channels to average montage


#### EEG_feature.m
- takes preprocessed EEG from EEG_preprocess.m and extracts a list of feature with a 10s time resolution. Saves all features in mat file. 
- please see features_list.xlsx for feature descriptions 

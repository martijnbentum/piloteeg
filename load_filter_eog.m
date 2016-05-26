function output = load_filter_eog(pp_filename)


stim_name = {'S  12', 'S  13', 'S  14','S  2','S  3','S  4','S  56','S  57','S  58','S  6','S  7','S  8'}

cfg = [];
%define the trials
cfg.trialfun                = 'ft_trialfun_general';
cfg.trialdef.prestim        = .2;
cfg.trialdef.poststim       = 1;
cfg.trialdef.eventtype      = 'Stimulus';
cfg.trialdef.eventvalue     = stim_name %list of markers
cfg.dataset                 = pp_filename; %list of filenames 

%preprocessing

%filter
cfg.lpfilter        = 'yes';
cfg.hpfilter        = 'yes';
cfg.lpfreq          = 30;
cfg.hpfreq          = 1;

%referencing
cfg.reref           = 'yes';  % Rereference
cfg.implicitref     = 'REF_leftmastoid';  % Reconstruct implicit reference
cfg.refchannel      = {'RM' 'REF_leftmastoid'};

%line noise
%cfg.dftfilter               = 'yes';
%cfg.dftfreq                 = 50;
    
cfg.demean                  = 'yes';
cfg.baselinewindow          = [-0.15 0];


cfg                         = ft_definetrial(cfg);

%load the data
d                           = ft_preprocessing(cfg);

temp =cfg;
%eog channels


% EOGV channel VERTICAL
cfg              = [];
cfg.channel      = {'VEOGl' 'VEOGh'};
cfg.reref        = 'yes';
cfg.implicitref  = [];
cfg.refchannel   = {'VEOGl'};
eogv             = ft_preprocessing(cfg, d);

% only keep one channel, and rename to eogv
cfg              = [];
cfg.channel      = 'VEOGh';
eogv             = ft_selectdata(cfg, eogv); 
eogv.label       = {'eogv'};


% EOGH channel HORIZONTAL
cfg              = [];
cfg.channel      = {'leftHEOG' 'rightHEOG'};
cfg.reref        = 'yes';
cfg.implicitref  = [];
cfg.refchannel   = {'leftHEOG'};
eogh             = ft_preprocessing(cfg, d);

% only keep one channel, and rename to eogh
cfg              = [];
cfg.channel      = 'rightHEOG';
eogh             = ft_selectdata(cfg, eogh); 
eogh.label       = {'eogh'};

% only keep all non-EOG channels
cfg.channel = setdiff(d.label,{'leftHEOG','rightHEOG','VEOGl','VEOGh'});
d           = ft_selectdata(cfg, d); 



% append the EOGH and EOGV channel to the selected EEG channels 
cfg = temp;
output   = ft_appenddata(cfg, d, eogv, eogh);

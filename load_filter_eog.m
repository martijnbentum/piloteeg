function output = load_filter_eog(pp_filename)
%RM, right mastoid
%REF_LM, left mastoid
%HEOGR, horizontal eog
%HEOGL, horizontal eog
%VEOG, vertical eog

%stim_name = {'S  12', 'S  13', 'S  14','S  2','S  3','S  4','S  56','S  57','S  58','S  6','S  7','S  8'}


cfg = [];
%define the trials
cfg.trialfun                = 'ft_trialfun_general';
cfg.trialdef.prestim        = .2;
cfg.trialdef.poststim       = 1;
cfg.trialdef.eventtype      = 'Stimulus';
cfg.trialdef.eventvalue     = stim_name %list of markers
cfg.dataset                 = pp_filename; %list of filenames 

%preprocessing

%filter wait with filtering
%cfg.lpfilter        = 'yes';%maybe wait with filtering ?
%cfg.hpfilter        = 'no';%baseline , should not correlate with epoch
%cfg.lpfreq          = 30;
%cfg.hpfreq          = 0.1;% should check whether only 0.5 filter is used

%referencing
cfg.reref           = 'yes';  % Rereference
cfg.implicitref     = 'REF_LM';  % Reconstruct implicit reference
cfg.refchannel      = {'RM' 'REF_LM'};

%line noise was already commented out before study 2
%cfg.dftfilter               = 'yes';
%cfg.dftfreq                 = 50;

%should not demean, i guess this means baseline correction, i will use baseline as predictor    
cfg.demean                  = 'no';
cfg.baselinewindow          = [-0.15 0];


cfg                         = ft_definetrial(cfg);

%load the data
d                           = ft_preprocessing(cfg);

temp =cfg;
%eog channels


% EOGV channel VERTICAL
%there is only one vertical eog channel
%cfg              = [];
%cfg.channel      = {'VEOGl' 'VEOGh'};
%cfg.reref        = 'yes';
%cfg.implicitref  = [];
%cfg.refchannel   = {'VEOGl'};
%eogv             = ft_preprocessing(cfg, d);
% only keep one channel, and rename to eogv
%cfg              = [];
%cfg.channel      = 'VEOGh';
%eogv             = ft_selectdata(cfg, eogv); 
%eogv.label       = {'eogv'};


% EOGH channel HORIZONTAL
cfg              = [];
cfg.channel      = {'HEOGL' 'HEOGR'};
cfg.reref        = 'yes';
cfg.implicitref  = [];
cfg.refchannel   = {'HEOGL'};
HEOG             = ft_preprocessing(cfg, d);

% only keep one channel, and rename to eogh
cfg              = [];
cfg.channel      = 'HEOGR';
eogh             = ft_selectdata(cfg, eogh); 
eogh.label       = {'eogh'};

% only keep all non-EOG channels
cfg.channel = setdiff(d.label,{'HEOGL','HEOGR'});
d           = ft_selectdata(cfg, d); 



% append the EOGH and EOGV channel to the selected EEG channels 
cfg = temp;
output   = ft_appenddata(cfg, d, VEOG, HEOG);

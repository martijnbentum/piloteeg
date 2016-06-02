function cfg = define_trial(pp_filename)
cfg = [];
%define the trials
cfg.trialfun                = 'trialfun_pilot';
cfg.trialdef.prestim        = .2;
cfg.trialdef.poststim       = 1;
cfg.trialdef.eventtype      = 'Stimulus';
cfg.trialdef.eventvalue     = '9';
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

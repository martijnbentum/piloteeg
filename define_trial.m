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

cfg.continuous = 'no';% if i do not specify this the return of preprocessing is continuous yes, I do not know yet if this is problematic
%filter wait with filtering
cfg.lpfilter        = 'yes';%maybe wait with filtering ?I will follow frank et all 2014. Filter first, then filter again at 0.25 0.33 0.5 no addition filter and check for lowest correlation between baseline and window
cfg.hpfilter        = 'yes';%baseline , should not correlate with epoch
cfg.lpfreq          = 30;%this was standard in my analysis, and the most common in my literature study
cfg.hpfreq          = 0.1;% most common in my literature study

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

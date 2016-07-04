function cfg = define_trial(pp_filename)
cfg = [];
%define the trials
cfg.trialfun                = 'trialfun_stories';%pilot';
cfg.trialdef.prestim        = .2;
cfg.trialdef.poststim       = 1;
cfg.trialdef.eventtype      = 'Stimulus';
cfg.trialdef.eventvalue     = '9';
cfg.dataset                 = pp_filename; %list of filenames 

%preprocessing

%cfg.continuous = 'no';% if i do not specify this the return of preprocessing is continuous yes, I do not know yet if this is problematic, however, if i set this flag nothig happens. I think fieldtrip determines this automatically and it refers to the data that is loaded, so if it is loaded from an eeg file continuous = yes
%filter wait with filtering
cfg.lpfilter        = 'yes';%I will follow frank et all 2014. Filter first,
cfg.hpfilter        = 'yes';%needed to keep erp around 0, see filter-investigation %no high pass filter, Luck CH5 distorts waveform, problems with default filter.    :baseline , should not correlate with epoch,  filter  at 0.25 0.33 0.5 no addition filter and check for lowest correlation between baseline and window
cfg.lpfreq          = 30;%this was standard in my analysis, and the most common in my literature study
cfg.hpfreq          = 0.05;% most common in my literature study, placed it at 0.1, lower the default filter does not work anymore, lower the order or change to other filter types, hower much slower, butterworth only takes 100 seconds, while firws takse 3000, also performance is worse
cfg.lpfilttype	    = 'but';% default = but, other options = fir firls
cfg.hpfilttype	    = 'but';% default = but, other options = fir firls
cfg.lpfiltord 	    = [];%it worsk from order 1-4, any higher order does not work, default is 8?
cfg.hpfiltord	    = 4;
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


%cfg                         = ft_definetrial(cfg);

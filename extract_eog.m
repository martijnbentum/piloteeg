function output = exctract_eog(d)
%eog channels


% EOGV channel VERTICAL
cfg              = [];
cfg.channel      = {'VEOG' 'Fp1'};
cfg.reref        = 'yes';
cfg.implicitref  = [];
cfg.refchannel   = {'VEOG'};
eogv             = ft_preprocessing(cfg, d);
%only keep one channel, and rename to eogv
cfg              = [];
cfg.channel      = 'Fp1';
eogv             = ft_selectdata(cfg, eogv); 
eogv.label       = {'eogv'};


% EOGH channel HORIZONTAL
cfg              = [];
cfg.channel      = {'HEOGL' 'HEOGR'};
cfg.reref        = 'yes';
cfg.implicitref  = [];
cfg.refchannel   = {'HEOGL'};
eogh             = ft_preprocessing(cfg, d);

% only keep one channel, and rename to eogh
cfg              = [];
cfg.channel      = 'HEOGR';
eogh             = ft_selectdata(cfg, eogh); 
eogh.label       = {'eogh'};

% only keep all non-EOG channels
cfg.channel = setdiff(d.label,{'HEOGL','HEOGR','VEOG','FP1'});
d           = ft_selectdata(cfg, d); 


%debug code
%output.d =d;
%output.eogv = eogv;
%output.eogh = eogh;
% append the EOGH and EOGV channel to the selected EEG channels 
cfg = [];
output   = ft_appenddata(cfg, d, eogv, eogh);

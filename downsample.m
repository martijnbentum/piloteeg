function d = downsample(d)
cfg = [];
cfg.resamplefs = 250;
cfg.detrend = 'no';
cfg.demean = 'no';
cfg.trials = 'all';
d = ft_resampledata(cfg,d)


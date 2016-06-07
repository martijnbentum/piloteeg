


%the data file is created with different filter options
%it shows that if you do not use highpass filter the average wavefrom differs extensively from 0
%lp_no_filter.png lp_hp_filter.png

cfg = define_trial('EEG/PP01_01_B_01.vhdr')
d = ft_preprocessing(cfg)

cfg.lpfilter = 'no'
d_nf = ft_preprocessing(cfg)

cfg.lpfilter = 'yes'
cfg.hpfilter ='yes'
cfg.hpfreq = 0.05
d_hp = ft_preprocessing(cfg)

cfg = []
cfg.channel = 'all'
cfg.trials = 'all'
cfg.keeptrial = 'no'

davg = ft_timelockanalysis(cfg,d)    
davg_nf = ft_timelockanalysis(cfg,d_nf)    
davg_hp = ft_timelockanalysis(cfg,d_hp)   

plot(davg_hp.time,davg_hp.avg(23,:))           
plot(davg.time,davg.avg(23,:),davg_nf.time,davg_nf.avg(23,:))


function d = reject_trials(preproc_cfg,d)
%returns clean data file without trials that exceed threshold as determined by the
%preproc_cfg file

cfg = [];
cfg.trials = setdiff(1:length(d.trial),preproc_cfg.d.rejected_trials);
d        = ft_selectdata(cfg, d); 

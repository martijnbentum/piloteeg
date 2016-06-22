function d = remove_trials(all_trl_remove,d)
%returns clean data file without trials that were excluded with threshold or trials that do not belong in the current condition
%preproc_cfg file

cfg = [];
cfg.trials = setdiff(1:length(d.trial),all_remove_trls);
d        = ft_selectdata(cfg, d); 

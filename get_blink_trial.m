%function [eogv_bad_trials,eogh_bad_trials] = get_blink_trial(data)
function data = get_blink_trial(trl,data)

cfg.channel = 'eogv';
eogv        = ft_selectdata(cfg, data); 
%eogv.filename = data.filename
cfg.channel = 'eogh';
eogh       = ft_selectdata(cfg, data); 
%eogh.filename = data.filename


cfg = [];

cfg.trl = trl;
cfg.continuous = 'no';
cfg.artfctdef.threshold.min       = -75;
cfg.artfctdef.threshold.max       = 75;

[config, artifact] = ft_artifact_threshold(cfg,eogv);
data.eogv_bad_trials = config.rejected_trials
[config, artifact] = ft_artifact_threshold(cfg,eogh);
data.eogh_bad_trials = config.rejected_trials

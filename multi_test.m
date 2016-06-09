
% preprocessing -> load data filter and creat eog channels
%config
fn = dir('EEG/*.vhdr')
cfg = [];
for i =1:length(fn)   
	cfg{i} = define_trial(strcat('EEG/',fn(i).name));
end

parfor i = 1:length(fn)
	cfg{i} = ft_definetrial(cfg{i});
end

%cfg{1} = ft_definetrial(cfg{1});
d = [];
parfor i = 1:length(fn)
	d{i} = ft_preprocessing(cfg{i});
end

d1 = extract_eog(d);
%d2 = get_blink_trial(d);

trl = cfg{1}.trl;
bla = cfg;                                                                            
data = d1;
cfg = [];

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
[config, artifact] = ft_artifact_threshold(cfg,eogv);

%cfg = qsubcellfun(@ft_definetrial,cfg,'memreq',5*1024^2,'timreq',15) 



%the call to "ft_definetrial" took 10 seconds and required the additional allocation of an estimated 9 MB
%the call to "ft_preprocessing" took 74 seconds and required the additional allocation of an estimated 104 MB


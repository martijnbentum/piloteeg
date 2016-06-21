function preproc_cfg = check_threshold(d)

p_name = d.filename;


%OBSOLETE, eog and mastoid channels are not present anymore
%cfg.channel = {'all','-eogv','-RM','-eogh','-REF_LM','-Fp1'} ;
%cfg.trials = 1:100
%d        = ft_selectdata(cfg, d); 
disp(p_name);
preproc_cfg = load(strcat(p_name(1:7),'_cfg.mat'))
cfg = [];

bt = [d.eogh_bad_trials d.eogv_bad_trials];%concatenate all bad trials
bt = unique(bt);

cfg.trl = preproc_cfg.d.trl;
cfg.continuous = 'no';
cfg.artfctdef.threshold.min       = -75;
cfg.artfctdef.threshold.max       = 75;
cfg.artfctdef.threshold.bpfilter = 'no'; 



[con, artifact] = ft_artifact_threshold(cfg,d);

preproc_cfg.d.bad_trials = bt;
preproc_cfg.d.rejected_trials= sample2trln(artifact,d.sampleinfo);%con.rejected_trials
preproc_cfg = preproc_cfg.d;


%cfg = []
%cfg.trials = setdiff(1:length(d.trial),rejected_trials);
%d        = ft_selectdata(cfg, d); 
%d.rejected_trials = rejected_trials;
%d.input_file3 = p_name;
%d.filename = strcat(p_name(1:7),'_clean_threshold.mat');
%d.artifact_timepoints = artifact;

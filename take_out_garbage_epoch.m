function d = take_out_garbage_epoch(pp)
%use the sample info in garbage to do partial rejection of bad epochs. The epochs are small part of a larger trial(the stories)

%load preproc data
load(strcat(pp.file_id,'_preprocstories.mat'));
preproc = ft_selectdata(d,'channel',{'all','-RM','-REF_LM','-Fp1'})
%load the garbage file, with the sampleinfo
garbage = load(strcat(pp.file_id,'_garbage.mat'));
%load the cfgstorie file, with the headerfile name (vhdr), which is needed for the ft_rejectartifact.
cfg_word = load(strcat(pp.file_id,'_cfg.mat'));

%pp.bad_epoch contains indices of the epoch that had a z-scores for amp dev and var
%indices are used to select the sampleinfo for that epochs.
%the epochs are short segments of the stories, specifically created for blink and bad epoch detection. Length was set at 200ms (could be changed)
sampleinfo = garbage.d.epoch_trl(pp.bad_epoch,1:2); % to be removed component(s)

d= [];
cfg = [];
cfg.artfctdef.reject = 'partial';
cfg.artfctdef.xxx.artifact = sampleinfo;
cfg.headerfile = cfg_word.d.headerfile;

d = ft_rejectartifact(cfg, preproc);

d.old_filename = preproc.filename;
d.filename = strcat(pp.file_id,'_reject.mat');
d.c = cfg;


cfg.trl = cfg_word.d.trl;
cfg.artfctdef.reject = 'complete';
cfg_redefine = ft_rejectartifact(cfg);
d.cfg_redefine = cfg_redefine;
d.rejected_word_trials = length(d.cfg_redefine.trlold) - length(d.cfg_redefine.trl);

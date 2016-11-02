function output = story2word_trials(cfg,d)
%split story trials into word trials
%assumes post ica files *_clean.mat
%uses ft_redefinetrial
%cleans up resulting d with info from the original d (ft_redefinetrial hides original info)

%set defaults if necessary, hpfreq can be set to find filter freq with lowest cor between baseline and erp window
if ~isfield(cfg,'hpfilter'),cfg.hpfilter = 'yes';end
if ~isfield(cfg,'hpfreq'),cfg.hpfreq = 0.05; end
if ~isfield(cfg,'hpfiltord'),cfg.hpfiltord = 4;end
if ~isfield(cfg,'redefine'),cfg.redefine = d.redefine;end

%create word trials based on the cfg redefine structure
output = ft_redefinetrial(cfg.redefine,d);


%create config structure for  preprocessing
if strcmp(cfg.hpfilter,'yes')
	c.hpfilter = cfg.hpfilter;
	c.hpfreq = cfg.hpfreq;
	c.hpfiltord = cfg.hpfiltord;
	disp('filtering with following config file (ft_preprocessing)');
	c
	%hp filter the word trials
	output = ft_preprocessing(c,output);
end


%restore info from original d file
output.c = d.c;
output.old_filename = d.old_filename;
output.filename = d.filename;
output.cfg_redefine = d.cfg_redefine;
output.rejected_word_trials = d.rejected_word_trials;
output.original_ntrials = length(d.cfg_redefine.trlold)
output.perc_removed = (output.rejected_word_trials / output.original_ntrials)* 100;

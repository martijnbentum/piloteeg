function garbage = garbage_collection(cfg,d)
%executes several functions to compute garbage statistics: variance of channels, correlations of channels and epoch checks:thresholds, variance, epoch checks should be done on data seperated in shorter segments so first create snippets of data of 1 second
%devide all trials into 1 second streches for blink detection

if ~isfield(cfg,'eog_channel'), cfg.eog_channel = {'all','-eogv','-eogh','-RM','-REF_LM','-Fp1','-Fp2'}; end%
		  if ~isfield(cfg,'channel'), cfg.channel = {'all'}; end%,'-AF7','-F7','-FT7','-P7','-PO7','-O1','-O2','-PO8','-P8','-FT8','-F8','-AF8'}; end %
if ~isfield(cfg,'check_blinks'), cfg.check_blinks = 'yes';end%default to check for blinks
if ~isfield(cfg,'check_channel'), cfg.check_channel = 'yes';end %default to check channels (var and correlation) 
if ~isfield(cfg,'check_epoch'),cfg.check_epoch = 'yes'; end%default to check epoch (deviance variance amp range)
if ~isfield(cfg,'length'),cfg.length = 1; end% length of epoch, default is 1 second

%create variable that collects all garbage statistics
if ~isfield(cfg,'garbage')
	garbage = [];
	garbage.cfg = cfg;
else
	garbage = cfg.garbage
	cfg = rmfield(cfg,'garbage')
	cfg.cfg_old = garbage.cfg
	garbage.cfg = cfg
end

%EPOCH CHECK

if ~isfield(cfg,'c')
	%default is to devide all trials into 1 second streches for blink detection
	c = [];
	c.length = cfg.length; %seconds
	c.overlap = 0;% no overlap
else
%alternatively a cfg structure can be given in cfg.c for redefine trial
	c = cfg.c;
end
snips = ft_redefinetrial(c,d);
garbage.epoch_trial_select = c;
garbage.epoch_trl = [snips.sampleinfo zeros(size(snips.sampleinfo,1),1)];

if strcmp(cfg.check_blinks, 'yes')
	%blinks, they are simplistically defined as epoch exceeding threshold of +- 75 mV
	%-----
	%trl structure should minimally contain 3 columns start end baseline offset:create 3 column for baseline offset
	%adding a zero column to sample info to comply
	blinks = get_blink_trial(garbage.epoch_trl,snips)
	%remove unnecessary fields for data reduction
	fields = {'hdr','trial','time','trialinfo','cfg'};
	blinks = rmfield(blinks,fields);
	garbage.blinks = blinks;
else
	garbage.blinks = 'not_checked'
end


if strcmp(cfg.check_epoch, 'yes')
	%remove channels from dataset
	c = [];
	c.channel = [cfg.eog_channel cfg.channel];
	snips = ft_selectdata(c,snips);
	garbage.epoch_ch_label = snips.label
	%epoch statistics, based on Nolan et al 2010 (FASTER)
	garbage.epoch_var = epoch_variance(snips);
	garbage.epoch_dev = epoch_deviation(snips);
	garbage.epoch_amp = epoch_amplitude_range(snips);
	garbage.epoch_ch_select = c;
end
%could possible benefit from epoch checks as well, but i am not sure


%CHANNEL CHECK
if strcmp(cfg.check_channel, 'yes')
	channel = [];
	%for these calculations the eog channels should be removed, because they could mask noise in the scalp channels,this is because zscore of 3 is an exclusion threshold (Nolan et al. 2010), and the noise in eog channels makes it harder for scalp channel to be an outlier.
	c = [];
	c.channel = [cfg.eog_channel cfg.channel];%select channels that are given in the default or by user in channel and cfg.channel
	d= ft_selectdata(c,d);
	
	%concatenate all trials for channels statistic calculation
	temp = [];
	temp.m = concatenate_trials(d);
	temp.label = d.label;
	
	garbage.channel_ch_label = d.label
	%channel variance
	%----------------
	garbage.channel_var = channel_var(temp);
	
	%channel mean pairwise correlation
	%---------------------------------
	%channel mean correlation: mean of the correlation of each channel paired with every other channel
	garbage.channel_cor = channel_cor(temp);
	
	garbage.channel_ch_select = c
end





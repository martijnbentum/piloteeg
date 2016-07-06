function garbage = garbage_collection(d)
%executes several functions to compute garbage statistics: variance of channels, correlations of channels and epoch checks:thresholds, variance, epoch checks should be done on data seperated in shorter segments so first create snippets of data of 1 second
%devide all trials into 1 second streches for blink detection

%create variable that collects all garbage statistics
garbage = [];


%EPOCH CHECK

%devide all trials into 1 second streches for epoch statistic calculation 
c = [];
c.length = 1; %seconds
c.overlap = 0;% no overlap
snips = ft_redefinetrial(c,d);

%blinks, they are simplistically defined as epoch exceeding threshold of +- 75 mV
%-----
%trl structure should minimally contain 3 columns start end baseline offset:create 3 column for baseline offset
%adding a zero column to sample info to comply
trl = [snips.sampleinfo zeros(size(snips.sampleinfo,1),1)];
blinks = get_blink_trial(trl,snips)
%remove unnecessary fields for data reduction
fields = {'hdr','trial','time','trialinfo','cfg'};
blinks = rmfield(blinks,fields);
blinks.trl = trl;
garbage.blinks = blinks;

%could possible benefit from epoch checks as well, but i am not sure


%CHANNEL CHECK
channel = [];
%for these calculations the eog channels should be removed, because they could mask noise in the scalp channels,this is because zscore of 3 is an exclusion threshold (Nolan et al. 2010), and the noise in eog channels makes it harder for scalp channel to be an outlier.
cfg = [];
cfg.channel = {'all','-eogv','-eogh','-RM','-REF_LM','-Fp1','-Fp2'};%
d= ft_selectdata(cfg,d);

%concatenate all trials for channels statistic calculation
temp = [];
temp.m = concatenate_trials(d);
temp.label = d.label;

%channel variance
%----------------
channel.var = channel_var(temp);

%channel mean pairwise correlation
%---------------------------------
%channel mean correlation: mean of the correlation of each channel paired with every other channel
channel.cor = channel_cor(temp);

garbage.channel = channel;


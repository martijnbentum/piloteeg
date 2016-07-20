function easy_plot(cfg,d)
%function to easily plot fieldtrip eeg data
%takes a cfg and a data file
%cfg can be empty
%ti or trial_index for trials to plot (work in progress to plot multiple trials seperately), default =1
%ci or channel index for channels to plot, can be number, label name or all, default = fz cz pz

%function checks whether 'hold on' is true to update legend with previous plots
%save plot is WOP

%check CFG and convert ti and ci to full names
if isfield(cfg,'ti'), cfg.trial_index = cfg.ti; end
if ~isfield(cfg,'trial_index'), cfg.trial_index = 1; end %TRIAL INDEX code
if isfield(cfg,'ci'),cfg.channel_index = cfg.ci; end

%CHANNEL INDEX code
%--------------------------------------------------
if ~isfield(cfg,'channel_index')
	%cfg.channel_index = [find(strcmp(d.label,'Fz')) find(strcmp(d.label,'Cz')) find(strcmp(d.label,'Pz')) ]
	%cfg.legend = {'Fz','Cz','Pz'}
	cfg.channel_index = {'Fz','Cz','Pz'}
end
if isa(cfg.channel_index,'double')
	cfg.legend = []
	for i = 1:length(cfg.channel_index)
		cfg.legend = [cfg.legend d.label(cfg.channel_index(i))]
	end
end
if strcmp(cfg.channel_index,'all')
	cfg.channel = 1:length(d.label)
	cfg.legend = 'all channels'
elseif isa(cfg.channel_index,'char')
	cfg.channel_index = {cfg.channel_index};
end

if isa(cfg.channel_index,'cell')
%if channel index is not all, it should specify channel labels
	cfg.legend = cfg.channel_index;
	temp = [];
	for i = 1:length(cfg.channel_index)
		temp = [temp find(strcmp(d.label,cfg.channel_index(i)))]
	end
	cfg.channel_index = temp;	
end
%--------------------------------------------------

%check whether 'hold on' is true and update legend
if ishold
	temp = legend();
	cfg.legend = [temp.String cfg.legend];
end

%show final cfg
cfg

%plot, WOP: plot subplots if there are multiple trials
plot(d.time{cfg.trial_index},d.trial{cfg.trial_index}(cfg.channel_index,:))
legend(cfg.legend)

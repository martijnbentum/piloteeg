function output = d2output(cfg,d)


if ~isfield(cfg,'baselinewindow'), cfg.baselinewindow= [-0.15 0]; end
if ~isfield(cfg,'erpwindow'),cfg.erpwindow = [0.300 0.500]; end
if ~isfield(cfg,'channels'), cfg.channels= channel_setup([]); end 
if ~isfield(cfg,'channel_indices'), cfg.channel_indices = channel2index(cfg.channels,d);end
if ~isfield(cfg,'name'), cfg.name = '_default_name';end

disp('cfg structure:')
cfg
%extract baseline and erp window
%------------------------------------------------------------------------------------------
disp('extract baseline and erp window')
c = [];
c.toilim = cfg.baselinewindow
base = ft_redefinetrial(c,d);
c.toilim = cfg.erpwindow
erp = ft_redefinetrial(c,d);

%load threshold rejected trials
%------------------------------
threshold = load(strcat('EEG/',d.filename(1:7),'_threshold_clean_wordcfg_no_filter.mat'))




disp('adding two zero columns to trialinfo for base and erp window')
d.trialinfo = [d.trialinfo zeros(length(base.trial),3)]; 
disp('creating average over channels and time window')
for i =1 : length(base.trial);
	d.trialinfo(i,10) = mean(mean(base.trial{i}(cfg.channel_indices,:)));
	d.trialinfo(i,11) = mean(mean(erp.trial{i}(cfg.channel_indices,:)));
	d.trialinfo(i,12) = ismember(i,threshold.d.threshold_rejected_trials);
end
disp('writing to text file')
of = strcat(d.filename(1:7),cfg.name,'_output.txt')
disp(of)
fout = fopen(of,'w')
for i=1:length(d.trialinfo)
	fprintf(fout,'%1d %1d %2d %1d %2d %3d %1d %1d %5d %3d %3d %1d\n',d.trialinfo(i,:));
end
fclose(fout)

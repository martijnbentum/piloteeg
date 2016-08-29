function output = correlation_baseline_erp(cfg,d)
%high pass filters data 
%creates average amplitude over channels and baseline/erp window
%correlates all baseline/erp amplitudes (all trials)

%save file id
output.pp_id = d.filename(1:7);

%set defaults if necessary, hpfreq can be set to find filter freq with lowest cor between baseline and erp window
if ~isfield(cfg,'hpfreq'),cfg.hpfreq = 0.25; end
if ~isfield(cfg,'hpfiltord'),cfg.hpfiltord = 4;end
if ~isfield(cfg,'baselinewindow'),cfg.baselinewindow = [-0.150 0]; end
if ~isfield(cfg,'erpwindow'),cfg.erpwindow = [0.3 0.5]; end
if ~isfield(cfg,'channel'),cfg.channel = channel_setup([]); end %default dense posterior channel setup, excluding edge electrodes

%create config structure for  preprocessing
c = [];
if cfg.hpfreq ~= 0
	c.hpfilter = 'yes';
	c.hpfreq = cfg.hpfreq;
	c.hpfiltord = cfg.hpfiltord;
	disp('calling ft_preprocessing with the following config file:')
	c	
	d = ft_preprocessing(c,d);
end

%create baseline amplitude
s = [];
s.channel = cfg.channel;
s.latency = cfg.baselinewindow;
s.avgoverchan = 'yes';
s.avgovertime = 'yes';
disp('calling ft_selectdata with the following config file:')
s
temp = ft_selectdata(s,d);
output.baseline = cell2mat(temp.trial);

%create erp amplitude
s.latency = cfg.erpwindow;
temp = ft_selectdata(s,d);
output.erp = cell2mat(temp.trial); 

%correlate baseline and amplitude
temp = corrcoef(output.baseline,output.erp);
output.cor = temp(2);

%save hp frequency setting
output.hpfreq = cfg.hpfreq;

%save config files
output.cfg_filtering = c;
output.cfg_selection = s;

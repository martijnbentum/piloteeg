function [cfg] = prep_nsr_erp_all_pp(cfg,d)
%computes noise to signal ratio, or the loudness of the residue of the trials after substraction of the loudness of the mean (ERP)

if ~isfield(cfg,'erpwindow'),cfg.erpwindow = [0.300 0.500]; end
% store value per participants
if ~isfield(cfg,'squared_differences'),cfg.squared_differences = 0; end
if ~isfield(cfg,'n_trials'),cfg.n_trials =0; end
if ~isfield(cfg,'mean_energy_residuals'),cfg.mean_energy_residuals = 0;end
if ~isfield(cfg,'mean_energy_mean_trial'),cfg.mean_energy_mean_trial = 0; end
if ~isfield(cfg,'nfiles'),cfg.nfiles = 0;end
%channel selection is not implemented, it is trivial to select appropiated channel afterwards
%if ~isfield(cfg,'channels'), cfg.channels= channel_setup([]); end 
%if ~isfield(cfg,'channel_indices'), cfg.channel_indices = channel2index(cfg.channels,d);end
%if strcmp('all',cfg.channels), cfg.channels = d.label; end

disp('cfg structure:')
cfg
%extract baseline and erp window
%------------------------------------------------------------------------------------------
disp('extract  erp window')
c = [];
c.toilim = cfg.erpwindow;
erp = ft_redefinetrial(c,d);

%this is the sample window length, in the default case this should be 200 if the sf = 1000
n_samples = size(erp.trial{1},2);
%this is a constant louis extract from praat to convert to db as it is defined in praat
%this constant shifts the db 0 to hearing threshold
scaling_constant_db = 4*10^-10;

%create a zero matrix to hold the sum over all trials
sum_trial = zeros(size(erp.trial{1}));
for i = 1:length(erp.trial)
	sum_trial = sum_trial + erp.trial{i};
end

disp('sum_trial per channel')
sum_trial

disp('mean_trial per channel')
%calculate the mean trial or the 'erp'
mean_trial = sum_trial / length(erp.trial);
mean_trial

%calculate the difference squared between each trial and the mean (variance)
squared_differences = 0;
for i = 1:length(erp.trial)
	%square difference between trial{1} and mean and sum over rows
	squared_differences = squared_differences + sum( (erp.trial{i}-mean_trial).^2, 2 ) ;
end

disp('squared differences between mean and trials per channel')
squared_differences

%this computes the average per sample energy by normalizing the squared differences by the total number of sample
%and uses a scaling factor used in praat for db calculations (the constant shifts db 0 to hearing threshold, maybe not so relevant here
mean_energy_residuals = (squared_differences / (length(erp.trial) * n_samples))  * scaling_constant_db;

disp('mean energy residuals per channel')
mean_energy_residuals

disp('mean energy mean trial per channel')
mean_energy_mean_trial = (sum( mean_trial.^2, 2 ) / n_samples) * scaling_constant_db;
mean_energy_mean_trial

%10*log10(energy ratio) = db, so in this case the nsr is the noise to signal ratio or the loudness of the residual of the trials after substracting the mean trial
nsr = 10 * log10( mean_energy_residuals ./ mean_energy_mean_trial);
snr = 10 * log10( mean_energy_mean_trial ./ mean_energy_residuals);


if ~isfield(cfg,'mean_trial')
	cfg.mean_trial = mean_trial; 
else
	cfg.mean_trial = (cfg.mean_trial + mean_trial)/2;
end

cfg.squared_differences = cfg.squared_differences + squared_differences;
cfg.n_trials = cfg.n_trials + length(erp.trial);
cfg.mean_energy_residuals =  mean_energy_residuals;
cfg.mean_energy_mean_trial =  mean_energy_mean_trial;
if~isfield(cfg,'n_samples'),cfg.n_sample = size(erp.trial{1},2);
elseif cfg.n_sample ~= n_sample;
	disp('last sample size')
	cfg.n_sample;
	n_sample;
	error('sample size should be equal this is not the case')
end
cfg.nsr = nsr;
cfg.snr = snr;

cfg.nfiles = cfg.nfiles + 1;
cfg.current_file = d.filename





function [cfg] = nsr_erp_all_pp(cfg)
%computes noise to signal ratio, or the loudness of the residue of the trials after substraction of the loudness of the mean (ERP)

scaling_constant_db = 4*10^-10;

disp('cfg structure:')
cfg
%extract baseline and erp window
%------------------------------------------------------------------------------------------
disp('squared differences between mean and trials per channel')
cfg.squared_differences

%this computes the average per sample energy by normalizing the squared differences by the total number of sample
%and uses a scaling factor used in praat for db calculations (the constant shifts db 0 to hearing threshold, maybe not so relevant here
mean_energy_residuals = (cfg.squared_differences / (cfg.n_trials * cfg.n_sample))  * scaling_constant_db;

disp('mean energy residuals per channel')
mean_energy_residuals

disp('mean energy mean trial per channel')
mean_energy_mean_trial = (sum( cfg.mean_trial.^2, 2 ) / cfg.n_sample) * scaling_constant_db;
mean_energy_mean_trial

%10*log10(energy ratio) = db, so in this case the nsr is the noise to signal ratio or the loudness of the residual of the trials after substracting the mean trial
nsr = 10 * log10( mean_energy_residuals ./ mean_energy_mean_trial);
snr = 10 * log10( mean_energy_mean_trial ./ mean_energy_residuals);


cfg.mean_energy_residuals = cfg.mean_energy_residuals + mean_energy_residuals;
cfg.mean_energy_mean_trial = cfg.mean_energy_mean_trial + mean_energy_mean_trial;
cfg.nsr = nsr;
cfg.snr = snr;

cfg.current_file = 'nsr_all_pp' 





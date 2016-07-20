function [n_bad_var_ep,n_bad_dev_ep,n_bad_amp_ep,n_bad_ep,bad_ep,perc_bad_ep,ntrials] = bad_epoch(garbage) 
%extract info from channel statistics, original in a pp specific garbage.mat file

n_bad_var_ep = length(garbage.epoch_var.artifact_trial);
n_bad_dev_ep = length(garbage.epoch_dev.artifact_trial);
n_bad_amp_ep = length(garbage.epoch_amp.artifact_trial);
n_bad_ep = n_bad_var_ep + n_bad_dev_ep + n_bad_amp_ep;
bad_ep = unique([garbage.epoch_var.artifact_trial garbage.epoch_dev.artifact_trial garbage.epoch_amp.artifact_trial]);
n_bad_ep = length(bad_ep);
ntrials = size(garbage.epoch_trl,1);
perc_bad_ep = round((n_bad_ep/ntrials) *100);
bad_ep = num2str(bad_ep(1,:),'%d;');

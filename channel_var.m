function var_info = channel_var(d)
%returns the variance of each channel
%assumes d contains a trial field with 1 cell, the eeg data read in continuously
%computes the variance for each channel and calculates a zscore for the variance of each channel
%labels of channel with a zscore > 3 are stored in bad_channels
%could be removed with ft_channel_repair


cvar = var(d.trial{1}');
zcvar = zscore(cvar);
bad_channels = d.label{find(zcvar > 3)}

var_info = [];
var_info.cvar = cvar;
var_info.zcvar = zcvar;
var_info.bad_channels = bad_channels;


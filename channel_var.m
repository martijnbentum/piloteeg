function var_info = channel_var(d)
%returns the variance of each channel
%assumes d to be a struct with m a matrix, rows=channels, columns=timepoints
%computes the variance for each channel and calculates a zscore for the variance of each channel
%d.label shouls contain the label of each channel, function will label of channel with a zscore > 3 are stored in bad_channels
%bad channels could be removed with ft_channel_repair, which uses interpolate

%output contains channel_variance, zchannel_variance (zscore) and bad_channels, channels with a abs(z-score) > 3
cvar = var(d.m');
zcvar = zscore(cvar);
if ~isempty(d.label(find(abs(zcvar) > 3)))
	bad_channels = d.label(find(abs(zcvar) > 3));%not the brackets should be () to be able to extract multiple elements from cell array d.label 
else
	bad_channels = [];
end

var_info = [];
var_info.cvar = cvar;
var_info.zcvar = zcvar;
var_info.var_bad_channels = bad_channels;


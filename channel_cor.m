function ccor = channel_cor(d)
%returns the mean pearson correlation coefficient of each channel with all other channels
%assumes d to be a struct with m a matrix, rows=channels, columns=timepoints
%computes a zscore for the mean correlation score of each channel
%d.label shouls contain the label of each channel, function will label of channel with a zscore > 3 are stored in bad_channels
%bad channels could be removed with ft_channel_repair, which uses interpolate

%output contains channel_mean_cor, zchannel_cor (zscore) and bad_channels, channels with a abs(z-score) > 3
channel_corr = corrcoef(d.m');%each row contains the correlation of that channel with the other channel, column 1, correlation current channel with channel 1, etc.
channel_corr_mean = mean(channel_corr')';%the mean correlation of each channel
zchannel_corr_mean = zscore(channel_corr_mean);
if ~isempty(d.label(find(abs(zchannel_corr_mean) > 3)))
		  bad_channels = d.label(find(abs(zchannel_corr_mean) > 3));%note that brackets should be () for indexing the cellarray, otherwise only one element will be extracted.
else
	bad_channels = [];
end
ccor = [];
ccor.corr = channel_corr;
ccor.corr_mean = channel_corr_mean;
ccor.z_corr_mean = zchannel_corr_mean;
ccor.corr_bad_channels = bad_channels;


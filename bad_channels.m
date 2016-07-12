function [n_bad_var_ch,n_bad_cor_ch,n_bad_ch,bad_ch] = bad_channels(garbage);
%extract info from channel statistics, original in a pp specific garbage.mat file

n_bad_var_ch = length(garbage.channel_var.var_bad_channels);
n_bad_cor_ch = length(garbage.channel_cor.corr_bad_channels);
bad_ch = unique([garbage.channel_var.var_bad_channels' garbage.channel_cor.corr_bad_channels']);
n_bad_ch = length(bad_ch);

%concatenate channel labels with ',', because writing to file does not accept cells
if ~isempty(bad_ch)
	bad_ch = strjoin(bad_ch,',');
else
	bad_ch = 'none'%make explicit that no channels were bad
end

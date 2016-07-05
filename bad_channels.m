function [n_bad_var_ch,n_bad_cor_ch,n_bad_ch,bad_ch] = bad_channels(channel);
%extract info from channel statistics, original in a pp specific garbage.mat file

n_bad_var_ch = length(channel.var.var_bad_channels);
n_bad_cor_ch = length(channel.cor.corr_bad_channels);
bad_ch = unique([channel.var.var_bad_channels' channel.cor.corr_bad_channels']);
n_bad_ch = length(bad_ch);

%concatenate channel labels with ',', because writing to file does not accept cells
if ~isempty(bad_ch)
	bad_ch = strjoin(bad_ch,',');
else
	bad_ch = 'none'%make explicit that no channels were bad
end

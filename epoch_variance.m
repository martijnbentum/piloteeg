function epoch_var = epoch_variance(d)

epoch_var = [];
epoch_v = [];
for i = 1 : length(d.trial)
	temp = mean(var(d.trial{i})'); 
	epoch_v = [epoch_v temp];
end
zscore_var = zscore(epoch_v);

epoch_var.var = epoch_v;
epoch_var.zscore_var = zscore_var;
indices = find(abs(zscore_var) > 3);
epoch_var.artifact_trial = indices;

artifact_sampleinfo = [];
for i =1 : length(indices)
	artifact_sampleinfo = [artifact_sampleinfo d.sampleinfo(indices(i),:)];
end
epoch_var.artifact_sampleinfo = artifact_sampleinfo;

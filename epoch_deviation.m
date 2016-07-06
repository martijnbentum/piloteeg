function epoch_dev = epoch_deviation(d)

m = concatenate_trials(d);

epoch_dev = [];
epoch_d = [];
for i = 1 : length(d.trial)
	temp = mean(mean(d.trial{i}') - mean(m')); 
	epoch_d = [epoch_d temp];
end
zscore_deviance = zscore(epoch_d);

epoch_dev.dev = epoch_d;
epoch_dev.zscore_dev = zscore_deviance;
indices = find(abs(zscore_deviance) > 3);
epoch_dev.artifact_trial = indices;

artifact_sampleinfo = [];
for i =1 : length(indices)
	artifact_sampleinfo = [artifact_sampleinfo d.sampleinfo(indices(i),:)];
end
epoch_dev.artifact_sampleinfo = artifact_sampleinfo;

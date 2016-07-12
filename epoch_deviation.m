function epoch_dev = epoch_deviation(d)
disp('calculatting epoch_deviation')

m = concatenate_trials(d);
mean_channels = mean(m');
epoch_dev = [];
epoch_d = zeros(1,1690);
for i = 1 : length(d.trial)
	temp = mean(mean(d.trial{i}') - mean_channels); 
	epoch_d(i) = temp;
end
zscore_deviance = zscore(epoch_d);

epoch_dev.dev = epoch_d;
epoch_dev.zscore_dev = zscore_deviance;
indices = find(abs(zscore_deviance) > 3);
epoch_dev.artifact_trial = indices;

artifact_sampleinfo = [];
for i =1 : length(indices)
	artifact_sampleinfo = [artifact_sampleinfo; d.sampleinfo(indices(i),:)];
end
epoch_dev.artifact_sampleinfo = artifact_sampleinfo;

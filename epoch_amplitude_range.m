function epoch_amp = epoch_amplitude_range(d)

amp_range = [];
for i = 1 : length(d.trial)
	minamp = min(min(d.trial{i}));
	maxamp = max(max(d.trial{i}));
	temp =  maxamp - minamp;
	amp_range = [amp_range temp];
end
zscore_amp_range = zscore(amp_range);

epoch_amp.ranges = amp_range;
epoch_amp.zscore_ranges = zscore_amp_range;
indices = find(abs(zscore_amp_range) > 3);
epoch_amp.artifact_trial = indices;

artifact_sampleinfo = [];
for i =1 : length(indices)
	epoch_amp.artifact_sampleinfo = d.sampleinfo(indices(i),:)
	artifact_sampleinfo = [artifact_sampleinfo d.sampleinfo(indices(i),:)];
end
epoch_amp.artifact_sampleinfo = artifact_sampleinfo;

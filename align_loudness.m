function loudness = align_loudness(loudness,d,story_id)
%l is one of the loudness options inst short t or long t (average)
%currently the trials start first word story - 200, this does not correspond to the start of the audio file, the files should be aligned. futhermore the end of the file is not aligned with the audio file (last word + 1000)
%this function aligns the loudness with trial data and makes them of equal length

[rows cols] = size(loudness);
if rows > cols
	loudness = loudness';
end

index = find(d.trialinfo == story_id,1);
len_loudness = length(loudness);
len_trial = length(d.trial{index});


story_start_sample = storyid2samplen(story_id,d)
trial_start_sample = d.sampleinfo(index,1)

start_dif =  story_start_sample - trial_start_sample 

if start_dif > 0
	disp('%audio file started after first eeg sample of this trial')
	disp('%padding with zeros')
	loudness = [zeros(1,start_dif) loudness];
elseif start_dif < 0
	disp('%audio file started before first eeg sample of this trial')
	disp('%removing loudness samples')
	loudness = loudness(1,start_dif + 1:end);
else
	disp('%audio file started at the first eeg sample of this trial')
	disp('%nothing to be done')
	loudness = loudness;
end

len_loudness = length(loudness);
len_dif = len_trial - len_loudness
	
if len_dif > 0
	disp('loudness is shorter compared to trial')
	disp('padding with zeros')
	loudness = [loudness zeros(1,len_dif)];
elseif len_dif < 0
	disp('loudness is longer compared to trial')
	disp('removing loudness samples')
	loudness = loudness(1,1:length(loudness) + len_dif);
	% len dif is added because in this case it is negative
else
	disp('trial and loudness are of equal length')
	loudness = loudness;
end

length(loudness)
len_trial

if length(loudness) ~= len_trial
	error('ERROR length of the loudness envelope does not correspond to the trial length this should NOT happen')
end	

function dloudness = create_loudness_d(d)

% takes the d stories structure
% outputs the aligned loudness in a fieldtrip datastructure
% this could be used to removal unwanted timesample so i can do mtrf on post ica files

dloudness = d;
[pathstr,name,ext] = fileparts(d.filename);
dloudness.filename = strcat(name(1:7),'_inst-loudness');
dloudness.label = {'loudness'};

for i = 1:length(dloudness.trialinfo)
	story_id = dloudness.trialinfo(i);
	loudness = storyid2loudness(story_id);
	loudness = loudness.inst;
	dloudness.trial{i} = align_loudness(loudness,d,story_id);
end


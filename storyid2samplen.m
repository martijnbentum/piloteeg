function samplen = storyid2samplen(storyid,d)
%return sample number of story id. it expects an integer storyid and a fieltrip datastructure with filename, uses filename to load cfg file of same pp /d, which is used to find the correct samplenumber

%create story marker
story_marker = strcat({'S '},num2str(storyid));
if length(story_marker) == 3
	story_marker =strcat({'S  '},num2str(storyid));
end

story_marker = char( story_marker );

%check whether story marker is correct
if length(story_marker) ~= 4
	disp(length(story_marker));
	disp(story_marker)
	disp(storyid)
	error('length story marker does not equal 4')
end

%load cfgstory file, this holds the all marker values
[path,name,ext]= fileparts(d.filename);

pp_id = name(1:7);
cfg_filename = strcat(pp_id,'_cfgstories.mat');
cfg = load(cfg_filename);


%find the marker that corresponds with the story marker
for i = 1 : length( cfg.d.event )
	if strcmp(cfg.d.event(i).value,story_marker)
		samplen = cfg.d.event(i).sample
		break
	end
end



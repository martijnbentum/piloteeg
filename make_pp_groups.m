function pp = make_pp_groups()
%loads all cfg files and stores file id corresponding to each group (day and reduction)
fn = dir('EEG/*_cfg.mat');

pp = [];
pp.day1.reduced.file_id = [];
pp.day3.reduced.file_id = [];

pp.day1.unreduced.file_id = [];
pp.day3.unreduced.file_id = [];

for i = 1 : length(fn)
	load(fn(i).name);
	disp(fn(i).name)
	cfg_clean = d;
	info = cfg_clean.event(1).selection(1);
	if info.day_id == 1%all recordings from day1
		if info(1).reduced == 1%selecting all unreduced recordings
			pp.day1.unreduced.file_id = [pp.day1.unreduced.file_id {fn(i).name(1:7)}];
		elseif info(1).reduced == 2%selecting all reduced recordings
			pp.day1.reduced.file_id = [pp.day1.reduced.file_id {fn(i).name(1:7)}];
		else
			error(strcat(fn(i).name,info(1).reduced,' reduced should be one or 2, it is neither'));
		end
	elseif info.day_id == 3%all recording from day 3
		if info(1).reduced == 1%selecting all unreduced recordings
			pp.day3.unreduced.file_id = [pp.day3.unreduced.file_id {fn(i).name(1:7)}];
		elseif info(1).reduced == 2%selecting all reduced recordings
			pp.day3.reduced.file_id = [pp.day3.reduced.file_id {fn(i).name(1:7)}];
		else
			error(strcat(fn(i).name,info(1).reduced,' reduced should be one or 2, it is neither'))
		end
	else
		error(strcat(fn(i).name,info(1).day_id,' day_id should be one or 3, it is neither'))
	end
end


%pp_groups = pp;

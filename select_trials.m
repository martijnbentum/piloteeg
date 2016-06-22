function  pp = select_trials(pp)

reduced = [1 2];
day_id = [1 3];
red = {'unreduced' 'reduced'};
day = {'day1' 'day3'};
%day 1 unreduced

for day_index = 1:2	
	%loops through all conditions
	for r = reduced
	%with setfield you can set specific field in an struct	
		fn = getfield(pp,strjoin(day(day_index)),strjoin(red(r)));
		disp(strcat(day(day_index),'-',red(r)))
		for i = 1:length(fn.file_id)
			disp(strcat(fn.file_id(i),'_clean.mat'))
			load(strcat(strjoin(fn.file_id(i)),'_clean.mat'))
			cfg_clean = load(strcat(strjoin(fn.file_id(i)),'_cfg.mat'));
			cfg = [];
			cfg.filename = strcat(strjoin(fn.file_id(i)),'_clean.mat');
			cfg.n_orignal_trl = length(d.trial);
			cfg = setfield(cfg,'reduced',reduced(r));
			cfg = setfield(cfg,'day_id',day_id(day_index));
			cfg = create_condition(cfg,d);
			cfg.rejected_trials = cfg_clean.d.rejected_trials;
			cfg.all_trl_remove = unique([cfg.remove_trials cfg.rejected_trials]);
			pp = setfield(pp,strjoin(day(day_index)),strjoin(red(r)),strjoin(fn.file_id(i)),cfg)
			%pp.day1.unreduced.remove_trials = [d1_unred.remove_trials cfg_clean.d.rejected_trials]
			%disp(cfg)
		end
	end
end

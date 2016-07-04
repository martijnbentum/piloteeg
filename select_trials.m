function  pp = select_trials(pp)
%use the pp structure that holds pp according to day (1,3) and reduction (reduced, unreduced) created in make_pp_groups. THis function adds fields for each participant in a specific condition (name = file_id) and stores the trials to be removed all_trl_remove, this combines trials threshold rejected and trials that are closed class (it leaves all open class words. Futher info: filename of the clean file (after ica correction) n trials

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
			
			%load d file and cfg file; d file is for trialinfo and cfg is for rejected
			load(strcat(strjoin(fn.file_id(i)),'_clean.mat'))
			cfg_clean = load(strcat(strjoin(fn.file_id(i)),'_cfg.mat'));

			%create cfg for create condition
			cfg = [];
			cfg.filename = strcat(strjoin(fn.file_id(i)),'_clean.mat');
			cfg.n_orignal_trl = length(d.trial);
			cfg = setfield(cfg,'reduced',reduced(r));
			cfg = setfield(cfg,'day_id',day_id(day_index));
			
			%find all open and closed and pseudoword trials
			cfg = create_condition(cfg,d);
			
			%find quantiles of logprobs, and select trials
			keep = setdiff(cfg.open_class_trials, cfg.pseudoword_trials);
			ti_open = d.trialinfo(keep,:);  
			cfg.lower_q = quantile(ti_open(:,9),[0.25]);
			cfg.higher_q = quantile(ti_open(:,9),[0.75]); 
			cfg = create_condition(cfg,d);

			%add extra info to the file id struct
			cfg.rejected_trials = cfg_clean.d.rejected_trials;
			cfg.rm_trl_word_condition = unique([cfg.closed_class_trials cfg.pseudoword_trials cfg.rejected_trials]);

			%save it to the pp struct
			pp = setfield(pp,strjoin(day(day_index)),strjoin(red(r)),strjoin(fn.file_id(i)),cfg)
			%pp.day1.unreduced.remove_trials = [d1_unred.remove_trials cfg_clean.d.rejected_trials]
			%disp(cfg)
		end
	end
end

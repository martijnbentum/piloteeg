function  pp = create_averages(pp)

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
		%for each pp in condition calculate the average (this is not demeaned, but you can do this afterwards
			disp(strcat(fn.file_id(i),'_clean.mat'))%show filename
			load(strcat(strjoin(fn.file_id(i)),'_clean.mat'))%load file
			cfg = getfield(fn, strjoin(fn.file_id(i)))%extract pp info

			%extract all trials with open class words
			d1 = remove_trials(cfg.rm_trl_word_condition,d);%use the specified trl from select trials to select trials	

			%calc all open class word average
			open_class_avg = ft_timelockanalysis([],d1);%create average	
			pp = setfield(pp,strjoin(day(day_index)),strjoin(red(r)),strjoin(fn.file_id(i)),'open_class_avg',open_class_avg);%add the pp avg to the datastructure of the specific participant 
			%calc lower_q average
			not_lower_q = setdiff(1:length(d.trialinfo),cfg.lower_q_trials);
			remove_trl_lower_q = unique([not_lower_q cfg.rm_trl_word_condition]);
			d1 = remove_trials(remove_trl_lower_q,d);%use the specified trl from select trials to select trials	
			lower_q_avg = ft_timelockanalysis([],d1);
			pp = setfield(pp,strjoin(day(day_index)),strjoin(red(r)),strjoin(fn.file_id(i)),'lower_q_avg',lower_q_avg);%add the pp avg to the datastructure of the specific participant 

			%calc higher_q average
			not_higher_q = setdiff(1:length(d.trialinfo),cfg.higher_q_trials);	
			remove_trl_higher_q = unique([not_higher_q cfg.rm_trl_word_condition]);
			d1 = remove_trials(remove_trl_higher_q,d);%use the specified trl from select trials to select trials	
			higher_q_avg = ft_timelockanalysis([],d1);
			pp = setfield(pp,strjoin(day(day_index)),strjoin(red(r)),strjoin(fn.file_id(i)),'higher_q_avg',higher_q_avg);%add the pp avg to the datastructure of the specific participant 


		end
	end
end

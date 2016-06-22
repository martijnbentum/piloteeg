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
			disp(strcat(fn.file_id(i),'_clean.mat'))
			load(strcat(strjoin(fn.file_id(i)),'_clean.mat'))
			cfg = getfield(fn, strjoin(fn.file_id(i)))
			d = remove_trials(cfg.all_trl_remove,d);			
			
		end
	end
end

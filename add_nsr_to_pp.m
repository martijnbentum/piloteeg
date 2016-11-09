function  pp = add_nsr_to_pp(pp)


% d_filename = '_clean_word_interpolate_alt.mat'

% file without mtrf modification
% d_filename = '_clean_word_interpolate_nf.mat'

% file with mtrf modification
d_filename = '_clean_word_interpolate_nf_recon.mat'



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
			nsr = [];
			disp(strcat(fn.file_id(i),d_filename))%show filename
			load(strcat(strjoin(fn.file_id(i)),d_filename))%load file
			cfg = getfield(fn, strjoin(fn.file_id(i)))%extract pp info

			%extract all trials with open class words
			d1 = remove_trials(cfg.rm_trl_word_condition,d);%use the specified trl from select trials to select trials	
			nsr = prep_nsr_erp_all_pp(nsr,d1); 	
			pp = setfield(pp,strjoin(day(day_index)),strjoin(red(r)),strjoin(fn.file_id(i)),'nsr',nsr);%add nsr info
		end
	nsr = nsr_erp_all_pp(nsr);
	pp = setfield(pp,strjoin(day(day_index)),strjoin(red(r)),'nsr_all',nsr);%add nsr info
	end
end

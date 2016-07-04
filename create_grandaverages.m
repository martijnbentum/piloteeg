function pp = create_grandaverages(pp,day,red,avg)
c = getfield(pp,day,red);
%c = pp.day1.unreduced;
avgs = cell( 1,length( c.file_id ) );
for i = 1:length( c.file_id )
	%create a structure that holds all averages of the condition
	avgs{i} = getfield(c, strjoin(c.file_id(i)),avg)
end
%create grandaverage
gavg = ft_timelockgrandaverage([],avgs{:})
pp = setfield(pp,day,red,strcat('grand_',avg),gavg)
%{
%work in progress, now only copy from create averages
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
			%load each ppk
			disp(strcat(fn.file_id(i),'_clean.mat'))%show filename
			load(strcat(strjoin(fn.file_id(i)),'_clean.mat'))%load file
			cfg = getfield(fn, strjoin(fn.file_id(i)))%extract pp info
			d = remove_trials(cfg.all_trl_remove,d);%use the specified trl from select trials to select trials	
			avg = ft_timelockanalysis([],d);%create average	
			pp = setfield(pp,strjoin(day(day_index)),strjoin(red(r)),strjoin(fn.file_id(i)),'avg',avg);%add the pp avg to the datastructure of the specific participant 
		end
	end
end
%}


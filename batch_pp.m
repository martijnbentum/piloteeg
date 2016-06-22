%create processingpool
workers = 10
pilot = parpool(workers,'IdleTimeout',10);
% preprocessing -> load data filter and creat eog channels
%load all filesnames
fn = dir('EEG/*.vhdr')
%prepare configuration files
parfor i =1:length(fn)
        cfg = define_trial(strcat('EEG/',fn(i).name));
        cfg = ft_definetrial(cfg);
	output = strcat('EEG/',fn(i).name(1:7),'_cfg');
	write_file(output,cfg);
end


%load all data
fn = dir('EEG/*cfg.mat')
parfor i = 1:length(fn)
	cfg = load(fn(i).name);
	d = ft_preprocessing(cfg.d);
	d = extract_eog(d);
	d = get_blink_trial(cfg.d.trl,d);
	d.cfg = '';
	output = strcat(cfg.d.headerfile(1:11),'_preproc');
	write_data(output,d);
end

%write files list to files
fn = dir('EEG/*preproc.mat');                                               
fout = fopen('preproc_file_list.txt','w');
for i = 1:length(fn)
	    fprintf(fout,'%20s',fn(i).name);
    end
fclose(fout);

%pp info, ntrial nblinktrial perc badtrials preproc data
fn = dir('EEG/*preproc.mat');
fout = fopen('pp_bad_trial_info_preproc.txt','w');   
for i = 1 : length(fn)
    load(fn(i).name);
    disp(fn(i).name);
    [bt,nbt,nt,perc] = perc_bad_trials(d);
    fprintf(fout,'%7s %4d %4d %4d\n',fn(i).name(1:7),nbt,nt,perc);  
end
fclose(fout);
%exit

% ICA and correlate components with eog channels

fn = dir('EEG/*preproc.mat')

for i = 1 : length(fn)
    load(fn(i).name)
    d = ica_and_corr(d)
    output = strcat(fn(i).name(1:7),'_ica')
    d.filename = output
    d.input_file = fn(i).name
    write_data(output,d)

end

% plot ICA with eog correlation values

fn = dir('EEG/*ica.mat')

for i = 1 : length(fn)
    load(fn(i).name)
    create_ica_plot(d)
end
%-----------------------

%check frequencies the frequencies for the preproc data (test if the
%lowpass filter worked
%trial_numbers = 36:72:1720;
trial_number = 1000;
fn = dir('EEG/*preproc.mat');

%periodograms = {1,length(fn)};
for i = 1 : length(fn)
    disp(fn(i).name)
    disp(i)
    load(fn(i).name);
    [freqs, periodogram] = check_frequencies(1000,d.trial{trial_number}(21,:));%channel Cz
    create_periodogram_plot(freqs,periodogram,'Cz',fn(i).name(1:7));
end

%-------------------------

%Add the components that need to be removed tot he all_pp -> all_pp_new

all_pp = bad_comp_all_pp();%creates a datastructure with file id and to be removed components
%Recompose data without the bad components
for i =  s : length(all_pp)
   disp(all_pp(i).file_id)
    d = extract_components(all_pp(i)) %recomposes the data withou the bad components
    write_data(d.filename,d)
end

%--------------------------

%create plots (of blink trials, that compare ica-cleaned-data with the preproc-data

all_pp = bad_comp_all_pp();%creates a datastructure with file id and to be removed components
for i = 1 : length(all_pp);
    plot_clean_preproc(all_pp(i)) %plots 10 blink trials
end

%---------------------------

%find all trials that exceed threshold and save it to the cfg file, this can be used lateron to be removed before other steps, use this code:
%cfg.trials = setdiff(1:length(d.trial),preproc_cfg.d.rejected_trials);
%d        = ft_selectdata(cfg, d); 

fn = dir('*_clean.mat');
for i = 1 : length(fn)
    load(fn(i).name)
    cfg = check_threshold(d) %removes all trials that exceeds -75 75 mu volts
    output = strcat(fn(i).name(1:7),'_cfg');
    write_file(output,cfg)
end

%---------------------------
%important note, I did not make clean_threshold files, to save on disk space

%it is thus very important to remove the rejected trials each time i load the 
%clean files, i will write a function called reject_files to do this.

%-------------------------  
pp = make_pp_groups();
save('pp_groups.mat','pp')
pp = select_trials(pp);
save('pp_condition_trials.mat','pp')
pp = create_average(pp);
save('pp_condition_averages.mat','pp')


%create averages for all conditions and create difference waves, put them
%in 1 data structure

fn = dir('ppn*clean_threshold.mat')
for i = 1 : length(fn)
    fn(i).name
    load(fn(i).name);
    conditions = [];
    [s,dev,dif] = create_conditions(data);
    conditions.filename = strcat(fn(i).name(1:5),'_conditions.mat');
    conditions.standard = s;
    conditions.deviant = dev;
    conditions.difference = dif;
    conditions.channel_labels = data.label;
    save(conditions.filename,'conditions');
end


%--------------------------------
%create plots of all conditions
load_conditions
for i = 1:length(all_pp_con)
    participant = all_pp_con{i}
    for n = 1:6
        plot_conditions(participant,n)
        plot_difference_waves(pp)
    end
end


%-------
%create grand averages
load_conditions
grand_average = compute_grandaverage(all_pp_con,'yes')
grand_average_n.avg = compute_grandaverage(all_pp_con,'no')
grand_average_n.conditions = all_pp_con{1}.deviant.label

%plot grand averages
plot_grand_average(grand_average_n)


fn = dir('ppn*clean_threshold.mat')
for i = 1 : length(fn)
    fn(i).name
    load(fn(i).name);
    create_bins(data);
end

stat = compute_cluster(grand_average)
save('stats.mat', 'stat')

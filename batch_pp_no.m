%create processingpool
workers =10
pilot = parpool(workers,'IdleTimeout',10);
% preprocessing -> load data filter and create eog channels
%load all filesnames
fn = dir('EEG/*.vhdr')
%prepare configuration files
parfor i =1:length(fn)
        cfg = define_trial(strcat('EEG/',fn(i).name));
        cfg = ft_definetrial(cfg);
	output = strcat('EEG/',fn(i).name(1:7),'_cfgstories');
	write_file(output,cfg);
end


%load all data
fn = dir('EEG/*cfgstories.mat')
parfor i = 1:length(fn)
	cfg = load(fn(i).name);
	d = ft_preprocessing(cfg.d);
	d = extract_eog(d);
	%collect channel and epoch statistics (epochs are defined shorter 1s, because trials are long)
	garbage = garbage_collection(d);%garbage contains info aboutgchannels epoch that are questionable
	garbage_out = strcat(cfg.d.headerfile(1:11),'_garbage');
	write_file(garbage_out,garbage);
	%store data file
	d = rmfield(d,'cfg');
	output = strcat(cfg.d.headerfile(1:11),'_preprocstories');
	d.filename = output
	write_data(output,d);
end

%write files list to files
fn = dir('EEG/*preprocstories.mat');                                               
fout = fopen('preproc_file_liststories.txt','w');
for i = 1:length(fn)
	    fprintf(fout,'%20s',fn(i).name);
    end
fclose(fout);

%pp info, ntrial nblinktrial perc badtrials preproc data
fn = dir('EEG/*garbage.mat');
fout = fopen('pp_bad_trial_info_preprocstories.txt','w');   
for i = 1 : length(fn)
    load(fn(i).name);
    disp(fn(i).name);
	 blinks = d.blinks;
    [bt,nbt,nt,perc] = perc_blink_trials(blinks);
	 channel = d.channel;
	 [n_bad_var_ch,n_bad_cor_ch,n_bad_ch,bad_ch] = bad_channels(channel);
    fprintf(fout,'%7s %4d %4d %2d %2d %2d %2d %s\n',fn(i).name(1:7),nbt,nt,perc,n_bad_var_ch,n_bad_cor_ch,n_bad_ch,bad_ch);  
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

fn = dir('EEG/*_clean.mat');
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
%
%-------------------------  
%i need to add the logprob values to the trialinfo in the d files, if logprob =
% 999.99 this means that the word was not part of the vocabulary, this means that
% the word is most probably one of the pseudowords in the stories, these words
% should be removed from the analysis
fn = dir('EEG/*_clean.mat');
for i = 2 : length(fn)
	load(fn(i).name)
	disp(fn(i).name)
	ti = add_logprob(d);
	d.old_trialinfo = d.trialinfo;
	d.trialinfo = ti;
	write_data(strcat('EEG/',d.filename),d)
end
%--------------------------
pp = make_pp_groups();
save('pp_groups.mat','pp')
load('pp_groups.mat')
pp = select_trials(pp);
save('pp_condition_trials.mat','pp')
load('pp_condition_trials.mat')
pp = create_averages(pp);
save('pp_condition_averages.mat','pp')
load('pp_condition_averages.mat')

pp = create_grandaverages(pp,'day1','unreduced','open_class_avg');
pp = create_grandaverages(pp,'day1','unreduced','lower_q_avg');
pp = create_grandaverages(pp,'day1','unreduced','higher_q_avg');

pp = create_grandaverages(pp,'day3','unreduced','open_class_avg');
pp = create_grandaverages(pp,'day3','unreduced','lower_q_avg');
pp = create_grandaverages(pp,'day3','unreduced','higher_q_avg');

cfg = []
cfg.demean='yes'   
cfg.baselinewindow=[-0.150 0]


oc1 =pp.day1.unreduced.grand_open_class_avg       
lq1 =pp.day1.unreduced.grand_lower_q_avg 
hq1 =pp.day1.unreduced.grand_higher_q_avg  

ocb1 = ft_preprocessing(cfg,oc1)                                                 
lqb1 = ft_preprocessing(cfg,lq1)                                
hqb1 = ft_preprocessing(cfg,hq1)                                                            

oc3 =pp.day3.unreduced.grand_open_class_avg       
lq3 =pp.day3.unreduced.grand_lower_q_avg 
hq3 =pp.day3.unreduced.grand_higher_q_avg  


ocb3 = ft_preprocessing(cfg,oc3)
lqb3 = ft_preprocessing(cfg,lq3)
hqb3 = ft_preprocessing(cfg,hq3)                           

hold off
plot(lq.time,lqb1.avg(19,:))  
hold on
plot(lq.time,hqb1.avg(19,:))  
plot(lq.time,ocb1.avg(19,:))                                                              
legend('lq','hq','oc1')

hold off
plot(lq.time,lqb3.avg(19,:))  
hold on
plot(lq.time,hqb3.avg(19,:))  
plot(lq.time,ocb3.avg(19,:))  
legend('lq','hq','oc3')

gavg_lq = ft_timelockgrandaverage([],lqb1,lqb3)    
gavg_hq = ft_timelockgrandaverage([],hqb1,hqb3)
gavg_oc = ft_timelockgrandaverage([],ocb1,ocb3)    

hold off
plot(lq.time,gavg_lq.avg(19,:))  
hold on
plot(lq.time,gavg_hq.avg(19,:))  
plot(lq.time,gavg_oc.avg(19,:))  
legend('lq','hq','oc 1 3')

save('pp_grand_averages.mat','pp')
load('pp_grand_averages.mat','pp')

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

%create processingpool
workers =15
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
	%store data file
	d = rmfield(d,'cfg');
	output = strcat(cfg.d.headerfile(1:11),'_preprocstories');
	d.filename = output
	write_data(output,d);
end

%load all data
fn = dir('EEG/*preprocstories.mat')
%i create garbage files before, and i want to skip blink detection, so i will load old garbage files and run garbage collection without blink detection. I will set epoch time 200 ms, to get a more finegrained rejection
fn_garbage = dir('EEG/*garbage.mat')
parfor i = 1:length(fn)	
	%collect channel and epoch statistics (epochs are defined shorter (e.g. 500ms), because trials are long)
	%select subset of channels, eog channels are defined in garbage_collection, could be given in cfg.eog_channel
	d = load(fn(i).name);
	d = d.d;
	cfg = [];
	%use old garbage files, turn of if you do not want to use the old files
	%g = load(fn_garbage(i).name);
	%cfg.garbage = g.d;
	%---------------------------
	cfg.check_blinks = 'yes' %(if i redefine epoch length, blinks need to be rechecked blinks are already part of the old garbage file, so i can skip this time step
	cfg.channel = {'all'};%only exclude eog channels
	cfg.length = 1% Iwill switch back to epoch of 1 s. With short epochs the changes of outliers are boosted, because small samples will show more extreme behavior. duration of epoch in seconds

	garbage = garbage_collection(cfg,d);%garbage contains info aboutgchannels epoch that are questionable
	garbage_out = strcat(d.filename(1:11),'_garbage');
	write_file(garbage_out,garbage);	
end

%write files list to files
fn = dir('EEG/*preprocstories.mat');                                               
fout = fopen('preproc_file_liststories.txt','w');
for i = 1:length(fn)
	    fprintf(fout,'%20s',fn(i).name);
    end
fclose(fout);

fn = dir('EEG/*garbage.mat');
fout = fopen('pp_bad_trial_info_preprocstories_ch_ep.txt','w');   
ftrial_reject = fopen('pp_epoch_bad_trial.txt','w');
for i = 1 : length(fn)
    load(fn(i).name);
    disp(fn(i).name);
	 blinks = d.blinks;
    [bt,nbt,nt,perc] = perc_blink_trials(blinks);
	 [n_bad_var_ch,n_bad_cor_ch,n_bad_ch,bad_ch] = bad_channels(d);
	 %pp_id n_blinktrial ntrials_chunks per_blink_trials n_var_bad_channels n_cor_bad_channels bad_channels
    fprintf(fout,'%7s %4d %4d %2d %2d %2d %2d %s\n',fn(i).name(1:7),nbt,nt,perc,n_bad_var_ch,n_bad_cor_ch,n_bad_ch,bad_ch);  
	 [n_bad_var_ep,n_bad_dev_ep,n_bad_amp_ep,n_bad_ep,bad_ep,perc_bad_ep,ntrials] = bad_epoch(d);
    fprintf(fout,'%7s %4d %4d %4d %4d %2d %2d\n',fn(i).name(1:7),n_bad_var_ep,n_bad_dev_ep,n_bad_amp_ep,n_bad_ep,ntrials,perc_bad_ep);
    fprintf(ftrial_reject,'%7s,%s\n',fn(i).name(1:7),bad_ep);
end
fclose(fout);
fclose(ftrial_reject);
%---------------------------------------------------------

%create reject files, by removing all bad epoch from data
all_pp = bad_epoch_all_pp();%creates a datastructure with file id and to be removed epochs
parfor i =  1 : length(all_pp)
   disp(all_pp(i).file_id)
    d = take_out_garbage_epoch(all_pp(i)) %recomposes the data withou the bad epoch
    write_data(d.filename,d)
end

%create blink trial indices for each pp in the pre ica files
fn = dir('EEG/*_reject.mat')
for i = 5 : length(fn)
	load(fn(i).name)
	cfg = []
	cfg.c = d.cfg_redefine
	cfg.check_epoch = 'no'
	cfg.check_channel = 'no'	
	blinks = garbage_collection(cfg,d)
	blinks_out = strcat(d.filename(1:7),'_rejectblink')
	write_file(blinks_out,blinks)
end


% ICA and correlate components with eog channels

fn = dir('EEG/*reject.mat')

for i = 1 : length(fn)
    load(fn(i).name)
    d = ica_and_corr(d)
    output = strcat(fn(i).name(1:11),'_ica')
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
%fix filenames ica files. Filenames are stored in the data structure and the wrong name is stored.
%This will fixed it
%done done done done done done done done done done 
fn = dir('EEG/*ica.mat')
for i = 1:length(fn)
	load(fn(i).name)
	d.filename = fn(i).name
	write_data(fn(i).name,d)
end
%------------------------------

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
for i =  1 : length(all_pp)
   disp(all_pp(i).file_id)
    d = extract_components(all_pp(i)) %recomposes the data withou the bad components
    write_data(d.filename,d)
end
%----------------------------------------
%channel variance
%----------------------------------------
%check channel variance on post ica files
%this is to determine which channels should be interpolated
fn = dir('EEG/*_clean.mat')
for i = 1: length(fn)
	load(fn(i).name)
	disp(d.filename)
	c = [];
	c.check_epoch = 'no';
	c.check_blinks = 'no';
	c.check_channel = 'yes';
	cfg_channel = garbage_collection(c,d);	
	output = strcat(fn(i).name(1:7),'_cfgchannel');
	write_file(output,cfg_channel);
end

%write channel variance to text file
fn = dir('EEG/*cfgchannel.mat');
fout = fopen('cleandata_channel_noise.txt','w');   
for i = 1 : length(fn)
	load(fn(i).name)
	[n_bad_var_ch,n_bad_cor_ch,n_bad_ch,bad_ch] = bad_channels(d);
	%pp_id n_blinktrial ntrials_chunks per_blink_trials n_var_bad_channels n_cor_bad_channels bad_channels
   fprintf(fout,'%7s %2d %2d %2d %s\n',fn(i).name(1:7),n_bad_var_ch,n_bad_cor_ch,n_bad_ch,bad_ch);  
end
fclose(fout);
%----------------------------------------
%end channel variance
%----------------------------------------

%------------------------------------------------------------------------------------------
%check threshold and return bad trial indices for each pp in the post ica files (clean)
% 01/09/16 11:40, this is on the story trial, percentage gives an idea, but it could be an improvement
%to first do story2word_trials, to make it a better comparison with the interpolated word files
fn = dir('EEG/*_clean.mat')
parfor i = 1 : length(fn)
	d = load(fn(i).name)
	d = d.d
	disp(d.filename)
	cfg = check_threshold(d);
	output = strcat(fn(i).name(1:7),'_threshold_cleancfg')
	write_file(output,cfg)
end

%check threshold for overlap files to check whether it is worse for no overlap files
% 01/09/16 11:41 I found that some PP have a lot of threshhold rejected trials I could not remember
%that this happened for the overlap version of the analysis, therefore i check the n threshrejected trials
%of that analysis below. I found that in most cases it is similar with some improvement for the new
%analysis. Only 08_03 was significantly worse 11 -> 83% rejected. Futhermore, the range of amplitudes of the no_overlap files seems to be larger. This could because in the overlap case the high pass filter immediately corrects any offset, while in the no overlap case this will not happen.
fn = dir('EEG/CLEAN_OVERLAP/*_clean.mat')
parfor i = 1 : length(fn)
   d = load(strcat('EEG/CLEAN_OVERLAP/',fn(i).name))
   d = d.d
   disp(d.filename)
   cfg = check_threshold(d);
   output = strcat(fn(i).name(1:7),'_clean_overlapcfg')
   write_file(output,cfg)
end



%------------------------------------------------------------------------------------------
%create word based trials
%------------------------------------------------------------------------------------------
%create word based trials and filter them with 0.3 hp filter
%interpolate all bad channels with high variance low correlation with other channels
%interpolation info is stored in the d structure
%
%29-08-2016 because the word trials need to be hp filterd again it 
%saves a lot of time to save the word trial datastructure
% 31/08/16 13:44, set hpfreq to 0.3 to minimize correlation between baseline and erp window 
fn = dir('EEG/*_clean.mat')
parfor i = 1: length(fn)
	temp =	load(fn(i).name)
	temp = temp.d
	disp(temp.filename)
	d = temp;
	c = [];
	c.hpfreq = 0.3;
	d = story2word_trials(c,d);
	d.clean_input1 = temp.input_file1;
	d.clean_input2 = temp.input_file2;
	d.input_file = temp.filename;
	d.filename = strcat(fn(i).name(1:7),'_clean_word_interpolate')
	d = channel_interpolate([],d);
	write_data(d.filename,d)
end
%------------------------------------------------------------------------------------------
%check threshold and return bad trial indices for each pp in the post ica files (clean)
fn = dir('*_clean_word_interpolate.mat')
parfor i = 1 : length(fn)
	d = load(fn(i).name)
	d = d.d
	disp(d.filename)
	cfg = check_threshold(d);
	output = strcat(fn(i).name(1:7),'_threshold_clean_wordcfg')
	write_file(output,cfg)
end

%--------------------------------------------------
%comparing clean pre interpolate ( 01/09/16 11:45 clean story files) with old overlap clean files, with no overlap interpolate word files (last one will be used in analysis). FOund that interpolate mostly performs best (least number of threshold rejection (however it has a larger range of amplitudes compared to old overlap files) in one case 8-3 interpolate word file was really bad (old)11% -> interpolate(83%)
%IMPORTANT NOTE: i move all these threshold files to the folder EEG/THRESHOLD, if you want to run this code
%you probably need to alter the code
fno = dir('*clean_overlapcfg.mat');
fnc = dir('*threshold_cleancfg.mat')
fnw = dir('*threshold_clean_wordcfg.mat');
fout = fopen('pp_reject_clean_word_interpolate_blinks_plus_clean.txt','w');   
for i = 1 : length(fno)
    load(fno(i).name);
    disp(fno(i).name);
    [bt,nbt,nt,perc] = perc_threshold_trials(d);
	 %pp_id n_blinktrial ntrials_chunks per_blink_trials 
    fprintf(fout,'%7s %6s %4d %4d %2d\n',fn(i).name(1:7),'oldcl',nbt,nt,perc);

    load(fnc(i).name);
    disp(fnc(i).name);
    [bt,nbt,nt,perc] = perc_threshold_trials(d);
	 %pp_id n_blinktrial ntrials_chunks per_blink_trials 
   % fprintf(fout,'%7s %6s %4d %4d %2d\n',fn(i).name(1:7),'clean',nbt,nt,perc);

	 load(fnw(i).name);
    disp(fnw(i).name);
    [bt,nbt,nt,perc] = perc_threshold_trials(d);
	 %pp_id n_blinktrial ntrials_chunks per_blink_trials 
    fprintf(fout,'%7s %6s %4d %4d %2d\n',fn(i).name(1:7),'words',nbt,nt,perc);
end

fclose(fout);
%

%------------------------------
%begin of blink plots Mon 29 Aug 2016 04:54:36 PM CEST 
%--------------------------

%create plots (of blink trials, that compare ica-cleaned-data with the preproc-data

fn = dir('*rejectblink.mat');
for i = 1 : length(all_pp);
	 load(fn(i).name)
	 pp = d.blinks;
	 pp.file_id = fn(i).name(1:7);
    plot_clean_preproc(pp) %plots 10 blink trials
end

%---------------------------
%alternative plots of blinks trials, instead of word trials -> story trials, it compares reject -ica comps and clean
fn = dir('EEG/*_reject.mat')
fni = dir('EEG/*_ica.mat')
fnc = dir('EEG/*_clean.mat')
for i = 1 : length(fn)
	load(fn(i).name)
	ica = load(fni(i).name)
	clean = load(fnc(i).name)
	cfg.ci = 'Fz';
	clf;
	hold on
	easy_plot(cfg,d)
	easy_plot(cfg,clean.d)
	cfg.ci = clean.d.component;
	easy_plot(cfg,ica.d)
	hold off	
	fig = gcf;
	saveas(fig,strcat(d.filename(1:7),'_blinkstory_plot.png'));
end

%----------------------------------------
%end of blink plots Mon 29 Aug 2016 04:54:36 PM CEST 
%----------------------------------------

%----------------------------------------
%create baseline erp amplitude correlation with different filter setting
%----------------------------------------
fn = dir('*clean_word_interpolate.mat')
baseline_erp_correlation = [];
for i = 1 : length(fn)
	load(fn(i).name);
	d = story2word_trials([],d);	
	for freq = [0 0.25 0.3 0.5]
		cfg.hpfreq = freq;
		output = correlation_baseline_erp(cfg,d);
		baseline_erp_correlation = [baseline_erp_correlation output];
	end
end
write_file('baseline_erp_correlation1',baseline_erp_correlation);

load('baseline_erp_correlation.mat');
for i = 1:4
	berp = [];
	freq =i:4:73*4;
	temp = d(freq);
	berp.average = mean([temp(:).cor]);
	berp.sd = std([temp(:).cor]);
	berp.freq = [temp(1:5).hpfreq];
	berp.id = [temp.pp_id];
	berp
end
%----------------------------------------
% 31/08/16 14:01 , found that hp filter of 0.3 results in lowest correlation between baseline and erp window 
% used to create clean_word_interpolate files, which can be the basis for my analysis
% end create baseline erp amplitude correlation 
%----------------------------------------


%all trials that exceed threshold are saved to a cfg file, this can be used lateron to be removed before other steps, use this code:
%cfg.trials = setdiff(1:length(d.trial),preproc_cfg.d.rejected_trials);
%d        = ft_selectdata(cfg, d); 
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
fn = dir('*_clean_word_interpolate.mat');
for i = 1 : length(fn)
	d = load(fn(i).name)
	d = d.d
	disp(fn(i).name)
	if ~isfield(d,'old_trialinfo')
		ti = add_logprob(d);
		d.old_trialinfo = d.trialinfo;
		d.trialinfo = ti;
		write_data(d.filename,d)
		disp('added log prob to trialinfo')
	else
		disp('logprob was already added to trialinfo')
	end
end

%--------------------------------------------------------------------------------
%create condition structure
%--------------------------------------------------------------------------------
%first group pp id according to day and reduced and unreduced 
%this is based on the preproc cfg file
pp = make_pp_groups();
save('pp_groups.mat','pp')
%--------------------------------------------------------------------------------
%select trials: open classed words (higher lower quantile, or all) remove
%closed class words, threshold rejected trials and pseudowords
load('pp_groups.mat')
pp = select_trials(pp);
save('pp_condition_trials.mat','pp')
%--------------------------------------------------------------------------------
%
load('pp_condition_trials.mat')
pp = create_averages(pp);
save('pp_condition_averages.mat','pp')
load('pp_condition_averages.mat')
%--------------------------------------------------------------------------------


%--------------------------------------------------------------------------------
%create grand averages for the reduced and unreduced groups and for day 1 and day 3
%--------------------------------------------------------------------------------
pp = create_grandaverages(pp,'day1','unreduced','open_class_avg');
pp = create_grandaverages(pp,'day1','unreduced','lower_q_avg');
pp = create_grandaverages(pp,'day1','unreduced','higher_q_avg');

pp = create_grandaverages(pp,'day3','unreduced','open_class_avg');
pp = create_grandaverages(pp,'day3','unreduced','lower_q_avg');
pp = create_grandaverages(pp,'day3','unreduced','higher_q_avg');
%--------------------------------------------------------------------------------

%--------------------------------------------------------------------------------
%load grand averages of lower and higher quantile and all for day1 and day 3 
%and preprocess them for baseline correction
%--------------------------------------------------------------------------------
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

%--------------------------------------------------------------------------------
%plots grand averages unreduced day1 and day 3
%--------------------------------------------------------------------------------
hold off
plot(lq1.time,lqb1.avg(19,:))  
hold on
plot(lq1.time,hqb1.avg(19,:))  
plot(lq1.time,ocb1.avg(19,:))                                                              
legend('lq','hq','oc1')

hold off
plot(lq3.time,lqb3.avg(19,:))  
hold on
plot(lq3.time,hqb3.avg(19,:))  
plot(lq3.time,ocb3.avg(19,:))  
legend('lq','hq','oc3')
%end plots

%--------------------------------------------------
%collapse over day1 and day3 for unreduced trials
%--------------------------------------------------
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



%------------------------------
%old code
%------------------------------

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

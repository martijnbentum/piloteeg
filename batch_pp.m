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

% ICA and correlate components with eog channels

fn = dir('EEG/*preproc.mat')

for i = 1 : length(fn)
    load(fn(i).name)
    d = ica_and_corr(d)
    output = strcat(fn(i).name(1:5),'_ica')
    d.filename = output
    d.input_file = fn(i).name
    save(output,'data')
end

% plot ICA with eog correlation values

fn = dir('EEG/*ica.mat')

for i = 1 : length(fn)
    load(fn(i).name)
    create_ica_plot(d)
end

%create a data structure that holds information of all pp

fn = dir('ppn*preproc.mat')
fn_ica = dir('*ica.mat')
all_pp = {};
for i = 1 : length(fn)
    load(fn(i).name);
    pp = [];
    pp.filename_preproc = data.filename;
    pp.eogv_bad_trials = data.eogv_bad_trials
    pp.eogh_bad_trials = data.eogh_bad_trials
    pp.cfg_preproc = data.cfg
    load(fn_ica(i).name);
    pp.filename_ica = data.filename;
    pp.cor_eogv = data.cor_eogv;
    pp.cor_eogh = data.cor_eogh;
    [c index] = max(data.cor_eogv);
    pp.highest_v = [c index]
    [c index] = max(data.cor_eogh);
    pp.highest_h = [c index]
    pp.cfg_ica = data.cfg;
    all_pp{i} = pp
end
output = 'all_pp.mat'
save(output,'all_pp')

%-----------------------

%check frequencies the frequencies for the preproc data (test if the
%lowpass filter worked
%trial_numbers = 36:72:1720;

fn = dir('EEG/*preproc.mat');

%periodograms = {1,length(fn)};
for i = 1 : length(fn)
    load(fn(i).name)
%    pp = [];fz_periodogram = {1,length(trial_numbers)}; cz_periodogram = {1,length(trial_numbers)};
%    for t = 1 : length(trial_numbers)
%     [freqs, periodogram] = check_frequencies(1000,d.trial{trial_numbers(t)}(2,:)); %channel Fz
 %       fz_periodogram{t} = periodogram;
    [freqs, periodogram] = check_frequencies(1000,d.trial{trial_numbers(t)}(21,:));%channel Cz
%o        cz_periodogram{t} = periodogram;
    create_periodogram_plot(freqs,periodogram,'Cz',fn(i).name)
end
%    pp.fz_periodogram = fz_periodogram;
%    pp.cz_periodogram = cz_periodogram;
%    pp.trials = trial_numbers;
%    pp.filename = data.filename;
%    pp.freqs = freqs;
%    pp.channel_names = {data.label{2} data.label{2}};
%    periodograms{i} = pp
%endall

%output = 'all_pp_periodograms.mat'
%save(output,'periodograms')

    
% create the periodograms for all pp for two channels    
load('all_pp_periodograms')
for i = 1 : length(periodograms)
    create_periodogram_plots(periodograms{i})
end

%-------------------------

%Add the components that need to be removed tot he all_pp -> all_pp_new

load all_pp
all_pp_new = bad_comp_all_pp(all_pp,'remove_components.txt')
output = 'all_pp_new.mat'
save(output,'all_pp_new')%adds the components that need to be removed

%--------------------------

%Recompose data without the bad components

load all_pp_new
for i = 1 : length(all_pp_new)
    data = extract_components(all_pp_new{i}) %recomposes the data withou the bad components
    save(data.filename,'data')
end

%--------------------------

%create plots (of blink trials, that compare ica-cleaned-data with the preproc-data

load all_pp_new
for i = 1 : length(all_pp_new)
    plot_clean_preproc(all_pp_new{i}) %plots 10 blink trials
end

%---------------------------

%remove all trials that exceed threshold

fn = dir('ppn*clean.mat');
for i = 1 : length(fn)
    load(fn(i).name)
    data = check_threshold(data) %removes all trials that exceeds -75 75 mu volts
    save(data.filename,'data')
end

%---------------------------

% show all removed trials for all pp

load all_pp_new
removed_trials = {1,length(all_pp_new)};
for i = 1 : length(all_pp_new)
    %p = []
    load(strcat(all_pp_new{i}.filename_preproc(1:5),'_clean_threshold.mat'))
    all_pp_new{i}.removed_trial_count = count_removed_trials(data)
    all_pp_new{i}.rejected_trials = data.rejected_trials
    removed_trials{i}.p_name = all_pp_new{i}.filename_preproc(1:5)
    removed_trials{i}.all_count = all_pp_new{i}.removed_trial_count.all_count
    removed_trials{i}.all_proportion = all_pp_new{i}.removed_trial_count.all_proportion
    removed_trials{i}.conditions = all_pp_new{i}.removed_trial_count.conditions

    save('removed_trials','removed_trials')
end
%plot the removed trials for all participants
for i = 1: length(removed_trials)
    removed_trials{i}
end
%-------------------------  

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

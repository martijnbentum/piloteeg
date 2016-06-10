%in this file i will keep general matlab how to code

%find index
x= find(strcmp(o.label,'eogv'))
%strcmp gives back a vector with 0 1, where 1 stands for equal, with find you get back the
%indeces of non zero entries, so this gives back the index of the label of a channel

%old code
% preprocessing -> load data filter and creat eog channels
%load all filesnames
fn = dir('EEG/*.vhdr')
%prepare configuration files
cfg = [];
for i =1:length(fn)
	        cfg{i} = define_trial(strcat('EEG/',fn(i).name));
	end
	%create configuration files
	parfor i = 1:length(fn)
	        cfg{i} = ft_definetrial(cfg{i});
	end
	%load all data
	d = [];
	parfor i = 1:length(fn)
	        d{i} = ft_preprocessing(cfg{i});                                                          
	end
	%get trialnumbers which exceed threshhold

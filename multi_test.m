
% preprocessing -> load data filter and creat eog channels
%config
fn = dir('EEG/*.vhdr')
cfg = [];
for i =1:length(fn)   
	cfg{i} = define_trial(strcat('EEG/',fn(i).name));
end
cfg{1} = ft_definetrial(cfg{1});
d = ft_preprocessing(cfg{1});
%cfg = qsubcellfun(@ft_definetrial,cfg,'memreq',5*1024^2,'timreq',15) 



%the call to "ft_definetrial" took 10 seconds and required the additional allocation of an estimated 9 MB
%the call to "ft_preprocessing" took 74 seconds and required the additional allocation of an estimated 104 MB


function [bt,nbt,nt,perc] = perc_bad_trials(d)
%renamed from perc_bad_trials
%returns bad trial numbers, number of bad trials, number of trials and percentage of bad trials
%needs dataset d, made for preproc files

nt = length(d.sampleinfo);
bt = [d.eogh_bad_trials d.eogv_bad_trials];%concatenate all bad trials
bt = unique(bt);
nbt = length(bt);
perc = round((nbt/nt) *100);

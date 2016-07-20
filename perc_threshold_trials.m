function [bt,nbt,nt,perc] = perc_threshold_trials(d)
%renamed from perc_bad_trials
%returns bad trial numbers, number of bad trials, number of trials and percentage of bad trials
%needs dataset d, made for preproc files

nt = d.threshold_ntrials;
bt = d.threshold_rejected_trials;
if ~isempty(bt)
	nbt = length(bt);
else
	nbt = 0
end
perc = round((nbt/nt) *100);

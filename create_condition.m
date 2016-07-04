function cfg= create_condition(cfg,d)
%select a subset of trials based on conditions specified in cfg, it returns files to be removed to create the condition. So far only works on open / closed class

if ~isfield(cfg,'reduced'), cfg.reduced = 1; end %unreduced is default (for testing, exploratory)
if ~isfield(cfg,'day_id'), cfg.day_id = 1; end %day 1 is default (for testing, exploratory)

%this is a private field and should alway be 0, which stands for closed class word
cfg.closed_class = 0;  %1 = open class, 0 = closed class create a field containing trials with closed class words

if cfg.reduced ~= d.trialinfo(1,4)
	error('This participant belongs to reduced group, if you want to select those you should specify in the cfg.reduced = 2 because unreduced is default')
end

if cfg.day_id ~= d.trialinfo(1,2)
	error('This recording is from day 3, day1 is default, if you want to select this group, specificy day 3 or all in the cfg.day_id=3 or cfg.day = "all"')
end

if cfg.reduced == 1,	disp('participant belongs to unreduced group');
else, disp('participant belongs to reduced group'); end
if cfg.day_id == 1, disp('recording day 1');
else, disp('recording day 3'); end

closed_class_trials = [];
open_class_trials = [];
lower_q = [];
higher_q = [];
pseudo = [] ;
for row = 1: length(d.trialinfo)
%store indices of each trial that do not meet a condition	
	if cfg.closed_class == d.trialinfo(row,8)%store trial n with closed class words 
		closed_class_trials = [closed_class_trials row]; %add index of a closed class
	else
		open_class_trials = [open_class_trials row]; % add index of a open class trl
	end
	if isfield(cfg,'lower_q') && cfg.lower_q > d.trialinfo(row,9)
		lower_q = [lower_q row]; %add index of a trial that belong to lower_quartile logprob
	end
	if isfield(cfg,'higher_q') && cfg.higher_q < d.trialinfo(row,9) && d.trialinfo(row,9) < 0 && d.trialinfo(row,8) ~= cfg.closed_class
		higher_q = [higher_q row]; %add index of a trial that belong to higher_quartile logprob
	end
	if d.trialinfo(row,9) > 0
		pseudo = [pseudo row];
	end

end

cfg.closed_class_trials = closed_class_trials;
cfg.open_class_trials = open_class_trials;
cfg.pseudoword_trials = pseudo;
if isfield(cfg,'lower_q'), cfg.lower_q_trials = lower_q; end
if isfield(cfg,'higher_q'), cfg.higher_q_trials = higher_q; end

	


%{
example to check for cfg fields ( i guess cell fields ) ~ is not
if ~isfield(cfg, 'trialdef')
	  cfg.trialdef = [];
  end

if isfield(cfg.trialdef, 'eventvalue')  && isempty(cfg.trialdef.eventvalue   ), cfg.trialdef = rmfield(cfg.trialdef, 'eventvalue' ); end

condition markers:
temp.pp_id = str2num(filename{1}(7:8));
temp.day_id = str2num(filename{2});
temp.story_id = str2num(temp.value(2:3));
temp.reduced = str2num(temp.value(4));
temp.word_id = str2num(temp.value(5:7));
temp.duration_word = str2num(temp.value(14:16));
temp.tag = str2num(temp.value(18));
temp.closed_class = str2num(temp.value(19));

marker                                                                                                              
9631027910527220320

story id
963     story63 rock_unred_adj.wav MATLAB index 2:3

w id (word id in story)
1027    1000    unreduced story index 4
2000    reduced story index 4
27      27th word in the story index 5:7

vocabulary id
90488   90000   vocabulary id index 9:12
488     word id in vocabulary 'his' index 9:12

duration id
7220    7000    duration id
220     word duration in ms index 14:16

tag id
320     3       tag id
2       tag (determiner) index 18
0       closed class index 19
%}


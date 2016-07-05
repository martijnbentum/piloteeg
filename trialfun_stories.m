function [story_trl, event] = ft_trialfun_general(cfg)
%
%FT_TRIALFUN_PILOT is based on FT_TRIALFUN_PILOTGENERAL
% by read_event. This function is independent of the dataformat
%
% The trialdef structure can contain the following specifications
%   cfg.trialdef.eventtype  = 'string'
%   cfg.trialdef.eventvalue = first number of each event value
%   cfg.trialdef.prestim    = latency in seconds (optional)
%   cfg.trialdef.poststim   = latency in seconds (optional)
%

if ~isfield(cfg, 'trialdef')
  cfg.trialdef = [];
end
if isfield(cfg.trialdef, 'eventvalue')  && isempty(cfg.trialdef.eventvalue   ), cfg.trialdef = rmfield(cfg.trialdef, 'eventvalue' ); end
if isfield(cfg.trialdef, 'prestim')     && isempty(cfg.trialdef.prestim      ), cfg.trialdef = rmfield(cfg.trialdef, 'prestim'    ); end
if isfield(cfg.trialdef, 'poststim')    && isempty(cfg.trialdef.poststim     ), cfg.trialdef = rmfield(cfg.trialdef, 'poststim'   ); end
if isfield(cfg.trialdef, 'triallength') && isempty(cfg.trialdef.triallength  ), cfg.trialdef = rmfield(cfg.trialdef, 'triallength'); end
if isfield(cfg.trialdef, 'ntrials')     && isempty(cfg.trialdef.ntrials      ), cfg.trialdef = rmfield(cfg.trialdef, 'ntrials'    ); end

if isfield(cfg.trialdef, 'triallength')
  % reading all segments from a continuous file is incompatible with any other option
  try, cfg.trialdef = rmfield(cfg.trialdef, 'eventvalue'); end
  try, cfg.trialdef = rmfield(cfg.trialdef, 'prestim'   ); end
  try, cfg.trialdef = rmfield(cfg.trialdef, 'poststim'  ); end
  if ~isfield(cfg.trialdef, 'ntrials')
    if isinf(cfg.trialdef.triallength)
      cfg.trialdef.ntrials = 1;
    else
      cfg.trialdef.ntrials = inf;
    end
  end
end

% default rejection parameter
if ~isfield(cfg, 'eventformat'),  cfg.eventformat  = []; end
if ~isfield(cfg, 'headerformat'), cfg.headerformat = []; end
if ~isfield(cfg, 'dataformat'),   cfg.dataformat   = []; end

% read the header, contains the sampling frequency
hdr = ft_read_header(cfg.headerfile, 'headerformat', cfg.headerformat);
% read the events
if isfield(cfg, 'event')
  fprintf('using the events from the configuration structure\n');
  event = cfg.event;
else
  fprintf('reading the events from ''%s''\n', cfg.headerfile);
  event = ft_read_event(cfg.headerfile, 'headerformat', cfg.headerformat, 'eventformat', cfg.eventformat, 'dataformat', cfg.dataformat);
  disp(length(event))
end

trl = [];
story_trl = [];
selection = [];
old_story_id = 0;
last_end_trl = 0;
story_begin_trl = 0;
for i=1:numel(event)
	if numel(event(i).value) > 1 && event(i).value(1) == cfg.trialdef.eventvalue 
		%for explanation of marker id see marker id code explained txt
		temp = event(i);
		filename = strsplit(cfg.dataset,'_');
		temp.filename = cfg.dataset;
		temp.pp_id = str2num(filename{1}(7:8));
		temp.day_id = str2num(filename{2});
		temp.story_id = str2num(temp.value(2:3));
		temp.reduced = str2num(temp.value(4));
		temp.word_id = str2num(temp.value(5:7));
		temp.duration_word = str2num(temp.value(14:16));
		temp.tag = str2num(temp.value(18));
		temp.closed_class = str2num(temp.value(19));

		temp.pretrig = round(cfg.trialdef.prestim *hdr.Fs);
		temp.posttrig = round(cfg.trialdef.poststim *hdr.Fs);
		temp.begin_trl = temp.sample - temp.pretrig;
		temp.end_trl = temp.sample + temp.posttrig;
		selection = [selection temp];
		%the word based trial definition is not used in this script, use trialfun_pilot instead
		%trl = [trl; [temp.begin_trl temp.end_trl -1*temp.pretrig temp.pp_id temp.day_id temp.story_id temp.reduced temp.word_id temp.duration_word temp.tag temp.closed_class]];
		
		if old_story_id == 0 % if this is the first story initialise story id and begin_trl
   		  old_story_id = temp.story_id;		
	  		 story_begin_trl = temp.begin_trl;
		end

		if old_story_id ~= temp.story_id %if the story id does not match a new story has started, save the begin and end of the story
			  story_trl = [story_trl; [story_begin_trl last_end_trl -1*temp.pretrig old_story_id]];
			  old_story_id = temp.story_id;%the new story has now started and we have to wait until this one ends
			  story_begin_trl = temp.begin_trl;%store the start of this new story
		end
		last_end_trl = temp.end_trl;%should store the end of each trial, because we only know that a new story hasstarted at the first word of that new story.
	end
end
%return the variable with all begin and end samples of the stories
story_trl = [story_trl; [story_begin_trl last_end_trl -1*temp.pretrig old_story_id]];
event(1).selection =selection;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUBFUNCTION returns true if x is a member of array y, regardless of the class of x and y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s = ismatch(x, y)
if isempty(x) || isempty(y)
  s = false;
elseif ischar(x) && ischar(y)
  s = strcmp(x, y);
elseif isnumeric(x) && isnumeric(y)
  s = ismember(x, y);
elseif ischar(x) && iscell(y)
  y = y(strcmp(class(x), cellfun(@class, y, 'UniformOutput', false)));
  s = ismember(x, y);
elseif isnumeric(x) && iscell(y) && all(cellfun(@isnumeric, y))
  s = false;
  for i=1:numel(y)
    s = s || ismember(x, y{i});
  end
else
  s = false;
end


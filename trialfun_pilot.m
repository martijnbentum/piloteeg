function [trl, event] = ft_trialfun_general(cfg)
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
end

selection = [];
for i=1:numel(event)
	if numel(event(i).value) > 1 && event(i).value(1) == cfg.trialdef.eventvalue 
		selection = [selection event(i)];
	end
end
event(1).selection =selection;
%%% for the following, the trials do not depend on the events in the data
%if isfield(cfg.trialdef, 'triallength')
%  if isinf(cfg.trialdef.triallength)
%    % make one long trial with the complete continuous data in it
%    trl = [1 hdr.nSamples*hdr.nTrials 0];
%  elseif isinf(cfg.trialdef.ntrials)
%    % cut the continous data into as many segments as possible
%    nsamples = round(cfg.trialdef.triallength*hdr.Fs);
%    trlbeg   = 1:nsamples:(hdr.nSamples*hdr.nTrials - nsamples + 1);
%    trlend   = trlbeg + nsamples - 1;
%    offset   = zeros(size(trlbeg));
%    trl = [trlbeg(:) trlend(:) offset(:)];
%  else
%    % make the pre-specified number of trials
%    nsamples = round(cfg.trialdef.triallength*hdr.Fs);
%    trlbeg   = (0:(cfg.trialdef.ntrials-1))*nsamples + 1;
%    trlend   = trlbeg + nsamples - 1;
%    offset   = zeros(size(trlbeg));
%    trl = [trlbeg(:) trlend(:) offset(:)];
%  end
%  return
%end

trl = [33416       34615        -200];
val = [];

%% start by selecting all events
%sel = true(1, length(event)); % this should be a row vector
%
%% select all events of the specified type
%if isfield(cfg.trialdef, 'eventtype') && ~isempty(cfg.trialdef.eventtype)
%  for i=1:numel(event)
%    sel(i) = sel(i) && ismatch(event(i).type, cfg.trialdef.eventtype);
%  end
%elseif ~isfield(cfg.trialdef, 'eventtype') || isempty(cfg.trialdef.eventtype)
%  % search for trial events
%  for i=1:numel(event)
%    sel(i) = sel(i) && ismatch(event(i).type, 'trial');
%  end
%end
%
%% select all events with the specified value
%if isfield(cfg.trialdef, 'eventvalue') && ~isempty(cfg.trialdef.eventvalue)
%  for i=1:numel(event)
%    sel(i) = sel(i) && ismatch(event(i).value(1), cfg.trialdef.eventvalue);
%  end
%end
%
%% convert from boolean vector into a list of indices
%sel = find(sel);
%
%
%for i=sel
%  % catch empty fields in the event table and interpret them meaningfully
%  if isempty(event(i).offset)
%    % time axis has no offset relative to the event
%    event(i).offset = 0;
%  end
%  if isempty(event(i).duration)
%    % the event does not specify a duration
%    event(i).duration = 0;
%  end
%  % determine where the trial starts with respect to the event
%  if ~isfield(cfg.trialdef, 'prestim')
%    trloff = event(i).offset;
%    trlbeg = event(i).sample;
%  else
%    % override the offset of the event
%    trloff = round(-cfg.trialdef.prestim*hdr.Fs);
%    % also shift the begin sample with the specified amount
%    trlbeg = event(i).sample + trloff;
%  end
%  % determine the number of samples that has to be read (excluding the begin sample)
%  if ~isfield(cfg.trialdef, 'poststim')
%    trldur = max(event(i).duration - 1, 0);
%  else
%    % this will not work if prestim was not defined, the code will then crash
%    trldur = round((cfg.trialdef.poststim+cfg.trialdef.prestim)*hdr.Fs) - 1;
%  end
%  trlend = trlbeg + trldur;
%  % add the beginsample, endsample and offset of this trial to the list
%  % if all samples are in the dataset
%  if trlbeg>0 && trlend<=hdr.nSamples*hdr.nTrials,
%    trl = [trl; [trlbeg trlend trloff]];
%    if isnumeric(event(i).value),
%      val = [val; event(i).value];
%    elseif ischar(event(i).value) && numel(event(i).value)>1 && (event(i).value(1)=='S'|| event(i).value(1)=='R')
%      % on brainvision these are called 'S  1' for stimuli or 'R  1' for responses
%      val = [val; str2double(event(i).value(2:end))];
%    else
%      val = [val; nan];
%    end
%  end
%end
%
%% append the vector with values
%if ~isempty(val) && ~all(isnan(val)) && size(trl,1)==size(val,1)
%  trl = [trl val];
%end
%
%hdr

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


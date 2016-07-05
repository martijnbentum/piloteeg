function output = concatenate_trials(input)
%concatenates each trial in the time dimension
%input is a fieldtrip data structure, e.g. from ft_preprocessing
%example
%input:20 trials, 1000 samples per trial(columns), 32 channels (rows)
%output 32 X 20.000 matrix

Ntrials = length(input.trial);

Nsamples = zeros(1,Ntrials);
for trial=1:Ntrials
  Nsamples(trial) = size(input.trial{trial},2);
end

Nchans = length(input.label);


  dat = zeros(Nchans, sum(Nsamples));
  for trial=1:Ntrials
    fprintf('.');
    begsample = sum(Nsamples(1:(trial-1))) + 1;
    endsample = sum(Nsamples(1:trial));
    dat(:,begsample:endsample) = input.trial{trial};
  end
  fprintf('\n');
  fprintf('concatenated data matrix size %dx%d\n', size(dat,1), size(dat,2));
  
output = dat;

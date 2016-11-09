function dsubset = select_subset_d(perc,d)

if perc < 1
	perc = floor(perc*100);
end
perc = floor(perc)

if perc > 100
	error('perc should be integer between 0 and 100, or between 0.0 and 1')
end

one_perc = floor(length(d.trial)/ 100)

if one_perc < 1
	one_perc = 1;
end

subset = one_perc * perc

if subset > length(d.trial)
	subset = length(d.trial)
	disp('using all trials, rounding error can cause this to occur')
end

dsubset = d;
dsubset.trial = dsubset.trial(1:subset);
dsubset.time = dsubset.time(1:subset);
dsubset.sampleinfo = dsubset.sampleinfo(1:subset,:);
dsubset.trialinfo= dsubset.trialinfo(1:subset,:);


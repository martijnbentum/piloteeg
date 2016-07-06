function d = redefine_test(d)
%takes ft_preprocessing data and multiplies each trial by 10
%this script is to test ft_redefine_trial to check whether data is reread from disk or from loaded data, last one is expected and hoped for


for i = 1:length(d.trial)
		  d.trial{i} = d.trial{i} *10;
end


%test succeeded, the ft_redefinetrial does indeed load the data from the data provided and also stores the trialinfo. To be explicit, the data is not loaded from drive, but the provided data is used when you provide a trl structure in the cfg file
%example:
%cfg = [];
%cfg.trl = N * 3 (or more, defines conditions)
%rdata = ft_redefinedata(cfg,data)

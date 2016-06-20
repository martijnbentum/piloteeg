%create a data structure that holds information of all pp

fn = dir('EEG/*preproc.mat')
fn_ica = dir('EEG/*ica.mat')
all_pp = {};
for i = 1 : length(fn)
load(fn(i).name);
pp = [];
pp.filename_preproc = fn(i).name;
pp.eogv_bad_trials = d.eogv_bad_trials
pp.eogh_bad_trials = d.eogh_bad_trials
pp.cfg_preproc = data.cfg
load(fn_ica(i).name);
pp.filename_ica = d.filename;
pp.cor_eogv = data.cor_eogv;
pp.cor_eogh = data.cor_eogh;
[c index] = max(data.cor_eogv);
pp.highest_v = [c index]
[c index] = max(data.cor_eogh);
pp.highest_h = [c index]
pp.cfg_ica = d.cfg;                                                                               
all_pp{i} = pp
end
output = 'all_pp.mat'
save(output,'all_pp')


%add components to be removed
load all_pp
all_pp_new = bad_comp_all_pp(all_pp,'remove_components.txt')
output = 'all_pp_new.mat'
save(output,'all_pp_new')%adds the components that need to be removed

%use the all pp structure to remove components
load all_pp_new
for i = 1 : length(all_pp_new)
data = extract_components(all_pp_new{i}) %recomposes the data withou the bad components
save(data.filename,'data')
end

%------

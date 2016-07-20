function d = extract_components(pp)

load(strcat(pp.file_id,'_reject.mat'))
preproc = ft_selectdata(d,'channel',{'all','-eogv','-eogh','-RM','-REF_LM','-Fp1'})
input = strcat(pp.file_id,'_ica.mat')
load(input)
ica = d

d= []
cfg = [];

cfg.component = pp.bad_components % to be removed component(s)
d = ft_rejectcomponent(cfg, ica, preproc)

d.input_file1 = ica.input_file
d.input_file2 = ica.filename
d.filename = strcat(pp.file_id,'_clean.mat')
d.component = cfg.component
d.cfg_preproc = preproc.cfg

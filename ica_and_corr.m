function output = ica_and_corr(d)
%questions

eogv=ft_selectdata(d, 'channel', {'eogv'});
eogh=ft_selectdata(d, 'channel', {'eogh'});

%ICA  
cfg = [];
cfg.channel = {'all','-eogv','-eogh','-RM','-REF_LM','-Fp1'}%[1:27] %EXCLUDE EOG and reference channels
comp = ft_componentanalysis(cfg,d);

[corr_eogv, corr_eogh] = correlate_comp_eog(comp, eogv, eogh);

comp.cor_eogv = corr_eogv;
comp.cor_eogh = corr_eogh;
output = comp;

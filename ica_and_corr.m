function output = ica_and_corr(pp)
%questions

eogv=ft_selectdata(pp, 'channel', {'eogv'});
eogh=ft_selectdata(pp, 'channel', {'eogh'});

%ICA  
cfg = [];
cfg.channel = {'all','-eogv','-eogh','-RM','-REF_leftmastoid'}%[1:27] %EXCLUDE EOG and reference channels
comp = ft_componentanalysis(cfg,pp);

[corr_eogv, corr_eogh] = correlate_comp_eog(comp, eogv, eogh);

comp.cor_eogv = corr_eogv;
comp.cor_eogh = corr_eogh;
output = comp;

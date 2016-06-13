function [c_eogv, c_eogh] = correlate_comp_eog(comp, eog_vert, eog_hor)

conc_comp = concatenate_trials(comp);
conc_eogv = concatenate_trials(eog_vert);
conc_eogh = concatenate_trials(eog_hor);



corr_eogv = [];
for i=1:size(conc_comp)
    corr_eogv(i) = corr(conc_comp(i,:)',conc_eogv');
end
    
corr_eogh = [];
for i=1:size(conc_comp)
    corr_eogh(i) = corr(conc_comp(i,:)',conc_eogh');
end    

c_eogv = corr_eogv;
c_eogh = corr_eogh;

 

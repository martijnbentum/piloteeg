function output = create_ica_plot(d)

set(gcf,'Visible','off');


len = length(d.label)

com_cell={};
for ncomp=1:len
    com_cell=[com_cell; sprintf('h %5.2f  v %5.2f', d.cor_eogh(ncomp), d.cor_eogv(ncomp))];
end


%h = figure
cfg = [];
cfg.component = [1:len];       % specify the component(s) that should be plotted
cfg.layout    = 'easycapM23.mat'%'EEG1010.lay'; % specify the layout file that should be used for plotting
cfg.comment = 'cells' % !!!!!!!!! -> modified fieltrip file
cfg.commentpos = 'leftbottom'
cfg.commentcell = com_cell
set(gcf,'Visible','off');

ft_topoplotIC(cfg, d)

%print('-dpng', strcat('~/Documents/MATLAB/EEG_Martijn/periodogram_plots/',pp.filename,'_periodogram_fz_',num2str(pp.trials(i))))

%easycapM23.mat
%'~/Documents/MATLAB/EEG_Martijn/'
%output = strcat(d.filename,'_plot')
print('-dpng',strcat(d.filename,'_plot'))

%close(h)
function output = create_ica_plot(d)

set(gcf,'Visible','off');
x0=10;
y0=10;
width=1200;
height=1080;
set(gcf,'units','points','position',[x0,y0,width,height])

len = length(d.label)

com_cell={};
for ncomp=1:len
    com_cell=[com_cell; sprintf('h %5.2f  v %5.2f', d.cor_eogh(ncomp), d.cor_eogv(ncomp))];
end


%h = figure
cfg = [];
cfg.component = [1:len];       % specify the component(s) that should be plotted
cfg.layout    = 'EEG1010'%'easycapM23.mat'%'EEG1010.lay'; % specify the layout file that should be used for plotting
cfg.comments = 'cells' % !!!!!!!!! -> modified fieltrip file,normal fieldname is comment: fieldtrip-2016xxx/private/topoplot_common.m line 673 674, added the following if statement
cfg.comment = 'cells'%
%elseif strcmp(cfg.comments, 'cells')  cfg.comment = cfg.commentcell(cfg.component);
cfg.commentpos = 'leftbottom';%change topoplot_common to -0.6 -0.9 for better position, copy of
%topoplot_common can be found in piloteeg directory
cfg.commentcell = com_cell
%set(gcf,'Visible','off');

ft_topoplotIC(cfg, d)

%print('-dpng', strcat('~/Documents/MATLAB/EEG_Martijn/periodogram_plots/',pp.filename,'_periodogram_fz_',num2str(pp.trials(i))))

%easycapM23.mat
%'~/Documents/MATLAB/EEG_Martijn/'
%output = strcat(d.filename,'_plot')
print('-dpng',strcat(d.filename,'_plot.png'))

%close(h)

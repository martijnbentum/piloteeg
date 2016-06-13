function output = create_periodogram_plots(freqs,periodogram,ch,pp)
set(gcf,'Visible','off');

ylim([0 100])
xlim([0 100])

f = freqs;
set(gcf,'Visible','off');


plot(f,pp.fz_periodogram{i});
ylim([0 100])
xlim([0 100])
title(['FZ ',pp.filename(1:5),' ',num2str(pp.trials(i))])
print('-dpng', strcat('PLOTS/',pp,'_periodogram_',ch))


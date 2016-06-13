function output = create_periodogram_plots(freqs,periodogram,ch,pp)
set(gcf,'Visible','off');

ylim([0 100])
xlim([0 100])

f = freqs;
set(gcf,'Visible','off');


plot(freqs,periodogram);
ylim([0 100])
xlim([0 100])
title([ch,' ',pp])
print('-dpng', strcat('PLOTS/',pp,'_periodogram_',ch,'.png'))


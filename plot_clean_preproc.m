function output = plot_clean_preproc(pp)

p_name = pp.file_id;
clean = strcat(p_name,'_clean.mat')
preproc = strcat(p_name,'_preproc.mat')
load(clean)
clean1 = ft_selectdata(d,'channel',{'Fz','Cz'})

load(preproc)
preproc1 = ft_selectdata(d,'channel',{'Fz','Cz'})

for p = 1 : 5
    trial = clean1.eogv_bad_trials(p)
    clf
    %hold on

    set(gcf, 'Visible', 'off')
    
    for i = 1:2
		  subplot(1,2,i)
        plot(clean1.time{trial}(1,:),clean1.trial{trial}(i,:),preproc1.time{trial}(1,:),preproc1.trial{trial}(i,:))
        ylim([-60 60])
%    end
    
    legend('clean','preproc');
    title(strcat(p_name,' Channel:  ',clean1.label(i)))
    %ylim([0 100])
	 end
    print('-dpng',strcat(p_name,'_plot_clean_preproc_test',num2str(trial)))
    clf
end

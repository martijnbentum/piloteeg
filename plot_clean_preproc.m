function output = plot_clean_preproc(pp)

p_name = pp.file_id;
clean = strcat(p_name,'_clean.mat')
preproc = strcat(p_name,'_reject.mat')
load(clean)
clean1 = ft_selectdata(d,'channel',{'Fz','Cz'})
clean1 = ft_redefinetrial(clean1.cfg_redefine,clean1);

load(preproc)
preproc1 = ft_selectdata(d,'channel',{'Fz','Cz'})
preproc1 = ft_redefinetrial(preproc1.cfg_redefine,preproc1);

for p = 1 : 3
    trial = pp.eogv_bad_trials(p)
    clf
    %hold on

    set(gcf, 'Visible', 'off')
    
    for i = 1:2
		  subplot(1,2,i)
        plot(clean1.time{trial}(1,:),clean1.trial{trial}(i,:),preproc1.time{trial}(1,:),preproc1.trial{trial}(i,:))
        ylim([-60 60])
%    end
    
    legend('clean','reject');
    title(strcat(p_name,' Channel:  ',clean1.label(i)))
    %ylim([0 100])
	 end
    print('-dpng',strcat(p_name,'_plot_clean_reject_vertical',num2str(trial)))
    clf

    trial = pp.eogh_bad_trials(p)
    clf
    %hold on

    set(gcf, 'Visible', 'off')
    
    for i = 1:2
		  subplot(1,2,i)
        plot(clean1.time{trial}(1,:),clean1.trial{trial}(i,:),preproc1.time{trial}(1,:),preproc1.trial{trial}(i,:))
        ylim([-60 60])
%    end
    
    legend('clean','reject');
    title(strcat(p_name,' Channel:  ',clean1.label(i)))
    %ylim([0 100])
	 end
    print('-dpng',strcat(p_name,'_plot_clean_reject_horizontal',num2str(trial)))
    clf


end

# piloteeg

Repository for the analysis of the pilot study eeg connected speech


NOTES
=====
Break after 5 stories

ICA
------------------------------------------------------------------------------------------
test out on a toy problem whether overlap copying matters, maybe it does, because if you want to be able to extract a component with eye-artifacts it depends on how many there are in the signal, so with overlap copying you create more of somethings, so this could be problematic

eye artifacts
------------------------------------------------------------------------------------------
there is a function for detecting eye artifacts, could be handy for checking the succes of the ica
should check whether componts really remove eye artifacts, especially horizontal eye artifacts by plotting time course of bad trials of the components

FT baseline correction AKA demean
------------------------------------------------------------------------------------------
This is done  on a channel by channel basis. Mean of each channel of baseline window is supstracted from each sample. This will 'pull' electrodes' together.

ERP definition (Frank et al 2015)
------------------------------------------------------------------------------------------
The average over time window and channels. ERP amplitude is one number, so it is important to choose the channel set wisely. 
>>>>>>>>In this study no baseline correction is applied, so one possbile problem with this approch is the drift of specific channels.>>>>>>>>>>>>HOWEVER a high-pass filter will remove any dc offset and pull electrodes togesther.

ERP and Baseline correlation (Frank et al 2015)
------------------------------------------------------------------------------------------
Use a specific high-pass filter setting (0.25 0.3 0.5)
Take the average over baselinewindow and channels (one number), Take the average over ERP timewindow and channels. To this for all trials. Correlate the two amplitudes over all trials.





#ft_layoutplot.m FIX
added some code: on line 92: hasdata = exist('data', 'var'); (from github current master) otherwise throws error:
##Undefined function or variable 'hasdata'.
##
##Error in ft_layoutplot (line 110)
##  if hasdata


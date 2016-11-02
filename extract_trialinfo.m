function output =  extract_trialinfo(d,print)
%returns trialinfo from participant, if print is true the trial info is printed as well
%expects a cfg data file from cfg preproc stories
if ~exist('print','var')
	print = false; 
end

%------------------------------------------------------------------------------------------
disp('extract trialinfo')

output = zeros(length(d.event(1).selection),8);
for i = 1 :length(d.event(1).selection)
	t = d.event(1).selection(i);
	output(i,:) = [t.pp_id,t.day_id,t.story_id,t.reduced,t.word_id,t.duration_word,t.tag,t.closed_class];
end

if print
	disp('writing to text file')
	of = strcat(d.dataset(5:12),'_trailinfo.txt')
	disp(of)
	fout = fopen(of,'w');
	for i=1:length(output)
		fprintf(fout,'%1d %1d %2d %1d %3d %4d %1d %1d\n',output(i,:));
	end
	fclose(fout)
end

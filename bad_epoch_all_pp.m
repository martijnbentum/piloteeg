function output = bad_epoch_all_pp()

%read in epoch to be removed
z = fopen('pp_epoch_bad_trial.txt');
temp = textscan(z,'%s','Delimiter','\n');
fclose(z);
temp{1};
r = regexp(temp{1},',','split');
data = cat(1,r{:});


pp = [];
epoch_list = {};
for row =1: length(data)
    epoch_list.file_id = strjoin(data(row,1));
    epoch = regexp(data{row,2},';','split');
    bad_epoch = [];%zeros(1,length(epoch));
    for i=1: length(epoch)
 		  temp = str2num(epoch{i});
		  if ~isempty(temp),bad_epoch = [bad_epoch temp]; end
    end
    epoch_list.bad_epoch = bad_epoch;
%    pp{row-1}.bad_components = bad_comp;
	 pp = [pp epoch_list];

end

output = pp;

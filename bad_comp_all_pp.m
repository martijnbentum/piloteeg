function output = bad_comp_all_pp()

%function assumes and skips the header
%read in components to be removed
z = fopen('components_no.txt');
temp = textscan(z,'%s','Delimiter','\n');
fclose(z);
temp{1};
r = regexp(temp{1},',','split');
data = cat(1,r{:});

%read in list of filenames
z = fopen('mat_file_list.txt');
fn = textscan(z,'%s','Delimiter','\n');
fclose(z);

pp = [];
comp_list = {};
for row =2: length(data)
    comp_list.file_id = find_filename(data(row,1:2));
    comp = regexp(data{row,3},' ','split');
    bad_comp = [];
    for i=1: length(comp)
        bad_comp(i) = str2num(comp{i});
    end
    comp_list.bad_components = bad_comp;
%    pp{row-1}.bad_components = bad_comp;
	 pp = [pp comp_list];
end

output = pp;
%end

%subfunction
function f = find_filename(comp_line)
%disp(comp_line)
f = '';
found = false;
for i = 1:length(fn{1})
if str2num(comp_line{1}) ==  str2num(fn{1}{i}(3:4)) && str2num(comp_line{2}) == str2num(fn{1}{i}(6:7))
		 f = fn{1}{i}(1:7);
		 found = true;
		 break;
    end
end
if found == false
	disp(comp_line)
	disp(f)
end
%sub function end
end

%function end
end

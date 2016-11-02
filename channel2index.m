function output = channel2index(c,d)

if strcmp(c,'all')
	temp = 1:length(d.label)
else
	temp = [];
	for i = 1:length(c)
		disp(i)
		temp = [temp find(strcmp(d.label,c(i)))];
	end
end

output = temp;
	

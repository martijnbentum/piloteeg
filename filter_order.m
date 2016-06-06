function output = filter_order(cfg)
output = cell(1,20);
for i = 2:20
	disp(i);
	cfg.lpfiltord = i;
	cfg.hpfiltord = i;
	output{i} = ft_preprocessing(cfg)
end

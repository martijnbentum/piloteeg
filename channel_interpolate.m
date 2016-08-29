function  d = channel_interpolate(cfg,d)
%interpolates bad channels
%cfg file can be empty
%neighbours can be given or created (default is triangulation
%bad channels can be given (default assumes cfgchannel.mat file
%layout default EEG1010

%--------------------------------------------------
%prepare neighbours
%--------------------------------------------------
%check whether neighbours are specified otherwise
%create a neighbour structure with triangulation
%--------------------------------------------------
if ~ isfield(cfg,'neighbours')
	c = [];
	if ~isfield(cfg,'layout')
		cfg.layout = 'EEG1010'
	end
	c.layout = cfg.layout

	if ~isfield(cfg,'channel')
		c.channel = d.label;
	else
		c.channel = cfg.channel;
	end

	c.method = 'triangulation'
	cfg.neighbours = ft_prepare_neighbours(c,d);	
end
%--------------------------------------------------


%--------------------------------------------------
%bad channels (interpolation preperation)
%--------------------------------------------------
%check whether bad channels are specified otherwise
%load cfgchannel file for bad channels
%--------------------------------------------------
z = [];
if ~isfield(cfg,'badchannel')
	bc = load(strcat(d.filename(1:7),'_cfgchannel.mat'))
	[n_bad_var_ch,n_bad_cor_ch,n_bad_ch,bad_ch] = bad_channels(bc.d);	
	cfg.badchannel = bad_ch;
end

z.neighbours = cfg.neighbours;
z.badchannel = cfg.badchannel;
z.layout = cfg.layout;
%--------------------------------------------------



%--------------------------------------------------
%channel interpolation, default method is weighted ?average?
%--------------------------------------------------
%only if there are bad channels
%--------------------------------------------------
if ~strcmp(z.badchannel,'none')
	d = ft_channelrepair(z,d); 
end
%store interpolated_channels in datastructure
d.interpolated_channels = z.badchannel
%--------------------------------------------------



function channels = channel_setup(cfg)

if ~isfield(cfg,'setup'),cfg.setup = 'default'; end


c = {'C5' 'C3' 'C1' 'Cz' 'C2' 'C4' 'C6'};
cp = {'CP5' 'CP3' 'CP1' 'CPz' 'CP2' 'CP4' 'CP6'};
p = {'P5' 'P3' 'P1' 'Pz' 'P2' 'P4' 'P6'};
po = {'PO3' 'POz' 'PO4'};


if strcmp(cfg.setup,'default')
%all posterior channels from the C line, excluding all edge electrodes (they are noisy)
%adaptation from damacher, they used a 32 setup, this is 64 setup, they used channels near the edge, which are noisy in this recording.
	channels = [c cp p po];
end

if strcmp(cfg.setup,'damacher')
%similar less dense setup, i use PO instead of O, because these are noisy, I use P5/P6, because P7/P8 are noisy.
	channels = [c([2 4 6]) cp([1 4 7]) p([2 4 6]) po([1 3 5])];
end





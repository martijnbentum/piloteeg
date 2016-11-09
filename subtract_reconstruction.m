function d = subtract_reconstruction(dclean,dreconstruct)

d = dclean;

for i = 1:length(dclean.trial)
	d.trial{i} = dclean.trial{i} - dreconstruct.trial{i};
end

d.reconstruct_file = dreconstruct.filename;


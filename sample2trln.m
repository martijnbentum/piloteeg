%find the trial number based on the sample numbers
function indices = sample2trln(artifact,sample)

indices = [];
for i = 1: length(artifact)
	for j = 1 : length(sample)
		if artifact(i,:) == sample(j,:)
			indices = [indices j];
			break
		end
	end
end

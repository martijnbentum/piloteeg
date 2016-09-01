%find the trial number based on the sample numbers
%artifact contains a list of sample numbers corresponding to bad trials
%if these match with the sample numbers the trln is equal to the index
%of those sample numbers
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

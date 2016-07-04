function ti = add_logprob(d)
%adds a column with logprobs for each words. The logprobs are loaded
%from the file story-id_word-id_logprob, which is create on my storage
%drive in the folder study2. FUNCTION RETURN trailinfo matrix that
%could replace the original matrix in the d file

t = dlmread('story-id_word-id_logprob.txt');
ti = d.trialinfo;
logprob_column = ones(length(ti),1);
ti = [ti logprob_column];
lp_col_index = size(ti,2);
for i = 1:length(ti)
	ids = ti(i,[3 5]);%extract story id and word id
	for r = 1:length(t)
	%search for matching story and word id
		if t(r,1:2) == ids 
			%story id and word id from logprob file match with the ids from the trialinfo matrix
			ti(i,lp_col_index) = t(r,3);%add the logprob
			found = true;
			break
		end
	end
	if found ~= true %if no matching story-id and word-id is found in the logprob filean error is thrown, if the script finishes this did not occur  
		error('did not find story id: %d with word id: %d ',ids)
	end
end


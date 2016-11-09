function dreconstruction = mtrf_reconstruction(dclean,dloudness)

dreconstruction = dclean;

[pathstr,name,ext] = fileparts(dclean.filename);
dreconstruction.filename = strcat(name(1:7),'_inst-reconstruction');

% dreconstruction.mtrf = cell(length(dreconstruction.trial));

for i = 1:length(dreconstruction.trialinfo)
	story_id = dreconstruction.trialinfo(i);
	[w,t,con] = mTRFtrain(dloudness.trial{i}',dclean.trial{i}',1000,0,-150,450,0.1);
	[eeg,r,p,MSE] =mTRFpredict(dloudness.trial{i}',dclean.trial{i}',w,1000,0,-150,450,con);
	dreconstruction.mtrf{i}.t =t;
	dreconstruction.mtrf{i}.con = con;
	dreconstruction.mtrf{i}.r = r;
	dreconstruction.mtrf{i}.p = p;
	dreconstruction.mtrf{i}.mse = MSE;
	dreconstruction.trial{i} = eeg';
end

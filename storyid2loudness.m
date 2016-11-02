function loudness = storyid2loudness(storyid)
%transelates the storyid number 2 the corresponding loudness envelope
fid = fopen('/vol/tensusers/mbentum/STUDY2/Stories_ID.txt')
stories = textscan(fid,'%s\t%s\t%s');

path_loudness = '/vol/tensusers/mbentum/LOUDNESS_ENVELOPE/mark/';
wavname_story = char(stories{3}(storyid));
disp(wavname_story)
[pathstr,name,ext] = fileparts(wavname_story);
loudness_name = strcat(path_loudness,name,'.mat');

disp(storyid)
disp(loudness_name)
loudness = load(loudness_name);
loudness = loudness.loudness;


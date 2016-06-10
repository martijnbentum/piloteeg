%wrapper function to allow saving in parfor loop
function write_file(filename,d)
save(filename,'d');
disp(strcat('written file: ',filename))
end

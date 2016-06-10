%wrapper function to allow saving in parfor loop
function write_data(filename,d)
save(filename,'d','-v7.3');
disp(strcat('written file: ',filename))
end

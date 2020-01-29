data_filename='updated_data.csv';

all_data = csvread(data_filename,1,0);

train_range = 2:floor(size(all_data,1)*0.8);
test_range = (train_range(end)+1):size(all_data,1);

% YEARS
YEARS = all_data(:,1);
% EEC
[EEC, min_EEC, max_EEC] = normalize(all_data(:,2)); 
%GDP
[GDP, ~, ~] = normalize(all_data(:,3)); 
%IMP
[IMP, ~, ~] = normalize(all_data(:,4)); 
%EXP
[EXP, ~, ~] = normalize(all_data(:,5)); 
%POP
[POP, ~, ~] = normalize(all_data(:,6));



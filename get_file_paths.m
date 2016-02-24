function [ file_paths,training_paths ] = get_file_paths( base_path, percent_training_files )
%GET_FILE_PATHS - Walks the PKLot directory and returns a list of all files
%                   as well as a list of training files
%   Detailed explanation goes here
    
    rng(1); % seed the random number generator so test data is consistent
    
    %Specify lot: 1,2, or 3
    %Sample all weather
    %Sample all days
    %Randomly select 10% of each day

    lots = dir(base_path);
    lots = {lots.name};
    lots = lots(~strncmp(lots,'.',1));
    num_lots = max(size(lots));
    lot_path = char(strcat(base_path,lots(1),'/')); %depends on lots index number

    weather_path = {};
    weather = dir(lot_path);
    weather = {weather.name};
    weather = weather(~strncmp(weather,'.',1));
    num_weather = size(weather,2);
    for k=1:num_weather
        weather_path = {weather_path{:} char(strcat(lot_path,weather(k),'/'))};
    end

    day_path = {};
    for k=1:size(weather_path,2)
        day = dir(weather_path{k});
        day = {day.name};
        day = day(~strncmp(day,'.',1));
        num_days = size(day,2);
        for j=1:num_days
            day_path = {day_path{:} char(strcat(weather_path{k},day(j),'/'))};
        end
    end

    file_paths = {};
    training_paths = {};
    for k=1:size(day_path,2)
        file_names = dir(day_path{k});
        file_names = {file_names.name};
        file_names = file_names(~strncmp(file_names,'.',1));

        file_names = unique(cellfun(@(x) x(1:end-4), file_names, 'UniformOutput', false));
        num_files = size(file_names,2);
        l = 1:num_files;
        l = randsample(l,floor(num_files*percent_training_files)); % Extract a percentage of the files for training purposes

        for j=1:num_files % build a list of all files. note each name has a .jpg and .xml
            file_paths = {file_paths{:} strcat(day_path{k},file_names{j})};
            if any(j == l) % extract training files if matches the random 10%
                training_paths = {training_paths{:} strcat(day_path{k},file_names{j})};
            end
        end
    end

end


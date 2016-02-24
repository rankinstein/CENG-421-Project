base_path = 'PKLot/PKLot/';

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
    l = randsample(l,floor(num_files/10)); % approximately 10% of data will be extracted for training
    
    for j=1:num_files % build a list of all files. note each name has a .jpg and .xml
        file_paths = {file_paths{:} strcat(day_path{k},file_names{j})};
        if any(j == l) % extract training files if matches the random 10%
            training_paths = {training_paths{:} strcat(day_path{k},file_names{j})};
        end
    end
end

image_path = strcat(file_paths{300},'.jpg');
xml_path = strcat(file_paths{300},'.xml');

image = imread(image_path);
imshow(image);
hold on;

R = @(deg) [cosd(deg) -sind(deg); sind(deg) cosd(deg)];

s = readXML(xml_path);

num_spaces = size(s,1);
for k = 1:num_spaces
    plot(s(k,2),s(k,3),'b+');
    C = s(k,2:3);
    W = s(k,4)/2;
    H = s(k,5)/2;
    P(1,:) = [W H];
    P(2,:) = [W -H];
    P(3,:) = [-W H];
    P(4,:) = [-W -H];
    Rs = (R(-74)*P')';
    P = [Rs(:,1)+C(1) Rs(:,2)+C(2)];
    if mod(k,3) == 0
        plot(P(1,1),P(1,2),'g+');
        plot(P(2,1),P(2,2),'g+');
        plot(P(3,1),P(3,2),'g+');
        plot(P(4,1),P(4,2),'g+');
%     elseif mod(k,3) == 1
%         plot(P(1,1),P(1,2),'r+');
%         plot(P(2,1),P(2,2),'r+');
%         plot(P(3,1),P(3,2),'r+');
%         plot(P(4,1),P(4,2),'r+');
%     else
%         plot(P(1,1),P(1,2),'c+');
%         plot(P(2,1),P(2,2),'c+');
%         plot(P(3,1),P(3,2),'c+');
%         plot(P(4,1),P(4,2),'c+');   
    end
end

clc, clear, close all;

src_files = dir('vitesse_max_3/*.bmp');  % the folder in which ur images exists
imgs_length = length(src_files);

imgs_ids = zeros(imgs_length, 1);
for i = 1:imgs_length
    id = src_files(i).name();
    imgs_ids(i) = str2double(id(7:end-4));
end
[~, sorted_indexes] = sort(imgs_ids);
src_files = src_files(sorted_indexes);

imgs = cell(double(imgs_length), 1);
for i = 1:imgs_length
    file_path = strcat('vitesse_max_3/',src_files(i).name);
    imgs{i} = imread(file_path);
end

radius_threshold = 1;
ball_region_size = 50;
cell_size = 4;

h = 480;
w = 480;

old_positions = [];
speeds = zeros(imgs_length, 2);
positions = zeros(imgs_length, 2);
for img_index=1:length(imgs)   
    pos = GetBallLocation(cell2mat(imgs(img_index)), w, h, radius_threshold, cell_size, ball_region_size);
    positions(img_index, :) = pos; 
    
    old_positions = AddPosition(old_positions, pos); 
    [speed_x, speed_y] = GetBallSpeed(old_positions); 
    speeds(img_index, :) = [speed_x, speed_y]; 
end

t = 0:39;

figure
% plot(t*34/30,speeds) % à modifier hihi 
plot(speeds) % à modifier hihi 

figure
plot(positions(:,1),-positions(:,2))
xlim([1, 480]);
ylim([-480, -1]);



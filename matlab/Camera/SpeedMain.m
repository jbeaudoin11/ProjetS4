clc, clear, close all;

src_files = dir('vitesse_max_3/*.bmp');  % the folder in which ur images exists
imgs_length = length(src_files);
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

for img_index=1:length(imgs)
    pos = GetBallLocation(cell2mat(imgs(img_index)), w, h, radius_threshold, cell_size, ball_region_size);
    
    % TODO 
end

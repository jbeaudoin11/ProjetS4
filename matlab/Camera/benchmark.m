clc, clear, close all;
folder_path = 'benchmark_imgs/';
% folder_path = 'vitesse_max_3/';
src_files = dir(folder_path);  % the folder in which ur images exists
imgs_length = length(strcat([folder_path, '*.bmp']));

imgs_ids = zeros(imgs_length, 1);
for i = 1:imgs_length
    id = src_files(i).name();
    imgs_ids(i) = str2double(id(7:end-4));
end
[~, sorted_indexes] = sort(imgs_ids);
src_files = src_files(sorted_indexes);

imgs = cell(double(imgs_length), 1);
for i = 1:imgs_length
    file_path = strcat(folder_path, src_files(i).name);
    imgs{i} = imread(file_path);
end

radius_threshold = 1;
ball_region_size = 50;
cell_size = 4;
nb_img = 0;
img_index = 1;

h = 480;
w = 480;

tic
while toc <= 5
    pos = GetBallLocation(cell2mat(imgs(img_index)), w, h, radius_threshold, cell_size, ball_region_size);
    
%         disp(pos)
%     if pos(1) == -1
%         disp(['ERR : ', num2str(img_index)]);
%     end
    
    nb_img = nb_img + 1;
    img_index = mod(img_index + 1, imgs_length) + 1;
end
disp([num2str(nb_img/toc), ' img/sec'])
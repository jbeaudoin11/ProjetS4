clc, clear, close all;

src_files = dir('benchmark_imgs/*.bmp');  % the folder in which ur images exists
imgs_length = length(src_files);
imgs = cell(double(imgs_length), 1);
for i = 1:imgs_length
    file_path = strcat('benchmark_imgs/',src_files(i).name);
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
%     disp(pos)
    
    nb_img = nb_img + 1;
    img_index = mod(img_index + 1, imgs_length) + 1;
end
disp([num2str(nb_img/toc), ' img/sec'])
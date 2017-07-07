clc, clear, close all;

asv_img = imread('imgs/asv.bmp');
zmax_img = imread('imgs/zmax.bmp');
zmin_img = imread('imgs/zmin.bmp');
vmax_img = imread('imgs/vmax.bmp');
none_img = imread('imgs/none.bmp');
center_top_img = imread('imgs/center_top.bmp');
low_light_img = imread('imgs/low_light_13511.bmp');
high_light_img = imread('imgs/high_light_2020.bmp');

imgs = {asv_img, zmax_img, zmin_img, vmax_img, none_img, center_top_img, low_light_img, high_light_img};

i = 1;
img = cell2mat(imgs(i));
data = img(:,:,2); % Use the green layer 
    
radius_threshold = 1;
ball_region_size = 50;
cell_size = 4;
nb_img = 0;

h = 480;
w = 480;

tic
while toc <= 1
    tmp = GetTreshold(data, w, h); % threshold version

    [c, r] = FindBigCircle(tmp, w, h);
    
    r = r - radius_threshold;
    [p_ball, p1] = SearchBallInCircleArea(tmp, c, r, w, h, cell_size, ball_region_size);
    
    nb_img = nb_img + 1;
end
disp([num2str(nb_img), ' img/sec'])
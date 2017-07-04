clc, clear, close all;

asv_img = imread('asv.bmp');
zmax_img = imread('zmax.bmp');
zmin_img = imread('zmin.bmp');
vmax_img = imread('vmax.bmp');
none_img = imread('none.bmp');

imgs = {asv_img, zmax_img, zmin_img, vmax_img, none_img};
i = 1;
img = cell2mat(imgs(i));
    
data = img(:,:,2); % Use the green layer since it looks better

threshold = 210;
radius_threshold = 2;
ball_region_size = 35;
cell_size = 4;
nb_img = 0;

h = 480;
w = 480;

tic
while toc <= 1
    tmp = data > threshold; % threshold version

    [c, r] = FindBigCircle(tmp, w, h);
    r = r - radius_threshold;
    
    SearchBallInCircleArea(tmp, c, r, w, h, cell_size, ball_region_size);
    
    nb_img = nb_img + 1;
end
disp([num2str(nb_img), ' img/sec'])
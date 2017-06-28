clc, clear, close all;

asv_img = imread('asv.bmp');
zmax_img = imread('zmax.bmp');
zmin_img = imread('zmin.bmp');
vmax_img = imread('vmax.bmp');

imgs = {asv_img, zmax_img, zmin_img, vmax_img};

threshold = 150;
radius_threshold = 4;

for i=1:4
% for i=3
    img = cell2mat(imgs(i));
    
    data = squeeze(img(:,:,3)); % Use the blue layer since it looks better
    data = data > threshold; % threshold version
    h = size(data, 1);
    w = size(data, 2);

    [c, r] = FindBigCircle(data, w, h);
    r = r - radius_threshold;

    figure;
    imshow(insertShape(double(data), 'circle', [c, r], 'Color', 'blue'))
   
    SearchInCircleArea(data, c, r, w, h)    
end
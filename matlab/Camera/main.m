clc, clear, close all;

asv_img = imread('asv.bmp');
zmax_img = imread('zmax.bmp');
zmin_img = imread('zmin.bmp');
vmax_img = imread('vmax.bmp');
none_img = imread('none.bmp');

imgs = {asv_img, zmax_img, zmin_img, vmax_img, none_img};

threshold = 210;
radius_threshold = 2;
ball_region_size = 35;
cell_size = 4;

% for i=1:5
for i=1:4
% for i=3
    img = cell2mat(imgs(i));
    
    data = img(:,:,2); % Use the green layer since it looks better
    data = data > threshold; % threshold version
    h = size(data, 1);
    w = size(data, 2);

    [c, r] = FindBigCircle(data, w, h);
    r = r - radius_threshold;

    figure;
    tmp = insertShape(double(data), 'Circle', [c, r], 'Color', 'blue');
    [p_ball, p1] = SearchBallInCircleArea(data, c, r, w, h, cell_size, ball_region_size);
    
    if p_ball(1) == -1
        disp(['No ball in img ', num2str(i)])
    else
        tmp = insertShape(tmp, 'Rectangle', [p1, ball_region_size, ball_region_size], 'Color', 'green');
        tmp = insertShape(tmp, 'FilledCircle', [p_ball, 2], 'Color', 'green');
    end
    
    imshow(tmp)
end
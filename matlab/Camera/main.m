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

radius_threshold = 1;
ball_region_size = 40;
cell_size = 4;

% colored_fig = figure;
% pos_fig = figure;

img_index = 1;
for i=1:length(imgs)
    img = cell2mat(imgs(i));
%     figure(colored_fig)
%     imshow(img)
    subplot(4, 4, img_index)
    imshow(img)
    title(['Image ', num2str(i)]);
    
    % Pick only the green layer since it looks better
    data = img(:,:,2); % Use the green layer 
    h = size(data, 1);
    w = size(data, 2);
%     figure
%     imshow(data)
    
    data = GetTreshold(data, w, h); % threshold version
%     figure
%     imshow(data)

    [c, r] = FindBigCircle(data, w, h);
    
    if r == -1
        disp(['ERR RADIUS FOR IMG ', num2str(i)])
        continue
    end
    
    r = r - radius_threshold;
    [p_ball, p1] = SearchBallInCircleArea(data, c, r, w, h, cell_size, ball_region_size);

    %% Drawing
    
    % Show the big circle
    tmp = double(data);
%     tmp = insertShape(double(data), 'Circle', [c, r], 'Color', 'blue');

    % Show ball area and center
    if p_ball(1) == -1
        disp(['No ball in img ', num2str(i)])
    else
%         tmp = insertShape(tmp, 'Rectangle', [p1, ball_region_size, ball_region_size], 'Color', 'green');
        tmp = insertShape(tmp, 'FilledCircle', [p_ball, 4], 'Color', 'green');
    end

    % Show lines in the calculation of the big circle
%     tmp = insertShape(double(tmp), 'Line', [1, h*.2, w, h*.2], 'Color', 'green');
%     tmp = insertShape(double(tmp), 'Line', [1, h*.4, w, h*.4], 'Color', 'green');
%     tmp = insertShape(double(tmp), 'Line', [1, h*.6, w, h*.6], 'Color', 'green');
%     tmp = insertShape(double(tmp), 'Line', [1, h*.8, w, h*.8], 'Color', 'green');
    
    subplot(4, 4, img_index+1)
    imshow(tmp)
    title(['Image ', num2str(i), ' (', num2str(p_ball(1)), ', ', num2str(p_ball(2)), ')']);
    img_index = img_index + 2;
end
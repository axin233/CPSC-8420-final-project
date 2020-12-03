clc, clear, close all

% Load the original image
ori_image=imread('E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/12v(bright).png');
%%
% Load the mask
All_vals=load('E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/mask.mat');
img_ROI=All_vals.img_ROI;
%%
% Apply the mask to each channel
r_c_1=ori_image(:,:,1);
r_c_1(~img_ROI)=0;
g_c_1=ori_image(:,:,2);
g_c_1(~img_ROI)=0;
b_c_1=ori_image(:,:,3);
b_c_1(~img_ROI)=0;

disp_img_1 = cat(3,r_c_1,g_c_1,b_c_1);

%figure
imshow(disp_img_1);
%%
% Convert an image from RGB color space to HSV color space
HSV_img = rgb2hsv(disp_img_1);

% Reshape matrices to vectors
len=640*480;
h_val=HSV_img(:,:,1);
h_val_v = reshape(h_val, [1,len]);
s_val=HSV_img(:,:,2);
s_val_v = reshape(s_val, [1,len]);
v_val=HSV_img(:,:,3);
v_val_v = reshape(v_val, [1,len]);
%%
% Convert the range 
h_cv=h_val_v*179;
s_cv=s_val_v*255;
v_cv=v_val_v*255;
%%
plot3(h_cv, s_cv, v_cv, '.');
axis equal
xlabel('Hue');
ylabel('Saturation');
zlabel('Value');
%title('Pixel location (HSV color space)');
grid on
%%
% Save the figure as a vector image
f=gcf;
file_path = 'E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/vector_images/';
image_path = append(file_path, 'hsv_color_space.pdf');
exportgraphics(f,image_path,'ContentType','vector');

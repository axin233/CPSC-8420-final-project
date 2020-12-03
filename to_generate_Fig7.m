clc, clear, close all

% Load the original image
ori_image=imread('E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/12v(bright).png');

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
% Reshape matrices to vectors
len=640*480;
r_val=disp_img_1(:,:,1);
r_val_v = reshape(r_val, [1,len]);
g_val=disp_img_1(:,:,2);
g_val_v = reshape(g_val, [1,len]);
b_val=disp_img_1(:,:,3);
b_val_v = reshape(b_val, [1,len]);
%%
plot3(r_val_v, g_val_v, b_val_v, '.');
axis equal
xlabel('Red');
ylabel('Green');
zlabel('Blue');
%title('Pixel location (RGB color space)');
grid on
%%
% Save the figure as a vector image
f=gcf;
file_path = 'E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/vector_images/';
image_path = append(file_path, 'rgb_color_space(1).pdf');
exportgraphics(f,image_path,'ContentType','vector');

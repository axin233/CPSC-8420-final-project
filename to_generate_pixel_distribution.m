clc, clear, close all

% Load the original image
ori_image=imread('E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/12v(dark_1).png');

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

% Display the cropped image
imshow(disp_img_1);

% Load the labels
ori_labels=imread('E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/PixelLabelData_1103/Label_1.png');
%%
% Convert an image from RGB color space to HSV color space
HSV_img = rgb2hsv(disp_img_1);
%%
% Reshape matrices to vectors
len=640*480;
h_val=HSV_img(:,:,1);
h_val_v = reshape(h_val, [1,len]);
s_val=HSV_img(:,:,2);
s_val_v = reshape(s_val, [1,len]);
v_val=HSV_img(:,:,3);
v_val_v = reshape(v_val, [1,len]);
%
label_v=reshape(ori_labels, [1,len]);
%%
% Convert the range 
h_cv=h_val_v*179;
s_cv=s_val_v*255;
v_cv=v_val_v*255;
%%
HSV_data = [h_cv;s_cv;v_cv];
gt_1_temp=[0;0;0];
gt_2_temp=[0;0;0];
gt_3_temp=[0;0;0];
% Classify pixels
for i=1:307200
    if label_v(1,i) == 1 % Membrane
        gt_1_temp = cat(2, gt_1_temp, HSV_data(:,i));
    elseif label_v(1,i) == 2 % Needle
        gt_2_temp = cat(2, gt_2_temp, HSV_data(:,i));
    elseif label_v(1,i) == 3 % Thread
        gt_3_temp = cat(2, gt_3_temp, HSV_data(:,i));
    end
end

% Remove the first column
gt_1 = gt_1_temp(:, 2:end); % Membrane
gt_2 = gt_2_temp(:, 2:end); % Needle
gt_3 = gt_3_temp(:, 2:end); % Thread
%%
% (For the membrane) Count the unique pixels
gt_mem = gt_1';
[C_mem,in_a_mem,in_c_mem] = unique(gt_mem, 'rows');

% (For the membrane) Generate pixel distribution 
num_uni_p_mem = size(in_a_mem,1);
p_freq_mem=zeros(1,num_uni_p_mem);
for i=1:num_uni_p_mem
    count_p=0;
    for j=1:size(in_c_mem,1)        
        if(in_c_mem(j,1)==i)
           count_p=count_p+1; 
        end
    end    
    p_freq_mem(1,i)=count_p;
end
%%
% (For the needle) Count the unique pixels
gt_nee = gt_2';
[C_nee,in_a_nee,in_c_nee] = unique(gt_nee, 'rows');

% (For the needle) Generate pixel distribution 
num_uni_p_nee = size(in_a_nee,1);
p_freq_nee=zeros(1,num_uni_p_nee);
for i=1:num_uni_p_nee
    count_p=0;
    for j=1:size(in_c_nee,1)        
        if(in_c_nee(j,1)==i)
           count_p=count_p+1; 
        end
    end    
    p_freq_nee(1,i)=count_p;
end

%%
% (For the thread) Count the unique pixels
gt_thr = gt_3';
[C_thr,in_a_thr,in_c_thr] = unique(gt_thr, 'rows');

% (For the thread) Generate pixel distribution 
num_uni_p_thr = size(in_a_thr,1);
p_freq_thr=zeros(1,num_uni_p_thr);
for i=1:num_uni_p_thr
    count_p=0;
    for j=1:size(in_c_thr,1)        
        if(in_c_thr(j,1)==i)
           count_p=count_p+1; 
        end
    end    
    p_freq_thr(1,i)=count_p;
end
%%
mem_pixel=C_mem';
nee_pixel=C_nee';
thr_pixel=C_thr';

% Plot the result
scatter3(mem_pixel(1,:), mem_pixel(2,:), mem_pixel(3,:), p_freq_mem, 'r');
hold on
scatter3(nee_pixel(1,:), nee_pixel(2,:), nee_pixel(3,:), p_freq_nee, 'b');
hold on
scatter3(thr_pixel(1,:), thr_pixel(2,:), thr_pixel(3,:), p_freq_thr, 'm');
xlabel('Hue');
ylabel('Saturation');
zlabel('Value');
%title('Pixel distribution (Red: Membrane Blue: Needle Magenta: Thread)');
grid on
%%
% Save the figure as a vector image
f=gcf;
file_path = 'E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/vector_images/pixel_distri/';
image_path = append(file_path, 'h_v(small).pdf');
exportgraphics(f,image_path,'ContentType','vector');

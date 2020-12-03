clc,clear,close all

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

% Show the cropped image
imshow(disp_img_1);

%%
% Create the dataset. The pixels are then converted to HSV color space
% Needle dataset
needle_set=zeros(1,3,3);
needle_set(1,1,1)=126*(1/255); needle_set(1,1,2)=117*(1/255); needle_set(1,1,3)=108*(1/255);
needle_set(1,2,1)=154*(1/255); needle_set(1,2,2)=149*(1/255); needle_set(1,2,3)=145*(1/255);
needle_set(1,3,1)=157*(1/255); needle_set(1,3,2)=153*(1/255); needle_set(1,3,3)=146*(1/255); 
needle_hsv = rgb2hsv(needle_set);

% Thread dataset
thread_set=zeros(1,3,3);
thread_set(1,1,1)=161*(1/255); thread_set(1,1,2)=166*(1/255); thread_set(1,1,3)=182*(1/255);
thread_set(1,2,1)=154*(1/255); thread_set(1,2,2)=162*(1/255); thread_set(1,2,3)=177*(1/255);
thread_set(1,3,1)=161*(1/255); thread_set(1,3,2)=167*(1/255); thread_set(1,3,3)=178*(1/255);
thread_hsv = rgb2hsv(thread_set);

% Membrane dataset
membrane_set=zeros(1,3,3);
membrane_set(1,1,1)=198*(1/255); membrane_set(1,1,2)=198*(1/255); membrane_set(1,1,3)=194*(1/255);
membrane_set(1,2,1)=206*(1/255); membrane_set(1,2,2)=203*(1/255); membrane_set(1,2,3)=200*(1/255);
membrane_set(1,3,1)=196*(1/255); membrane_set(1,3,2)=196*(1/255); membrane_set(1,3,3)=192*(1/255);
membrane_hsv = rgb2hsv(membrane_set);

% Pixels for background. Note that RGB tuple for black is (0,0,0)
background_set=zeros(1,3,3);
bg_hsv=rgb2hsv(background_set);

% Convert the image from RGB color space to HSV color space
HSV_img=rgb2hsv(disp_img_1);
%%
% Reshape matrices to vectors
len=640*480;
h_val=HSV_img(:,:,1);
h_val_v = reshape(h_val, [1,len]);
s_val=HSV_img(:,:,2);
s_val_v = reshape(s_val, [1,len]);
v_val=HSV_img(:,:,3);
v_val_v = reshape(v_val, [1,len]);

% Convert the range 
h_cv=h_val_v*179; s_cv=s_val_v*255; v_cv=v_val_v*255;
needle_h_cv=needle_hsv(:,:,1)*179; needle_s_cv=needle_hsv(:,:,2)*255; needle_v_cv=needle_hsv(:,:,3)*255;
thread_h_cv=thread_hsv(:,:,1)*179; thread_s_cv=thread_hsv(:,:,2)*255; thread_v_cv=thread_hsv(:,:,3)*255;
mem_h_cv=membrane_hsv(:,:,1)*179; mem_s_cv=membrane_hsv(:,:,2)*255; mem_v_cv=membrane_hsv(:,:,3)*255;
bg_h_cv=bg_hsv(:,:,1)*179; bg_s_cv=bg_hsv(:,:,2)*255; bg_v_cv=bg_hsv(:,:,3)*255;
%%
% Classify pixels to different clusters
needle_group=zeros(3,1);
thread_group=zeros(3,1);
mem_group=zeros(3,1);
pixel_num=480*640;
dist_vec=zeros(1,9);

% Calculate the color difference
for i=1:pixel_num
    % (For 3NN) Reset parameters
    is_group_1=0;
    is_group_2=0;
    is_group_3=0;
    
    % Ignore the background pixels. The HSV tuple for background is (0,0,0)
    if h_cv(1,i) ~= 0 || s_cv(1,i) ~= 0 || v_cv(1,i) ~= 0
    
        % For the needle dataset
        for j=1:3
           dist_vec(1,j) = (h_cv(1,i)-needle_h_cv(1,j))^2 + (s_cv(1,i)-needle_s_cv(1,j))^2 +...
                (v_cv(1,i)-needle_v_cv(1,j))^2;
        end

        % For the thread dataset
        for j=1:3
           dist_vec(1,j+3) = (h_cv(1,i)-thread_h_cv(1,j))^2 + (s_cv(1,i)-thread_s_cv(1,j))^2 +...
                (v_cv(1,i)-thread_v_cv(1,j))^2;
        end

        % For the membrane dataset
        for j=1:3
           dist_vec(1,j+6) = (h_cv(1,i)-mem_h_cv(1,j))^2 + (s_cv(1,i)-mem_s_cv(1,j))^2 +...
                (v_cv(1,i)-mem_v_cv(1,j))^2;
        end

        % (For 3NN) Find out the first nearest neighbour
        [dist_1,index_1]=min(dist_vec);
        if (index_1>=1) && (index_1<=3)
            is_group_1 = is_group_1 + 1;
        elseif (index_1>=4) && (index_1<=6)
            is_group_2 = is_group_2 + 1;
        else
            is_group_3 = is_group_3 + 1;
        end
        % Erase the shortest distance
        dist_vec(1,index_1)=10000;
        
        % (For 3NN) Find out the second nearest neighbour
        [dist_2,index_2]=min(dist_vec);
        if (index_2>=1) && (index_2<=3)
            is_group_1 = is_group_1 + 1;
        elseif (index_2>=4) && (index_2<=6)
            is_group_2 = is_group_2 + 1;
        else
            is_group_3 = is_group_3 + 1;
        end
        % Erase the shortest distance
        dist_vec(1,index_2)=10000;
        
        % (For 3NN) Find out the third nearest neighbour
        [dist_3,index_3]=min(dist_vec);
        if (index_3>=1)&&(index_3<=3)
            is_group_1 = is_group_1 + 1;
        elseif (index_3>=4)&&(index_3<=6)
            is_group_2 = is_group_2 + 1;
        else
            is_group_3 = is_group_3 + 1;
        end
        % Erase the shortest distance
        dist_vec(1,index_3)=10000;
        
        % (For 3NN) classify pixels
         % Note: The background pixels are discarded
        pixel_val=[h_cv(1,i);s_cv(1,i);v_cv(1,i)];
        if (is_group_1>is_group_2) && (is_group_1>is_group_3)
            needle_group=cat(2, needle_group, pixel_val);
        elseif (is_group_2>is_group_1) && (is_group_2>is_group_3)
            thread_group=cat(2, thread_group, pixel_val);
        elseif (is_group_3>is_group_1) && (is_group_3>is_group_2)
            mem_group=cat(2, mem_group, pixel_val);
        % if is_group_1=is_group_2=is_group_3=1, assign the pixel to mem_group   
        else 
            mem_group=cat(2, mem_group, pixel_val);
            
        end
     end
end
%%
% Remove the first column
needle_pixel=needle_group(:,2:end);
thread_pixel=thread_group(:,2:end);
mem_pixel=mem_group(:,2:end);

% Plot the classification result
plot3(needle_pixel(1,:), needle_pixel(2,:),needle_pixel(3,:),'b.');
hold on
plot3(thread_pixel(1,:),thread_pixel(2,:),thread_pixel(3,:),'m.');
hold on
plot3(mem_pixel(1,:),mem_pixel(2,:),mem_pixel(3,:),'r.');
axis equal
xlabel('Hue');
ylabel('Saturation');
zlabel('Value');
%title('Results of 3-nearest neighbor (Red: Membrane. Blue: Needle. Magenta: Thread)');
grid on
%%
% Save the figure as a vector image
f=gcf;
file_path = 'E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/vector_images/3nn/';
image_path = append(file_path, 's_v(small).pdf');
exportgraphics(f,image_path,'ContentType','vector');

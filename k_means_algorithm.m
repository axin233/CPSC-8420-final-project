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

% figure
imshow(disp_img_1);

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
%%
% Convert the range 
h_cv=h_val_v*179;
s_cv=s_val_v*255;
v_cv=v_val_v*255;
%%
% Cluster the pixels using k-means algorithm
total_data_temp = [h_cv;s_cv;v_cv];
total_data=total_data_temp';
[idx, Center] = kmeans(total_data,4);
%%
% Classify pixels to clusters.
c_1_temp=[0,0,0];
c_2_temp=[0,0,0];
c_3_temp=[0,0,0];
c_4_temp=[0,0,0];
for i=1:307200
    
    % Ignore the background pixels
    if (total_data(i,1)~=0)||(total_data(i,2)~=0)||((total_data(i,3)~=0))
	
      if idx(i,1)==1
          c_1_temp=cat(1, c_1_temp, total_data(i,:));
      elseif idx(i,1)==2
          c_2_temp=cat(1, c_2_temp, total_data(i,:));
      elseif idx(i,1)==3
          c_3_temp=cat(1, c_3_temp, total_data(i,:));
      elseif idx(i,1)==4
          c_4_temp=cat(1, c_4_temp, total_data(i,:));
      end
    end
end
%%
% Remove the first row
c_1=c_1_temp(2:end,:)';
c_2=c_2_temp(2:end,:)';
c_3=c_3_temp(2:end,:)';
c_4=c_4_temp(2:end,:)';

% Reconstruct the centers
center_1=[Center(2,:);Center(3,:);Center(4,:)];
%%
% Plot the clusters
plot3(c_2(1,:),c_2(2,:),c_2(3,:),'b.');
hold on
plot3(c_3(1,:),c_3(2,:),c_3(3,:),'m.');
hold on
plot3(c_4(1,:),c_4(2,:),c_4(3,:),'r.');
%hold on
%plot3(center_1(:,1),center_1(:,2),center_1(:,3),'kx','MarkerSize',15,'LineWidth',3);
axis equal
xlabel('Hue');
ylabel('Saturation');
zlabel('Value');
%title('Classification results (4-means)');
grid on
%%
% Save the figure as a vector image
f=gcf;
file_path = 'E:/project_for_Matlab_and_ADS/suturing_project/check_pixel_value/vector_images/4means/';
image_path = append(file_path, 's_v(small).pdf');
exportgraphics(f,image_path,'ContentType','vector');

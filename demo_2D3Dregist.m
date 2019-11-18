% 3D Path planning from a single fluorosocopic image for robot assisted
% fenestrated endovascular aortic repair:
% This demostrates how to recover a 3D skeleton for the robotic path from a
% 2D intra-operative segmented aneurysm shape and a 3D pre-operative 
% skeleton.
% It will import a 2D jpg image of pre-operative fluoroscopy, a 2D
% segmentation label, and a 3D skeleton. It will display the time cost for
% registration of 2D/3D skeletons, the intra-operative (ground truth)
% skeleton, pre-operative skeleton and our prediction, as well as the
% evaluated distance errors in 2D and 3D.
%==========================================================================
%   $ Copyright (c) 2019, Jian-Qing Zheng
%   $ This code is under Apache License, Version 2.0, January 2004
%   $ http://www.apache.org/licenses/LICENSE-2.0.
%   For any academic publication using this code, please kindly cite:
%     J. Q. Zheng, X. Y. Zhou, C. Riga and G. Z. Yang, "Towards 3D Path Planning
%     from a Single 2D Fluoroscopic Image for Robot Assisted Fenestrated
%     Endovascular Aortic Repair", IEEE International Conference on
%     Robotics and Automation (ICRA), 2019.
%==========================================================================
% Version: Matlab R2016a to R2017a
% Platform: Windows, Linux

%% clear 
clear
close all
%% image parameter setting
img_size=512;
shiftlen=0;
voxel_resolution=0.452607;
R0=[0,0,-1;1,0,0;0,-1,0];
T0=[0;0;0.9];
R_rigid=R0;
T_rigid=T0;
hsize = [5,5];
sigma = 2.5;
%% option
showvolume=0; %1 spend a lot of time 
volume_numb=23;
picture_numb=26;
%% centerline / skeleton
%== 2D
a = imread(['f',array2str(picture_numb,'_'),'.JPG']);
Img_Original=imresize(a(:,:,2),[img_size,img_size],'nearest');
h = fspecial('gaussian', hsize, sigma);
testvol = imfilter(not(Img_Original), h, 'replicate');
skel2D = Skeleton3D(testvol);
[x,y]=find(skel2D);
points2D=[x,y]';
%== 3D
m=load(['Skeleton3D_P',array2str(volume_numb,'_')]);
skel = struct2array(m);
skel3D=skel;
[X,Y,Z]=ind2sub(size(skel3D),find(skel3D==1));
points3D=[X,Y,Z]';
%% Ground Truth
m=load(['Skeleton3D_P',array2str(picture_numb,'_')]);
skel_gt= struct2array(m);
[X,Y,Z]=ind2sub(size(skel_gt),find(skel_gt==1));
[~,P_gt]=project3D22D([X,Y,Z]',R0,T0,img_size);
p_gt=unique(points2D','rows')';
%% rigid transformation
[points3D_proj,points3D_rigid]=project3D22D(points3D,R_rigid,T_rigid,img_size);
%% Proposed method
[uopt,idx_del,idx_inline_3D,M2,T2]=regist2D3D(points2D,points3D,R_rigid,T_rigid);
points3D_rigid2=points3D_rigid(:,~idx_del);

%% plot skeleton
R=eye(3);
T=[0;0;0];
[Pp2,P3D2]=(project3D22D(points3D_rigid2+uopt,R,T,img_size));
Pp2_tmp=round(Pp2);
Pp2_tmp(:,any(Pp2<1))=[];
Pp2_tmp(:,any(Pp2>img_size))=[];
skel3Dp2=zeros(size(2*skel,1),size(2*skel,2));%
skel3Dp2(Pp2_tmp(1,:)+(Pp2_tmp(2,:)-1).*(size(skel3Dp2,1)))=1;

% subplot(1,3,2);
% imshow(skel3DP,[]);
% [Pr,P3R]=(project3D22D(points3D_rigid,R,T,img_size));
Pr=round(points3D_proj);
Pr(:,any(Pr<1))=[];
Pr(:,any(Pr>img_size))=[];
skel3DPw=zeros(size(2*skel,1),size(2*skel,2));%
skel3DPw(Pr(1,:)+(Pr(2,:)-1).*(size(skel3DPw,1)))=1;
% subplot(1,3,3);
% imshow(skel3DPw,[]);
img2D2=cat(3,skel3Dp2,skel3DPw,skel2D);

a= imread(['IMG',array2str(picture_numb,'_'),'.JPG']);
a=wshift('2D',a(:,:),[-shiftlen,0]);
if shiftlen>0
    a(1:shiftlen,:)=0;
else
    a(end-shiftlen+1:end,:)=0;
end
IMG2D=double(imresize(a,[img_size,img_size],'bilinear'));
IMG2D=IMG2D(:,:,[1,1,1])./max(max(max(IMG2D)));
img_tmp=IMG2D;
mask_tmp=any(img2D2,3);
img_tmp(mask_tmp(:,:,[1,1,1]))=0;
img2D2=img2D2+img_tmp;
figure
imshow(img2D2,[]);
%% 3D skeleton
% 2
figure();
% load shape
if showvolume
    % load
    m=load(['Label_save_P',array2str(picture_numb,'_')]);
    a = struct2array(m);
    testvol=permute(a,[3,1,2]);
    testvol(end:-1:1,:,end:-1:1)=testvol;
    testvol(:,:,1:end-51)=testvol(:,:,52:end);
    % volume2mesh
    col=[.7 .7 .8];
    hiso = patch(isosurface(testvol,0),'FaceColor',col,'EdgeColor','none');
    hiso2 = patch(isocaps(testvol,0),'FaceColor',col,'EdgeColor','none');
    axis equal;axis off;
    lighting phong;
    isonormals(testvol,hiso);
end
alpha(0.5);
set(gca,'DataAspectRatio',[1 1 1])
camlight;
hold on;
w=size(skel,1);
l=size(skel,2);
h=size(skel,3);
x=P_gt(1,:)';
y=P_gt(2,:)';
z=P_gt(3,:)'-img_size;
plot3(y,x,z,'square','Markersize',4,'MarkerFaceColor','b','Color','b');
x=points3D_rigid2(1,:)';
y=points3D_rigid2(2,:)';
z=points3D_rigid2(3,:)'-img_size;
plot3(y,x,z,'square','Markersize',4,'MarkerFaceColor','g','Color','g');
x=P3D2(1,:)';
y=P3D2(2,:)';
z=P3D2(3,:)'-img_size;
plot3(y,x,z,'square','Markersize',4,'MarkerFaceColor','r','Color','r');

set(gcf,'Color','white');
view(140,80)
imshow(img2D2,[]);

%% Error
%-- 3D
[~,dist3D_vec0]=distance2curve(P_gt',(points3D_rigid)','sp');
dist3D_error_avr0=mean(dist3D_vec0).*voxel_resolution;
dist3D_error_std0=std(dist3D_vec0).*voxel_resolution;
%-- 2D
[~,dist2D_vec0]=distance2curve(p_gt',(points3D_proj)','sp');
dist2D_error_avr0=mean(dist2D_vec0).*voxel_resolution;
dist2D_error_std0=std(dist2D_vec0).*voxel_resolution;
disp('input shape difference:')
disp(['3D distance (avg/std): ',num2str(dist3D_error_avr0),'mm / ',num2str(dist3D_error_std0),'mm'])
disp(['2D distance (avg/std): ',num2str(dist2D_error_avr0),'pix / ',num2str(dist2D_error_std0),'pix'])
%-- 3D
[~,dist3D_vec2]=distance2curve(P_gt',(P3D2(:,idx_inline_3D(~(idx_del))))','sp');
dist3D_error_avr2=mean(dist3D_vec2).*voxel_resolution;
dist3D_error_std2=std(dist3D_vec2).*voxel_resolution;
%-- 2D
[~,dist2D_vec2]=distance2curve(p_gt',(Pp2(:,idx_inline_3D(~(idx_del))))','sp');
dist2D_error_avr2=mean(dist2D_vec2).*voxel_resolution;
dist2D_error_std2=std(dist2D_vec2).*voxel_resolution;
disp('error for the proposed method:')
disp(['3D distance (avg/std): ',num2str(dist3D_error_avr2),'mm / ',num2str(dist3D_error_std2),'mm'])
disp(['2D distance (avg/std): ',num2str(dist2D_error_avr2),'pix / ',num2str(dist2D_error_std2),'pix'])

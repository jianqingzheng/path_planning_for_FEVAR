%   projected 2D and transformed 3D coordinates with rigid transformation
%   Revision: 1.0
%   Date: 2018/6/20
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
%   Description:
%   'project3D22D' calculate the projected 2D and transformed 3D 
%   coordinates with given points set and rigid transformation parameters.
%
%   [points2D,points3D_transl] = project3D22D(points_3D,R,T,dist)
%   'points_3D'	- the 3D points coordinates
%   'R'         - the rotation matrix
%   'T'       	- the translation vector
%   'dist'      - the distance between the focal point and the screen
%--------------------------------------------------------------------------
%   See also: ''.
function [points2D,points3D_transl]=project3D22D(points_3D,R,T,dist)
if nargin<4
    points3D_norm=points_3D;
else
    points3D_norm=points_3D./dist-0.5;
end
if size(T,2)<=1
    T=T(:,ones(1,size(points_3D,2)));
end
points3D_transl_norm=R*points3D_norm+T;
points2D_norm=points3D_transl_norm([1,2],:)./points3D_transl_norm([3,3],:);
if nargin<4
    points3D_transl=points3D_transl_norm;
    points2D=(points2D_norm+0.5);
else
points3D_transl=(points3D_transl_norm+0.5).*dist;
points2D=(points2D_norm+0.5).*dist;
end
end

%   soft-assigning of trunk nodes in 2D and 3D
%   Revision: 1.0
%   Date: 2019/2/1
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
%   'branch_node_assign' returns the correspondence between the inline 2D
%   and 3D trunk nodes, as well as the inline indices.
%
%   [match_matrix,idx_inline_2D,idx_inline_3D] = trunk_node_assign(
%   points2D,points3D,id_cross_2D,id_cross_3D,gd_trunk_2D,gd_trunk_3D,
%   match_matrix)
%   'match_matrix'      - the soft-assigning matrix between 2D and 3D nodes
%   'idx_inline_2D'     - the indices of assigned inline 2D skeleton nodes
%   'idx_inline_3D'     - the indices of assigned inline 3D skeleton nodes
%   'points2D'          - the 2D skeleton points' coordinates
%   'points3D_proj'     - the projected 2D coordinates of 3D skeleton
%                       points
%   'id_cross_2D'       - the indices of cross/junction 2D skeleton nodes
%   'id_cross_3D'     	- the indices of cross/junction 3D skeleton nodes
%   'gd_trunk_2D'       - the arrays of geodesic distances for 2D trunk
%                       nodes
%   'gd_trunk_3D'       - the arrays of geodesic distances for 3D trunk
%                       nodes
%--------------------------------------------------------------------------
%   See also: 'placement_match', 'branch_node_assign'.
function [match_matrix]=trunk_node_assign(points2D,points3D,id_cross_2D,id_cross_3D,gd_trunk_2D,gd_trunk_3D,match_matrix)
if nargin<7
    match_matrix=zeros(size(points2D,2),size(points3D,2));
    
end
id_crossid2startfinal=[1,2;2,3;3,1];
for i=[1,3]
    idx_trunk_2D=gd_trunk_2D(i,:)>0;
    id_trunk_2D=find(idx_trunk_2D);
    idx_trunk_3D=gd_trunk_3D(i,:)>0;
    id_trunk_3D=find(idx_trunk_3D);
    pnumber_2D=sum(idx_trunk_2D);%
    pnumber_3D=sum(idx_trunk_3D);%
    
    P_trunk_2D=points2D(:,idx_trunk_2D);%
    P_trunk_3D=points3D(:,idx_trunk_3D);%
    
    [~,id_gd_2D]=sort(gd_trunk_2D(i,idx_trunk_2D),'ascend');
    [~,id_gd_3D]=sort(gd_trunk_3D(i,idx_trunk_3D),'ascend');
    P_trunk_2D_sort=[points2D(:,id_cross_2D(id_crossid2startfinal(i,2))),P_trunk_2D(:,id_gd_2D),points2D(:,id_cross_2D(id_crossid2startfinal(i,1)))];
    P_trunk_3D_sort=[points3D(:,id_cross_3D(id_crossid2startfinal(i,2))),P_trunk_3D(:,id_gd_3D),points3D(:,id_cross_3D(id_crossid2startfinal(i,1)))];
    dist_b2b_2D=[0,sum(abs(conv2(P_trunk_2D_sort,[-1,1],'valid'))).^0.5];
    %     dist_b2b_2D=dist_b2b_2D(1:pnumber_2D);
    dist_b2b_3D=[0,sum((conv2(P_trunk_3D_sort,[-1,1],'valid').^2)).^0.5];
    %     dist_b2b_3D=dist_b2b_3D(1:pnumber_3D);
    dist_b2c_2D=dist_b2b_2D*triu(ones(pnumber_2D+2,pnumber_2D+2),0);
    dist_b2c_3D=dist_b2b_3D*triu(ones(pnumber_3D+2,pnumber_3D+2),0);
    dist_b2b_2D_norm=dist_b2b_2D./dist_b2c_2D(end);
    dist_b2c_2D_norm=dist_b2c_2D./dist_b2c_2D(end);
    dist_b2c_3D_norm=dist_b2c_3D./dist_b2c_3D(end);
    
    
    [match_matrix_sort]=placement_match(dist_b2c_2D_norm,dist_b2c_3D_norm,dist_b2b_2D_norm);
    match_matrix([id_cross_2D(id_crossid2startfinal(i,2)),id_trunk_2D(id_gd_2D),id_cross_2D(id_crossid2startfinal(i,1))],[id_cross_3D(id_crossid2startfinal(i,2)),id_trunk_3D(id_gd_3D),id_cross_3D(id_crossid2startfinal(i,1))])=match_matrix_sort;
end

end

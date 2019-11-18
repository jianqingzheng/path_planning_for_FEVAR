%   soft-assign 2D nodes and 3D nodes according to the euclidean distances
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
%   'placement_match' returns the match matrix via calculating the
%   euclidean distance between the neighbouring 3D and 2D branch/trunk
%   nodes.
%
%   [match_matrix] = placement_match(placement1,placement2,dist1)
%   'match_matrix'  - the soft-assigning matrix between 2D and 3D nodes
%   'placement1'    - the placement length of the first set of points
%   'placement2'    - the placement length of the second set of points
%   'dist1'         - the euclidean distance between each two of the first
%                   set of points
%--------------------------------------------------------------------------
%   See also: 'branch_node_assign', 'trunk_node_assign'.
function [match_matrix]=placement_match(placement1,placement2,dist1)
dist_matrix=points_dist(placement1,placement2,-1);
sign_matrix=sign(dist_matrix);
idx_matrix_tmp=conv2(sign_matrix,[1;-1],'full');
idx_matrix=double(idx_matrix_tmp(1:end-1,:)==2);%
idx_matrix(idx_matrix_tmp(2:end,:)==2)=-1;
idx_matrix(1,idx_matrix_tmp(1,:)==1)=1;
[id_matrix,~]=find(idx_matrix==1);
% idx_matrix(sign_matrix==0)=1;
idx_coin=any(sign_matrix==0);
dist_tmp(idx_coin)=1;
dist_tmp(~idx_coin)=dist1(id_matrix);
match_matrix=idx_matrix.*dist_matrix./dist_tmp(ones(1,size(dist_matrix,1)),:);
match_matrix(match_matrix>0|sign_matrix==0)=1-match_matrix(match_matrix>0|sign_matrix==0);
end

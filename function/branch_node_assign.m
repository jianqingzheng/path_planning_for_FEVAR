%   soft-assigning of branch nodes in 2D and 3D
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
%   and 3D branch nodes, as well as the inline indices.
%
%   [match_matrix,idx_inline_2D,idx_inline_3D] = branch_node_assign(
%   points2D,points3D_proj,id_cross_2D,id_cross_3D,gd_branch_2D,
%   gd_branch_3D,match_matrix,idx_inline_2D,idx_inline_3D)
%   'match_matrix'      - the soft-assigning matrix between 2D and 3D nodes
%   'idx_inline_2D'     - the indices of inline 2D skeleton nodes
%   'idx_inline_3D'     - the indices of inline 3D skeleton nodes
%   'points2D'          - the 2D skeleton points' coordinates
%   'points3D_proj'     - the projected 2D coordinates of 3D skeleton points
%   'id_cross_2D'       - the indices of cross/junction 2D skeleton nodes
%   'id_cross_3D'     	- the indices of cross/junction 3D skeleton nodes
%   'gd_branch_2D'      - the arrays of geodesic distances for 2D branch 
%                       nodes
%   'gd_branch_3D'      - the arrays of geodesic distances for 3D branch 
%                       nodes
%--------------------------------------------------------------------------
%   See also: 'placement_match', 'trunk_node_assign'.
function [match_matrix,idx_inline_2D,idx_inline_3D]=branch_node_assign(points2D,points3D_proj,id_cross_2D,id_cross_3D,gd_branch_2D,gd_branch_3D,match_matrix,idx_inline_2D,idx_inline_3D)
if nargin<9
    idx_inline_3D=true(1,size(points3D_proj,2));
    if nargin<8
        idx_inline_2D=true(1,size(points2D,2));
        if nargin<7
            match_matrix=zeros(size(points2D,2),size(points3D_proj,2));
            
        end
    end
end
id_crossid2branch=[1,2,2,3,3];
for i=1:size(gd_branch_2D,1)
    idx_branch_2D=gd_branch_2D(i,:)>0;
    id_branch_2D=find(idx_branch_2D);
    idx_branch_3D=gd_branch_3D(i,:)>0;
    id_branch_3D=find(idx_branch_3D);
    pnumber_2D=sum(idx_branch_2D);%
    pnumber_3D=sum(idx_branch_3D);%
    P_cross_2D=points2D(:,id_cross_2D(id_crossid2branch(i)));
    P_cross_3Dp=points3D_proj(:,id_cross_3D(id_crossid2branch(i)));
    P_cross_tmp_2D=P_cross_2D(:,ones(1,pnumber_2D));
    P_cross_tmp_3Dp=P_cross_3Dp(:,ones(1,pnumber_3D));
    
    P_branch_2D=points2D(:,idx_branch_2D);%
    P_branch_3Dp=points3D_proj(:,idx_branch_3D);%
    P_branch_2D_norm=P_branch_2D-P_cross_tmp_2D;
    P_branch_3Dp_norm=P_branch_3Dp-P_cross_tmp_3Dp;
    [~,id_gd_2D]=sort(gd_branch_2D(i,idx_branch_2D),'ascend');
    [~,id_gd_3D]=sort(gd_branch_3D(i,idx_branch_3D),'ascend');
    P_branch_2D_sort=P_branch_2D_norm(:,id_gd_2D);
    P_branch_3Dp_sort=P_branch_3Dp_norm(:,id_gd_3D);
    dist_b2b_2D=sum(abs(conv2(P_branch_2D_sort,[-1,1],'full'))).^0.5;
    dist_b2b_2D=dist_b2b_2D(1:pnumber_2D);
    dist_b2b_3D=sum((conv2(P_branch_3Dp_sort,[-1,1],'full').^2)).^0.5;
    dist_b2b_3D=dist_b2b_3D(1:pnumber_3D);
    dist_b2c_2D=dist_b2b_2D*triu(ones(pnumber_2D,pnumber_2D),0);
    dist_b2c_3D=dist_b2b_3D*triu(ones(pnumber_3D,pnumber_3D),0);
    idx_inline_2D_sort=dist_b2c_2D<dist_b2c_3D(end);
    if any(~idx_inline_2D_sort)
        idx_inline_2D_sort(find(~idx_inline_2D_sort,1,'first'))=1;
    end
    id_inline_2D_sort=find(idx_inline_2D_sort);%
    %         if ~isempty(id_outline_2D_sort)
    %             id_outline_2D_sort(1)=[];
    %         end
    
    idx_inline_3D_sort=(dist_b2c_3D<=dist_b2c_2D(end));
    id_inline_3D_sort=find(idx_inline_3D_sort);%
    [match_matrix_sort_inline]=placement_match(dist_b2c_2D(idx_inline_2D_sort),dist_b2c_3D(idx_inline_3D_sort),dist_b2b_2D);
    match_matrix(id_branch_2D(id_gd_2D(idx_inline_2D_sort)),id_branch_3D(id_gd_3D(idx_inline_3D_sort)))=match_matrix_sort_inline;
    tmp=sum(match_matrix);
    match_matrix(id_cross_2D(id_crossid2branch(i)),(tmp>0&tmp<1))=1-tmp(tmp>0&tmp<1);
    idx_inline_2D_sort((~any(match_matrix_sort_inline,2)))=0;
    idx_inline_2D(id_branch_2D(id_gd_2D))=idx_inline_2D_sort;
    idx_inline_3D(id_branch_3D(id_gd_3D))=idx_inline_3D_sort;
    %
    %         % branch rotation
    %         [U,~,V]=svd(P_branch_2D_norm*P_branch_3Dp_norm');
    %         P_branch_3Dp_rot=U*V'*P_branch_3Dp_norm;
    %         % distance matrix
    %         pdist_2D3D=pdist2(P_branch_2D,P_branch_3Dp_rot,'euclidean');
    %
end
end
% function [match_matrix]=placement_match(placement1,placement2,dist1)
% dist_matrix=points_dist(placement1,placement2,-1);
% sign_matrix=sign(dist_matrix);
% idx_matrix_tmp=conv2(sign_matrix,[1;-1],'full');
% idx_matrix=double(idx_matrix_tmp(1:end-1,:)==2);%
% idx_matrix(idx_matrix_tmp(2:end,:)==2)=-1;
% idx_matrix(1,idx_matrix_tmp(1,:)==1)=1;
% [id_matrix,~]=find(idx_matrix==1);
% % idx_matrix(sign_matrix==0)=1;
% dist_tmp=dist1(id_matrix);
% match_matrix=idx_matrix.*dist_matrix./dist_tmp(ones(1,size(dist_matrix,1)),:);
% match_matrix(match_matrix>0|sign_matrix==0)=1-match_matrix(match_matrix>0|sign_matrix==0);
% end

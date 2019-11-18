%   classify skeleton node and calculate their geodesic distance
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
%   'node_classification' classify each skeleton node in end/junction node
%   and branch/trunk node in 2D and 3D and calculate their geodesic 
%   distance to the neighbouring junction node.
%
%   [gd_save,id_end_cross_save,idx_del,id_end_cross_del,gd_trunk,
%   id_start_final] = node_classification(adj_matrix,save_numb)
%   'gd_save'           - the geodesic distances of the preserved branch 
%                       nodes from their neighbouring junction nodes
%   'id_end_cross_save' - the indices of end and junction nodes of the
%                       preserved branches
%   'idx_del'           - the indices of deleted branch nodes
%   'id_end_cross_del'  - the indices of end and junction nodes of the
%                       deleted branches
%   'gd_trunk'          - the geodesic distances of the trunk nodes from
%                       their neighbouring junction nodes
%   'id_start_final'    - the indices of two junction nodes of the trunks
%   'adj_matrix'     	- the adjacency matrix
%   'save_numb'         - the number of preserved branches
%--------------------------------------------------------------------------
%   See also: ''.
function [gd_save,id_end_cross_save,idx_del,id_end_cross_del,gd_trunk,id_start_final]=node_classification(adj_matrix,save_numb)
%% parameter transfer
maximum_gd=1e10;

%% get end & cross points
idx_end_points=sum(adj_matrix)==1;
% id_end_points=find(idx_end_points);
idx_cross_points=get_cross_points(adj_matrix);
% id_cross_points=find(idx_cross_points);
%% initialization
branch_numb=sum(idx_end_points);
trunk_numb=sum(idx_cross_points)-branch_numb+save_numb-1;
point_numb=size(adj_matrix,2);
gd_save=zeros(save_numb,point_numb);
idx_del=zeros(branch_numb-save_numb,size(adj_matrix,2));
gd_trunk=zeros(trunk_numb,size(adj_matrix,2));
id_end_cross_save=zeros(save_numb,2);
id_end_cross_del=zeros(branch_numb-save_numb,2);
id_start_final=zeros(trunk_numb,2);
idx_considered_row=zeros(1,branch_numb+sum(idx_cross_points));
id_to_consider_row=find(~idx_considered_row);
idx_end_cross=idx_end_points|idx_cross_points;
id_end_cross=find(idx_end_cross);
idx_to_consider_row_end=idx_end_points(idx_end_cross);
id_to_consider_row_end=find(idx_to_consider_row_end);
idx_to_consider_row_cross=idx_cross_points(idx_end_cross);
id_to_consider_row_cross=find(idx_to_consider_row_cross);
idx_considered_col=zeros(1,point_numb);
id_to_consider_col=find(~idx_considered_col);
idx_points_to_consider_cross=~idx_considered_col&idx_cross_points;
idx_to_consider_col_cross=idx_points_to_consider_cross(~idx_considered_col);
id_to_consider_col_cross=find(idx_to_consider_col_cross);
%% 
gds_matrix_tmp=eye(size(adj_matrix,1));
gds_matrix_tmp(gds_matrix_tmp==0)=inf;
gds_matrix_tmp(logical(eye(size(adj_matrix,1))))=0;
gds_matrix_tmp=gds_matrix_tmp(idx_end_points|idx_cross_points,:);
state_matrix_tmp=eye(size(adj_matrix,1));
state_matrix_tmp=state_matrix_tmp(idx_end_points|idx_cross_points,:);
gd_numb=0;%max(max(state_matrix_tmp));
update_matrix_tmp=double(adj_matrix);
found_numb=0;
found_numb2=0;
while found_numb<branch_numb||found_numb2<trunk_numb
    id_found_end_tmp=[];
    id_found_cross_start_tmp=[];%
    while gd_numb<maximum_gd&&isempty(id_found_end_tmp)&&isempty(id_found_cross_start_tmp)
        state_matrix_tmp=(state_matrix_tmp*update_matrix_tmp+state_matrix_tmp)>0;
        state_inf_mat_tmp=double(state_matrix_tmp);
        state_inf_mat_tmp(state_inf_mat_tmp==0)=inf;
        gd_numb=gd_numb+1;
        [gds_matrix_tmp,id_min_gds_matrix]=min(cat(3,gds_matrix_tmp,(state_inf_mat_tmp).*gd_numb),[],3);
        [id_found_end_tmp,id_found_cross_tmp]=find(id_min_gds_matrix(idx_to_consider_row_end,idx_to_consider_col_cross)==2);
        if found_numb-branch_numb+save_numb>0
            [id_found_cross_start_tmp,id_found_cross_final_tmp]=find(id_min_gds_matrix(idx_to_consider_row_cross,idx_to_consider_col_cross)==2);
        end
    end
    if ~isempty(id_found_end_tmp)
        [id_found_cross_tmp,id_unique]=unique(id_found_cross_tmp);
        id_found_end_tmp=id_found_end_tmp(id_unique);
    end
    if ~isempty(id_found_cross_start_tmp)
    % unique found trunk
    [~,id_unique]=unique(sort([id_end_cross(id_to_consider_row(id_to_consider_row_cross(id_found_cross_start_tmp))),id_to_consider_col(id_to_consider_col_cross(id_found_cross_final_tmp))],2),'rows');
    id_found_cross_start_tmp=id_found_cross_start_tmp(id_unique);
    id_found_cross_final_tmp=id_found_cross_final_tmp(id_unique);
    end
    idx_found_branch=zeros(1,size(gds_matrix_tmp,2));
    for i=1:numel(id_found_end_tmp)
        found_numb=found_numb+1;
        numb_tmp=found_numb-branch_numb+save_numb;
        [idx_found_branch_tmp,gd_branch_tmp]=branch_search(gds_matrix_tmp,id_to_consider_row_end(id_found_end_tmp(i)),id_to_consider_row_cross(id_found_cross_tmp(i)),gd_numb);
        idx_found_branch_tmp(id_to_consider_col_cross(id_found_cross_tmp(i)))=0;
        idx_found_branch=idx_found_branch|idx_found_branch_tmp;
        if numb_tmp<=0
            % delete
            id_end_cross_del(found_numb,:)=[id_end_cross(id_to_consider_row(id_to_consider_row_end(id_found_end_tmp(i)))),id_to_consider_col(id_to_consider_col_cross(id_found_cross_tmp(i)))];
            
            idx_del(found_numb,~idx_considered_col)=logical(idx_found_branch_tmp);
        else
            % save
            id_end_cross_save(numb_tmp,:)=[id_end_cross(id_to_consider_row(id_to_consider_row_end(id_found_end_tmp(i)))),id_to_consider_col(id_to_consider_col_cross(id_found_cross_tmp(i)))];
            
            gd_save(numb_tmp,~idx_considered_col)=gd_branch_tmp;
            %idx_to_consider_row_found_end_cross([id_to_consider_row_cross(id_found_cross_tmp(i))])=0;
        end
    end
    for i=1:numel(id_found_cross_start_tmp)
        found_numb2=found_numb2+1;
        [idx_found_branch_tmp,gd_branch_tmp]=branch_search(gds_matrix_tmp,id_to_consider_row_cross(id_found_cross_start_tmp(i)),id_to_consider_row_cross(id_found_cross_final_tmp(i)),gd_numb);
        id_start_final(found_numb2,:)=[id_end_cross(id_to_consider_row(id_to_consider_row_cross(id_found_cross_start_tmp(i)))),id_to_consider_col(id_to_consider_col_cross(id_found_cross_final_tmp(i)))];
        gd_trunk(found_numb2,~idx_considered_col)=gd_branch_tmp;
    end
    idx_to_consider_row_found_end_cross=zeros(1,size(id_min_gds_matrix,1));
    if numb_tmp<=0
        idx_to_consider_row_found_end_cross([id_to_consider_row_end(id_found_end_tmp),id_to_consider_row_cross(id_found_cross_tmp)])=1;%%%7
    else
        idx_to_consider_row_found_end_cross([id_to_consider_row_end(id_found_end_tmp)])=1;
    end
    % update
    idx_considered_row(~idx_considered_row)=idx_to_consider_row_found_end_cross;
    id_to_consider_row=find(~idx_considered_row);
    idx_to_consider_row_end=idx_to_consider_row_end(~idx_to_consider_row_found_end_cross);
    id_to_consider_row_end=find(idx_to_consider_row_end);
    idx_to_consider_row_cross=idx_to_consider_row_cross(~idx_to_consider_row_found_end_cross);%
    id_to_consider_row_cross=find(idx_to_consider_row_cross);
    idx_considered_col(~idx_considered_col)=idx_found_branch;%%
    id_to_consider_col=find(~idx_considered_col);
    if numb_tmp<=0
    idx_to_consider_col_cross(id_to_consider_col_cross(id_found_cross_tmp))=0;
    end
    idx_to_consider_col_cross=idx_to_consider_col_cross(~idx_found_branch);%
    id_to_consider_col_cross=find(idx_to_consider_col_cross);
    gds_matrix_tmp=gds_matrix_tmp(~idx_to_consider_row_found_end_cross,~idx_found_branch);%%
    update_matrix_tmp=update_matrix_tmp(~idx_found_branch,~idx_found_branch);%%
    state_matrix_tmp=state_matrix_tmp(~idx_to_consider_row_found_end_cross,~idx_found_branch);
end
end

function [idx_saved]=get_cross_points(adj_matrix)
idx_cross_point=(sum(adj_matrix==1)>=3);%&sum(gds_matrix==2)>=3;%&sum(gds_matrix==3)>=3;%
gds_cross_mat=shortest_path_length(adj_matrix(idx_cross_point,idx_cross_point));
idx_saved_cross=~any(adj_matrix(idx_cross_point,idx_cross_point));
idx_considered=idx_saved_cross;
%%
gds_mat_tmp=gds_cross_mat(~idx_considered,~idx_considered);
gds_mat_tmp(logical(eye(size(gds_mat_tmp,1))))=1;
%%
while ~all(idx_considered)
idx_linked_tmp=gds_mat_tmp(1,:)<inf;
linked_mat_tmp=adj_matrix(idx_linked_tmp,idx_linked_tmp);
[~,id_saved_tmp]=max(sum(linked_mat_tmp));
idx_saved_tmp=zeros(size(idx_linked_tmp));
idx_saved_tmp(id_saved_tmp(1))=1;
idx_saved_cross(~idx_considered)=idx_saved_tmp;
% update
idx_considered(~idx_considered)=idx_linked_tmp;
gds_mat_tmp=gds_mat_tmp(~idx_linked_tmp,~idx_linked_tmp);
end
idx_saved=idx_cross_point;
idx_saved(idx_cross_point)=idx_saved_cross;
end

function [gds_matrix]=shortest_path_length(link_matrix,maximum_gd,initial_matrix)
if nargin<3||isempty(initial_matrix)
    initial_matrix=eye(size(link_matrix,1));
if nargin<2
    maximum_gd=size(link_matrix,1)-1;
else
    maximum_gd=min(maximum_gd,size(link_matrix,1)-1);
end
link_matrix=double(link_matrix);
gds_matrix=link_matrix;
gd_numb=max(max(initial_matrix))-1;
tmp=initial_matrix;
while gd_numb<maximum_gd&&any(any(~tmp))
    gds_matrix(gds_matrix==0)=inf;
    temp=(tmp*link_matrix+tmp)>0;
    if all(all(temp==tmp))
        break;
    else
        tmp=temp;
    end
    gd_numb=gd_numb+1;
    gds_matrix=min(cat(3,gds_matrix,(tmp).*gd_numb),[],3); 
end
gds_matrix(logical(eye(size(link_matrix,1))))=0;
end
end

function [idx_branch,gd_branch]=branch_search(gds_matrix,id_end_points,id_cross_points,gd_numbs)
% id_end_points=id_end_cross_points(:,1);
% id_cross_points=id_end_cross_points(:,2);
%gd_numbs=gds_matrix(id_end_points+(id_cross_points-1)*size(gds_matrix,1));
gds_matrix_tmp=gds_matrix(id_end_points,:)+gds_matrix(id_cross_points,:);
idx_branch=((gds_matrix_tmp-gd_numbs(:,ones(size(gds_matrix_tmp,1),1)))==0);
gd_branch=gds_matrix(id_cross_points,:);
gd_branch(~idx_branch)=0;
end

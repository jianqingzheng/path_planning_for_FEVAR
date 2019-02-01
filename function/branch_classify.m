%   Classify and match each pair of branches and trunks
%   Revision: 1.0
%   Date: 2019/2/1
%==========================================================================
%   $ Copyright (c) 2019, Jian-Qing Zheng
%   $ This code is under Apache License, Version 2.0, January 2004
%   $ http://www.apache.org/licenses/LICENSE-2.0.
%   For any academic publication using this code, please kindly cite:
%     J. Q. Zheng, X. Y. Zhou, C. Riga and G. Z. Yang, "3D Path Planning
%     from a Single 2D Fluoroscopic Image for Robot Assisted Fenestrated
%     Endovascular Aortic Repair", IEEE International Conference on
%     Robotics and Automation (ICRA), 2019.
%==========================================================================
%   Description:
%   'branch_classify' returns the sorted index and geodesic distance for
%   each branch/trunk node for branch/trunk matching.
%
%   [id_cross,gd_branch_out,gd_trunk_out] = branch_classify(points,
%   gd_branch_in,id_end_cross,gd_trunk_in,id_start_final)
%   'id_cross'      - the sorted indices of junction/cross nodes in 'points'
%   'gd_branch_out'	- the sorted arrays of geodesic distance for each
%                   branch node
%   'gd_trunk_out'	- the sorted arrays of geodesic distance for each
%                   trunk node
%   'points'        - the coordinates for each skeleton node in 2D/3D
%   'gd_branch_in'  - the unsorted arrays of geodesic distance for each
%                   branch node
%   'id_end_cross'  - the indices of the end node and the junction/cross 
%                   node corresponding to each unsorted branch
%   'gd_trunk_in'   - the unsorted arrays of geodesic distance for each
%                   trunk node
%   'id_start_final'- the indices of the two terminal junction/cross node
%                   corresponding to each unsorted trunk
%--------------------------------------------------------------------------
%   See also: ''.
function [id_cross,gd_branch_out,gd_trunk_out]=branch_classify(points,gd_branch_in,id_end_cross,gd_trunk_in,id_start_final)
%== id cross
id_cross=unique(id_start_final);
P_cross=points(:,id_cross)';
% P_cross_dist=pdist2(P_cross',P_cross','euclidean');
[~,id_id_cross]=sort(sum(pdist2(P_cross,P_cross,'euclidean')));
id_cross=id_cross(id_id_cross);
% P_cross=points(:,id_cross);

%== id cross to branch
[~,id_cross2branch]=ismember(id_end_cross(:,2),id_cross);
% branch points
% tmp=(max(step_branch,[],2)-2);
% [id_tangent_branch,~]=find((step_branch==tmp(:,ones(1,size(step_branch,2))))');

[id_tangent_branch,~]=find((gd_branch_in==1)');%%
P_tangent1_branch=points(:,id_tangent_branch);
[id_tangent_branch,~]=find((gd_branch_in==11)');%%
P_tangent2_branch=points(:,id_tangent_branch);
%== tangent vec
vec_tangent_branch=P_tangent1_branch-P_tangent2_branch;%P_cross(:,(id_cross2branch));
vec_tangent_angdist=acos((vec_tangent_branch'*vec_tangent_branch)./((sum(vec_tangent_branch.^2).^0.5)'*sum(vec_tangent_branch.^2).^0.5));
%== id branch
id_branch=zeros(1,5);
id_branch(1)=find(id_cross2branch==1);
[~,id_id_tmp]=min(vec_tangent_angdist(id_cross2branch==2,id_cross2branch==1));
id_tmp=find(id_cross2branch==2);
id_branch(2)=id_tmp(id_id_tmp);
id_branch(3)=id_tmp(3-id_id_tmp);
[~,id_id_tmp]=max(vec_tangent_angdist(id_cross2branch==3,id_cross2branch==1));
id_tmp=find(id_cross2branch==3);
id_branch(4)=id_tmp(id_id_tmp);
id_branch(5)=id_tmp(3-id_id_tmp);
gd_branch_out=gd_branch_in(id_branch,:);
id_end_cross=id_end_cross(id_branch,:);
% vec_tangent_branch=vec_tangent_branch(:,id_branch);

%== id cross to trunk
[~,id_cross2start_final_pre]=ismember(id_start_final,id_cross);
% [~,id_cross2start]=ismember(id_start_final(:,1),id_cross);
id_cross2start_final=[1,2;2,3;3,1];
[gd_trunk_out]=get_steps_trunk(gd_trunk_in,id_cross2start_final,id_cross2start_final_pre);

end

function [step_trunk_out]=get_steps_trunk(step_trunk_in,id_cross2start_final,id_cross2start_final_pre)
step_trunk_out=zeros(size(id_cross2start_final,1),size(step_trunk_in,2));
[steps,id_max]=max(step_trunk_in,[],2);
step_trunk_in([1:size(step_trunk_in,1)]'+(id_max-1).*size(step_trunk_in,1))=0;
% forward
[idx_found1,id_location]=ismember(id_cross2start_final,id_cross2start_final_pre,'rows');
id_location(~idx_found1)=[];
step_trunk_out(idx_found1,:)=step_trunk_in(id_location,:);
% backward
[idx_found2,id_location]=ismember(id_cross2start_final,id_cross2start_final_pre(:,end:-1:1),'rows');
id_location(~idx_found2)=[];
step_trunk_in(step_trunk_in==0)=inf;
tmp=steps(id_location,ones(1,size(step_trunk_in,2)))-step_trunk_in(id_location,:);
tmp(tmp<0)=0;

step_trunk_out(idx_found2,:)=tmp;
idx_found=(idx_found1|idx_found2);
id_found=find(idx_found);
% the third case
check=sum(all(step_trunk_out(idx_found,:)>0));% 0 for add, 1 for subtraction
% [idx_connect,id_order]=ismember();
if id_cross2start_final(id_found(1),2)==id_cross2start_final(id_found(2),1)
    sp=id_found(1);
    ep=id_found(2);
else
    sp=id_found(2);
    ep=id_found(1);
end
max_1=max(step_trunk_out(sp,:));
max_2=max(step_trunk_out(ep,:));
if check
    
    if max_1>max_2
        tmp=reverse_steps(step_trunk_out(sp,:));
        tmp(tmp>=max_1-max_2)=0;
    else
        tmp=step_trunk_out(ep,:);
        tmp(tmp>=max_2-max_1)=0;
        tmp=reverse_steps(tmp);
    end
else
    tmp=step_trunk_out(sp,:);
    tmp(tmp>0)=tmp(tmp>0)+max_2+1;
    tmp=reverse_steps(tmp+step_trunk_out(ep,:));
end
step_trunk_out(~idx_found,:)=tmp;
end

function [step_matrix]=reverse_steps(step_matrix)
[steps,~]=max(step_matrix,[],2);
step_matrix(step_matrix==0)=inf;
step_matrix=steps(:,ones(1,size(step_matrix,2)))+1-step_matrix(:,:);
step_matrix(step_matrix<0)=0;
end
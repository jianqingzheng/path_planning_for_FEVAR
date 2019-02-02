%   deformable registration between 2D skeleton and 3D skeleton
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
%   'regist2D3D' returns the deforming displacement of each 3D skeleton
%   points, the deleted points'indices, the inline indices, correspondence
%   between 2D and 3D inline skeleton points, and the time consumption.
%
%   [uopt,idx_del,idx_inline_3D,match_matrix,time_cost] = regist2D3D(
%   points2D,points3D,R_rigid,T_rigid,branch_numb)
%   'uopt'          - the displacement of each 3D skeleton points
%   'idx_del'       - the indices of those branch nodes without physical
%                   meaning
%   'idx_inline_3D'	- the indices of assigned inline 3D skeleton nodes
%   'match_matrix'  - the soft-assigning matrix between 2D and 3D nodes
%   'time_cost'     - the time consumption for intra-operative computation
%   'points2D'      - the 2D skeleton points' coordinates (2D x node num)
%   'points3D'      - the 3D skeleton points' coordinates (3D x node num)
%   'R_rigid'       - the rotation matrix for rigid transformation (3x3)
%   'T_rigid'       - the translation vector for rigid transformation (3x1)
%   'branch_numb'   - the number of the longest branch to preserve
%--------------------------------------------------------------------------
%   See also: 'node_classification', 'branch_classify',
%   'branch_node_assign', 'trunk_node_assign', 'regist_energy', 
%   'project3D22D'.
function [uopt,idx_del,idx_inline_3D,match_matrix,time_cost]=regist2D3D(points2D,points3D,R_rigid,T_rigid,branch_numb)
if nargin<5
    branch_numb=5;
    if nargin<4
        R_rigid=[0,0,-1;1,0,0;0,-1,0];%angvec2r(0.0,[0;1;0])*angvec2r(0.05,[0;0;1])*R0%%
        if nargin<3
            T_rigid=[0;0;1];
        end
    end
end
img_size=512;
LP='chebychev';%L-inf
link_thresh=1;
%% Pre-processing: node classification and branch matching in 3D
link_matrix=pdist2(points3D',points3D',LP)==link_thresh;
[gd_save_3D,id_end_cross_save_3D,idx_del_3D,~,gd_trunk3D,id_start_final3D]=node_classification(link_matrix,branch_numb);
[points3D_proj,points3D_rigid]=project3D22D(points3D,R_rigid,T_rigid,img_size);%R_rigid*points3D;
% time
time1=clock;
%--------------------------------------------------------------------------
%% Correspondence
%== node classification
link_matrix2=pdist2(points2D',points2D',LP)==link_thresh;
[gd_save_2D,id_end_cross_save_2D,~,~,gd_trunk2D,id_start_final2D]=node_classification(link_matrix2,branch_numb);
%== branch and trunk matching
[id_cross_3D,gd_branch_3D,gd_trunk_3D]=branch_classify(points3D,gd_save_3D,id_end_cross_save_3D,gd_trunk3D,id_start_final3D);
[id_cross_2D,gd_branch_2D,gd_trunk_2D]=branch_classify(points2D,gd_save_2D,id_end_cross_save_2D,gd_trunk2D,id_start_final2D);

%% branch&trunk node assigning
%== branches assigning
[match_matrix]=branch_node_assign(points2D,points3D_proj,id_cross_2D,id_cross_3D,gd_branch_2D,gd_branch_3D);
%== trunk assigning
[match_matrix]=trunk_node_assign(points2D,points3D_rigid,id_cross_2D,id_cross_3D,gd_trunk_2D,gd_trunk_3D,match_matrix);
%== cross points matching
% match_matrix(id_cross_2D+(id_cross_3D-1).*size(match_matrix,1))=1;
%== find the unassigned nodes
idx_inline_2D=any(match_matrix>0,2);
idx_inline_3D=any(match_matrix>0);
tmp=match_matrix(idx_inline_2D,idx_inline_3D);
match_matrix(idx_inline_2D,idx_inline_3D)=tmp./repmat(sum(tmp),size(tmp,1),1);
%% skeleton deformation
R=eye(3);
T=[0;0;0];
proj=[R,T];
p=points2D(:,idx_inline_2D)*match_matrix(idx_inline_2D,idx_inline_3D);
P=points3D_rigid(:,idx_inline_3D);
Link=link_matrix(idx_inline_3D,idx_inline_3D)>0;
L0=pdist2(P',P','euclidean').*Link;
J=get_j(proj);
%== optimization
uopt=zeros(size(points3D_rigid));
utmp=uopt(:,idx_inline_3D);
u0=get_u0(p,P,img_size,R,T);
u0=reshape(u0,numel(utmp),1);
func=@(u)(regist_energy(u,p,P,proj,Link,L0,J,1));
%-- start optimization
%-- LBFGS
%     ftol=1e0;
%     maxIter=10;
%     memsize = 10;
%     utmp=optLBFGS(func,u0,maxIter,memsize,ftol);
%-- minuncon
options = optimoptions('fminunc','GradObj','on','MaxIter',300,'Algorithm','quasi-newton');%'Display','iter');
utmp =fminunc(func,u0,options);
%-- mincon
% options = optimoptions('fmincon','GradObj','on','MaxIter',300,'Algorithm','interior-point');%'Display','iter');
% utmp = fmincon(func,u0,[],[],[],[],[],[],[],options);
%=====
% func(utmp)
utmp=reshape(utmp,3,numel(utmp)/3);

%% Post-processing: thin plate spline
% skeleton
% branches
uopt(:,idx_inline_3D)=utmp;
for i=1:size(gd_save_3D,1)
    % idx_branch_2D=gd_save_2D(i,:)>0;
    idx_branch_3D=gd_save_3D(i,:)>0;
    Ptps=TPS3D(P(:,idx_branch_3D(idx_inline_3D))',P(:,idx_branch_3D(idx_inline_3D))'+utmp(:,idx_branch_3D(idx_inline_3D))',points3D_rigid(:,idx_branch_3D&~idx_inline_3D)')';
    uopt(:,idx_branch_3D&~idx_inline_3D)=Ptps-points3D_rigid(:,idx_branch_3D&~idx_inline_3D);
end
for i=1:size(gd_trunk_3D,1)
    % idx_trunk_2D=gd_trunk_2D(i,:)>0;
    idx_trunk_3D=gd_trunk_3D(i,:)>0;
    Ptps=TPS3D(P(:,idx_trunk_3D(idx_inline_3D))',P(:,idx_trunk_3D(idx_inline_3D))'+utmp(:,idx_trunk_3D(idx_inline_3D))',points3D_rigid(:,idx_trunk_3D&~idx_inline_3D)')';
    uopt(:,idx_trunk_3D&~idx_inline_3D)=Ptps-points3D_rigid(:,idx_trunk_3D&~idx_inline_3D);
end
%-- delete branch
idx_del=any(idx_del_3D);
uopt=uopt(:,~idx_del);
%--------------------------------------------------------------------------
time2=clock;
time_cost=etime(time2,time1);
disp(['Time cosumption for skeleton registration: ',num2str(time_cost),'sec']);
end
%==========================================================================
% subfunction
%==========================================================================
function u0=get_u0(p,P,img_size,R,T)
Pp=project3D22D(P,R,T,img_size);
u0=[(p-Pp).*(P([3,3],:)./img_size-0.5);zeros(1,size(p,2))];
end
function J=get_j(proj)
J=reshape(proj(1:2,1:3),6,1)*proj(3,:)-kron(proj(3,1:3)',proj(1:2,:));
end
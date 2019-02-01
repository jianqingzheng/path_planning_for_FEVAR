%   calculate Lp-norm distance matrix between two points sets
%   Revision: 1.0
%   Date: 2018/6/21
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
%   'points_dist' calculate the Hamming, Minkowski(Manhaton/Euclidean/...
%   /Chebyshev) distance matrix or directly additional signed distance 
%   between two points set.
% 
%   [points_dist] = points_dist(pointsA,pointsB,LP)
%   'points_dist'   - the Lp-norm distances of the two points set
%   'pointsA'       - the first points set
%   'pointsB'       - the second points set
%   'LP'            - the coefficient of Lp-norm: 0 for Hamming, 1 for 
%                   Mantaton, 2 for Euclidean... inf for Chebyshev, -1 for
%                   the directly addition of signed distances.
%--------------------------------------------------------------------------
%   See also: 'pdist2'.
function [points_dist]=points_dist(pointsA,pointsB,LP)
[dim_num,points1_num]=size(pointsA);
[~,points2_num]=size(pointsB);
P1=2.^(pointsA);
P2=2.^(-1.*pointsB);
if nargin==3&&~isempty(LP)
    points_dist=zeros(points1_num,points2_num);
    if LP==0
        for i=1:dim_num
            tmp=(log2(P1(i,:)'*(P2(i,:))));
            points_dist=points_dist+(tmp~=0);
        end    
    elseif LP==1
        for i=1:dim_num
            tmp=(log2(P1(i,:)'*(P2(i,:))));
            points_dist=points_dist+abs(tmp);
        end
    elseif LP==-1
        for i=1:dim_num
            tmp=(log2(P1(i,:)'*(P2(i,:))));
            points_dist=points_dist+(tmp);
        end
    elseif LP==inf
        for i=1:dim_num
            tmp=(log2(P1(i,:)'*(P2(i,:))));
            points_dist=max(cat(3,points_dist,abs(tmp)),[],3);
        end
    else
        for i=1:dim_num
            tmp=(log2(P1(i,:)'*(P2(i,:))));
            points_dist=points_dist+tmp.^LP;
        end
        points_dist=points_dist.^(1/LP);
    end
else
    points_dist=zeros(points1_num,points2_num,dim_num);
    for i=1:dim_num
        points_dist(:,:,i)=(log2(P1(i,:)'*(P2(i,:))));
    end
end

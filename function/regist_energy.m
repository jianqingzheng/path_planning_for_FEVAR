%   energy loss function for the deformable registration
%   Revision: 1.0
%   Date: 2018/6/21
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
%   'regist_energy' calculate the energy loss function and the gradients
%   including three terms: projection distance term, length preserving
%   term, and smoothness constraint term.
% 
%   [energy,gradient] = regist_energy(u,p,P,Proj,Link,L0,J,beta)
%   'points_dist'   - the Lp-norm distances of the two points set
%   'pointsA'       - the first points set
%   'pointsB'       - the second points set
%   'LP'            - the coefficient of Lp-norm: 0 for Hamming, 1 for 
%                   Mantaton, 2 for Euclidean... inf for Chebyshev, -1 for
%                   the directly addition of signed distances.
%--------------------------------------------------------------------------
%   Reference:
%   [1] M. Groher, D. Zikic, and N. Navab, "Deformable 2d-3d registration 
%       of vascular structures in a one view scenario," IEEE Transactions 
%       on Medical Imaging, vol. 28, no. 6, pp. 847¨C860, 2009.
%   [2] R. Liao, Y. Tan, H. Sundar, M. Pfister, and A. Kamen, "An efficient
%       graph-based deformable 2d/3d registration algorithm with 
%       applications for abdominal aortic aneurysm interventions," in
%       International Workshop on Medical Imaging and Virtual Reality.
%       Springer, 2010, pp. 561¨C570.
%--------------------------------------------------------------------------
%   See also: ''.
function [energy,gradient]=regist_energy(u,p,P,Proj,Link,L0,J,beta)
if size(u,2)<=1;
    u=reshape(u,3,numel(u)/3);
end
[dist_energy,dist_gradient]=distance_energy(u,p,P,Proj,J);
[len_energy,len_gradient]=length_energy(P+u,L0,Link);
[smoo_energy,smoo_gradient]=smooth_energy(u,Link);
energy=dist_energy+beta*500*len_energy+beta*0.1*smoo_energy;
gradient=dist_gradient+beta*500*len_gradient+beta*0.1*smoo_gradient;
gradient=reshape(gradient,numel(gradient),1);
end

function [dist_energy,gradient]=distance_energy(u,p,P,Proj,J)
    Pn=[(P+u);ones(1,size(P,2))];
R=Proj(:,1:3);
T=Proj(:,4);
    PP=(project3D22D(P+u,R,T,512));
    dist_energy=mean(sum((p-PP).^2));
    D=(PP-p);
    G=J*Pn.*D([1,2,1,2,1,2],:);
    coef=(Proj(3,:)*Pn).^2;
    gradient=[sum(G([1,2],:),1);sum(G([3,4],:),1);sum(G([5,6],:),1)].*2./size(p,2)./(coef([1,1,1],:));
end
function [smoo_energy,gradient]=smooth_energy(u,Link)
    U=2.^(u);
    tmp1=(log2(U(1,:)'*(U(1,:).^-1)));
    tmp1(isnan(tmp1)|isinf(tmp1))=0;
    tmp2=(log2(U(2,:)'*(U(2,:).^-1)));
    tmp2(isnan(tmp2)|isinf(tmp2))=0;
    tmp3=(log2(U(3,:)'*(U(3,:).^-1)));
    tmp3(isnan(tmp3)|isinf(tmp3))=0;
    S=(tmp1.^2+tmp2.^2+tmp3.^2).*Link;
    smoo_energy=sum(sum(S))/sum(sum(Link));
    gradient=[sum(tmp1.*Link);sum(tmp2.*Link);sum(tmp3.*Link)].*2./sum(sum(Link));
end
function [len_energy,gradient]=length_energy(P,L0,Link)
    P0=2.^(P);
    P1=2.^(-P);
    tmp11=(log2(P0(1,:)'*(P1(1,:))));
    tmp12=(log2(P0(2,:)'*(P1(2,:))));
    tmp13=(log2(P0(3,:)'*(P1(3,:))));
    L1=((tmp11.^2+tmp12.^2+tmp13.^2).*Link).^0.5;
    L=((L1-L0)./L0).^2;
    L(isnan(L)|(L0==0))=0;
    len_energy=sum(sum(L))/sum(sum(Link));
    G=(L1-L0)./(L0.^2.*L1);%+10^-7
    G(isnan(G)|(L0==0)|(L1==0))=0;
    gradient=[sum(G.*tmp11);sum(G.*tmp12);sum(G.*tmp13)].*2./(sum(sum(Link)));%+10^-7
end

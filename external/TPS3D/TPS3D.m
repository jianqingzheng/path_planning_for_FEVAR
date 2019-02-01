% Copyright (c) 2012, Yang Yang
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%======================================================
% 3D Thin Plate Spline by Yang Yang (05.05.2012)
%   For any academic publication using this code, please kindly cite:
%       Y. Yang, "3d thin plate spline warping function," https://ww2.
%       mathworks.cn/matlabcentral/fileexchange/37576-3d-thin-plate-spline
%       -warping-function.
%======================================================
function [wobject] = TPS3D(points, ctrlpoints,object)

%======================================================
% Calculate Parameters 
%======================================================
npnts = size(points,1);
K = zeros(npnts, npnts);
for rr = 1:npnts
    for cc = 1:npnts
        K(rr,cc) = sum( (points(rr,:) - points(cc,:)).^2 ); %R^2 
        K(cc,rr) = K(rr,cc);
    end;
end;
%calculate kernel function R
K = max(K,1e-320); 
%K = K.* log(sqrt(K));
K = sqrt(K); %
% Calculate P matrix
P = [ones(npnts,1), points]; %nX4 for 3D
% Calculate L matrix
L = [ [K, P];[P', zeros(4,4)] ]; %zeros(4,4) for 3D
param = pinv(L) * [ctrlpoints; zeros(4,3)]; %zeros(4,3) for 3D

%======================================================
% Calculate new coordinates (x',y',z') for each points 
%====================================================== 
pntsNum=size(object,1); 
K = zeros(pntsNum, npnts);
gx=object(:,1);
gy=object(:,2);
gz=object(:,3);
for nn = 1:npnts
    K(:,nn) = (gx - points(nn,1)).^2 + (gy - points(nn,2) ).^2 + (gz - points(nn,3) ).^2; % R^2
end;
K = max(K,1e-320); 
K = sqrt(K); %|R| for 3D

P = [ones(pntsNum,1), gx, gy, gz];
L = [K, P];
wobject = L * param;  
wobject(:,1)=round(wobject(:,1)*10^3)*10^-3;
wobject(:,2)=round(wobject(:,2)*10^3)*10^-3;
wobject(:,3)=round(wobject(:,3)*10^3)*10^-3;
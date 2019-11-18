%   Convert array to string
%   Revision: 2.0   
%   Date: 2017/06/21
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
%   array2str(array,inser,numlength) returns the string including a given
%   digits of numbers divided by a given symbol.
%--------------------------------------------------------------------------
%   [str] = array2str(array,inser,numlength)
%   'str'       - the output string
%   'array'     - the input array (vector/matrix)
%   'inser'     - the input inserted seperator symbol
%   'numlength'	- the digit number of each printed eletment of 'array'
%--------------------------------------------------------------------------
%   Examples:
%      % Find the subarray seqA v.s. seqB:
%      >> array = [4,5,2];
%      >> inser = '_';
%      >> numlength = 2;
%      >> array2str(array,inser,numlength)
%
%      ans = 
%               '04_05_02'
%--------------------------------------------------------------------------

%   See also: .
function [str]=array2str(array,inser,numlength)
%% parameter transfer
if nargin<3
    numlength=2;
    if nargin<2
        inser='';
    end
end
%%
str='';
for i=array
    if i==array(1)
        str=[str,sprintf(['%',sprintf('%02d',numlength),'d'],i)];
    else
        str=[str,inser,sprintf(['%',sprintf('%02d',numlength),'d'],i)];
    end
end
end

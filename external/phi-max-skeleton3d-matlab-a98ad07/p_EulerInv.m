%==========================================================================
% Copyright (c) 2016, Philip Kollmannsberger
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
% 
%   For any academic publication using this code, please kindly cite:
%       Kerschnitzki, Kollmannsberger et al., "Architecture of the 
%       osteocyte network correlates with bone material quality." Journal 
%       of Bone and Mineral Research, 28(8):1837-1845, 2013.
%==========================================================================
function EulerInv =  p_EulerInv(img,LUT)
if numel(LUT) > 255
    error('skeleton3D:p_EulerInv:LUTwithTooManyElems', 'LUT with 255 elements expected');
end
% Calculate Euler characteristic for each octant and sum up
eulerChar = zeros(size(img,1),1, 'like', LUT);
% Octant SWU
bitorTable = uint8([128; 64; 32; 16; 8; 4; 2]);
n = ones(size(img,1),1, 'uint8');
n(img(:,25)==1) = bitor(n(img(:,25)==1), bitorTable(1));
n(img(:,26)==1) = bitor(n(img(:,26)==1), bitorTable(2));
n(img(:,16)==1) = bitor(n(img(:,16)==1), bitorTable(3));
n(img(:,17)==1) = bitor(n(img(:,17)==1), bitorTable(4));
n(img(:,22)==1) = bitor(n(img(:,22)==1), bitorTable(5));
n(img(:,23)==1) = bitor(n(img(:,23)==1), bitorTable(6));
n(img(:,13)==1) = bitor(n(img(:,13)==1), bitorTable(7));
eulerChar = eulerChar + LUT(n);
% Octant SEU
n = ones(size(img,1),1, 'uint8'); 
n(img(:,27)==1) = bitor(n(img(:,27)==1), bitorTable(1));
n(img(:,24)==1) = bitor(n(img(:,24)==1), bitorTable(2));
n(img(:,18)==1) = bitor(n(img(:,18)==1), bitorTable(3));
n(img(:,15)==1) = bitor(n(img(:,15)==1), bitorTable(4));
n(img(:,26)==1) = bitor(n(img(:,26)==1), bitorTable(5));
n(img(:,23)==1) = bitor(n(img(:,23)==1), bitorTable(6));
n(img(:,17)==1) = bitor(n(img(:,17)==1), bitorTable(7));
eulerChar = eulerChar + LUT(n);
% Octant NWU
n = ones(size(img,1),1, 'uint8'); 
n(img(:,19)==1) = bitor(n(img(:,19)==1), bitorTable(1));
n(img(:,22)==1) = bitor(n(img(:,22)==1), bitorTable(2));
n(img(:,10)==1) = bitor(n(img(:,10)==1), bitorTable(3));
n(img(:,13)==1) = bitor(n(img(:,13)==1), bitorTable(4));
n(img(:,20)==1) = bitor(n(img(:,20)==1), bitorTable(5));
n(img(:,23)==1) = bitor(n(img(:,23)==1), bitorTable(6));
n(img(:,11)==1) = bitor(n(img(:,11)==1), bitorTable(7));
eulerChar = eulerChar + LUT(n);
% Octant NEU
n = ones(size(img,1),1, 'uint8'); 
n(img(:,21)==1) = bitor(n(img(:,21)==1), bitorTable(1));
n(img(:,24)==1) = bitor(n(img(:,24)==1), bitorTable(2));
n(img(:,20)==1) = bitor(n(img(:,20)==1), bitorTable(3));
n(img(:,23)==1) = bitor(n(img(:,23)==1), bitorTable(4));
n(img(:,12)==1) = bitor(n(img(:,12)==1), bitorTable(5));
n(img(:,15)==1) = bitor(n(img(:,15)==1), bitorTable(6));
n(img(:,11)==1) = bitor(n(img(:,11)==1), bitorTable(7));
eulerChar = eulerChar + LUT(n);
% Octant SWB
n = ones(size(img,1),1, 'uint8'); 
n(img(:, 7)==1) = bitor(n(img(:, 7)==1), bitorTable(1));
n(img(:,16)==1) = bitor(n(img(:,16)==1), bitorTable(2));
n(img(:, 8)==1) = bitor(n(img(:, 8)==1), bitorTable(3));
n(img(:,17)==1) = bitor(n(img(:,17)==1), bitorTable(4));
n(img(:, 4)==1) = bitor(n(img(:, 4)==1), bitorTable(5));
n(img(:,13)==1) = bitor(n(img(:,13)==1), bitorTable(6));
n(img(:, 5)==1) = bitor(n(img(:, 5)==1), bitorTable(7));
eulerChar = eulerChar + LUT(n);
% Octant SEB
n = ones(size(img,1),1, 'uint8'); 
n(img(:, 9)==1) = bitor(n(img(:, 9)==1), bitorTable(1));
n(img(:, 8)==1) = bitor(n(img(:, 8)==1), bitorTable(2));
n(img(:,18)==1) = bitor(n(img(:,18)==1), bitorTable(3));
n(img(:,17)==1) = bitor(n(img(:,17)==1), bitorTable(4));
n(img(:, 6)==1) = bitor(n(img(:, 6)==1), bitorTable(5));
n(img(:, 5)==1) = bitor(n(img(:, 5)==1), bitorTable(6));
n(img(:,15)==1) = bitor(n(img(:,15)==1), bitorTable(7));
eulerChar = eulerChar + LUT(n);
% Octant NWB
n = ones(size(img,1),1, 'uint8'); 
n(img(:, 1)==1) = bitor(n(img(:, 1)==1), bitorTable(1));
n(img(:,10)==1) = bitor(n(img(:,10)==1), bitorTable(2));
n(img(:, 4)==1) = bitor(n(img(:, 4)==1), bitorTable(3));
n(img(:,13)==1) = bitor(n(img(:,13)==1), bitorTable(4));
n(img(:, 2)==1) = bitor(n(img(:, 2)==1), bitorTable(5));
n(img(:,11)==1) = bitor(n(img(:,11)==1), bitorTable(6));
n(img(:, 5)==1) = bitor(n(img(:, 5)==1), bitorTable(7));
eulerChar = eulerChar + LUT(n);
% Octant NEB
n = ones(size(img,1),1, 'uint8'); 
n(img(:, 3)==1) = bitor(n(img(:, 3)==1), bitorTable(1));
n(img(:, 2)==1) = bitor(n(img(:, 2)==1), bitorTable(2));
n(img(:,12)==1) = bitor(n(img(:,12)==1), bitorTable(3));
n(img(:,11)==1) = bitor(n(img(:,11)==1), bitorTable(4));
n(img(:, 6)==1) = bitor(n(img(:, 6)==1), bitorTable(5));
n(img(:, 5)==1) = bitor(n(img(:, 5)==1), bitorTable(6));
n(img(:,15)==1) = bitor(n(img(:,15)==1), bitorTable(7));
eulerChar = eulerChar + LUT(n);

EulerInv = false(size(eulerChar), 'like', img);
EulerInv(eulerChar==0) = true;

end

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
function is_simple = p_is_simple(N)

% copy neighbors for labeling
n_p = size(N,1);
is_simple = true(n_p, 1, 'like', N);

cube = zeros(n_p, 26, 'uint8');
cube(:, 1:13)=N(:, 1:13);
cube(:, 14:26)=N(:,15:27);

label = 2*ones(n_p, 1, 'uint8');

% for all points in the neighborhood
for i=1:26
    
    idx = cube(:,i) == 1 & is_simple;
    
    if any(idx)
        
        % start recursion with any octant that contains the point i
        switch( i )
            
            case {1,2,4,5,10,11,13}
                cube(idx,:) = p_oct_label(1, label, cube(idx,:) );
            case {3,6,12,14}
                cube(idx,:) = p_oct_label(2, label, cube(idx,:) );
            case {7,8,15,16}
                cube(idx,:) = p_oct_label(3, label, cube(idx,:) );
            case {9,17}
                cube(idx,:) = p_oct_label(4, label, cube(idx,:) );
            case {18,19,21,22}
                cube(idx,:) = p_oct_label(5, label, cube(idx,:) );
            case {20,23}
                cube(idx,:) = p_oct_label(6, label, cube(idx,:) );
            case {24,25}
                cube(idx,:) = p_oct_label(7, label, cube(idx,:) );
            case 26
                cube(idx,:) = p_oct_label(8, label, cube(idx,:) );
        end

        label(idx) = label(idx)+1;
        del_idx = label>=4;
        
        if any(del_idx)
            is_simple(del_idx) = false;
        end
    end
end
end

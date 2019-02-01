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
function cube = p_oct_label(octant, label, cube)

% check if there are points in the octant with value 1
if( octant==1 )
    
    % set points in this octant to current label
    % and recurseive labeling of adjacent octants
    idx = cube(:,1) == 1;
    if any(idx)
        cube(idx,1) = label(idx);
    end
    
    idx = cube(:,2) == 1;
    if any(idx)
        cube(idx,2) = label(idx);
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
    end
    
    idx = cube(:,4) == 1;
    if any(idx)
        cube(idx,4) = label(idx);
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
    end
    
    idx = cube(:,5) == 1;
    if any(idx)
        cube(idx,5) = label(idx);
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
    end
    
    idx = cube(:,10) == 1;
    if any(idx)
        cube(idx,10) = label(idx);
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
    end
    
    idx = cube(:,11) == 1;
    if any(idx)
        cube(idx,11) = label(idx);
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
    end
    
    idx = cube(:,13) == 1;
    if any(idx)
        cube(idx,13) = label(idx);
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
    end
    
end

if( octant==2 )
    
    idx = cube(:,2) == 1;
    if any(idx)
        cube(idx,2) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
    end

    idx = cube(:,5) == 1;
    if any(idx)
        cube(idx,5) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
    end

    idx = cube(:,11) == 1;
    if any(idx)
        cube(idx,11) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
    end

    idx = cube(:,3) == 1;
    if any(idx)
        cube(idx,3) = label(idx);
    end

    idx = cube(:,6) == 1;
    if any(idx)
        cube(idx,6) = label(idx);
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
    end
    
    idx = cube(:,12) == 1;
    if any(idx)
        cube(idx,12) = label(idx);
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
    end

    idx = cube(:,14) == 1;
    if any(idx)
        cube(idx,14) = label(idx);
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end

end

if( octant==3 )
    
    idx = cube(:,4) == 1;
    if any(idx)
        cube(idx,4) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
    end

    idx = cube(:,5) == 1;
    if any(idx)
        cube(idx,5) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
    end

    idx = cube(:,13) == 1;
    if any(idx)
        cube(idx,13) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
    end

    idx = cube(:,7) == 1;
    if any(idx)
        cube(idx,7) = label(idx);
    end

    idx = cube(:,8) == 1;
    if any(idx)
        cube(idx,8) = label(idx);
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
    end
    
    idx = cube(:,15) == 1;
    if any(idx)
        cube(idx,15) = label(idx);
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
    end

    idx = cube(:,16) == 1;
    if any(idx)
        cube(idx,16) = label(idx);
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end
    
end

if( octant==4 )
    
    idx = cube(:,5) == 1;
    if any(idx)
        cube(idx,5) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
    end

    idx = cube(:,6) == 1;
    if any(idx)
        cube(idx,6) = label(idx);
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
    end

    idx = cube(:,14) == 1;
    if any(idx)
        cube(idx,14) = label(idx);
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end
    
    idx = cube(:,8) == 1;
    if any(idx)
        cube(idx,8) = label(idx);
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
    end

    idx = cube(:,16) == 1;
    if any(idx)
        cube(idx,16) = label(idx);
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end

    idx = cube(:,9) == 1;
    if any(idx)
        cube(idx,9) = label(idx);
    end

    idx = cube(:,17) == 1;
    if any(idx)
        cube(idx,17) = label(idx);
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end

end

if( octant==5 )
    
    idx = cube(:,10) == 1;
    if any(idx)
        cube(idx,10) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
    end

    idx = cube(:,11) == 1;
    if any(idx)
        cube(idx,11) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
    end
    
    idx = cube(:,13) == 1;
    if any(idx)
        cube(idx,13) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
    end

    idx = cube(:,18) == 1;
    if any(idx)
        cube(idx,18) = label(idx);
    end

    idx = cube(:,19) == 1;
    if any(idx)
        cube(idx,19) = label(idx);
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
    end

    idx = cube(:,21) == 1;
    if any(idx)
        cube(idx,21) = label(idx);
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
    end

    idx = cube(:,22) == 1;
    if any(idx)
        cube(idx,22) = label(idx);
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end

end

if( octant==6 )
    
    idx = cube(:,11) == 1;
    if any(idx)
        cube(idx,11) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
    end

    idx = cube(:,12) == 1;
    if any(idx)
        cube(idx,12) = label(idx);
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
    end

    idx = cube(:,14) == 1;
    if any(idx)
        cube(idx,14) = label(idx);
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end
    
    idx = cube(:,19) == 1;
    if any(idx)
        cube(idx,19) = label(idx);
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
    end


    idx = cube(:,22) == 1;
    if any(idx)
        cube(idx,22) = label(idx);
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end
    
    idx = cube(:,20) == 1;
    if any(idx)
        cube(idx,20) = label(idx);
    end

    idx = cube(:,23) == 1;
    if any(idx)
        cube(idx,23) = label(idx);
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end
 
end

if( octant==7 )
    
    idx = cube(:,13) == 1;
    if any(idx)
        cube(idx,13) = label(idx);
        cube(idx,:) = p_oct_label(1,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
    end

    idx = cube(:,15) == 1;
    if any(idx)
        cube(idx,15) = label(idx);
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
    end

    idx = cube(:,16) == 1;
    if any(idx)
        cube(idx,16) = label(idx);
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end

    idx = cube(:,21) == 1;
    if any(idx)
        cube(idx,21) = label(idx);
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
    end

    idx = cube(:,22) == 1;
    if any(idx)
        cube(idx,22) = label(idx);
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end

    idx = cube(:,24) == 1;
    if any(idx)
        cube(idx,24) = label(idx);
    end
    
    idx = cube(:,25) == 1;
    if any(idx)
        cube(idx,25) = label(idx);
        cube(idx,:) = p_oct_label(8,label(idx),cube(idx,:));
    end
end

if( octant==8 )
    
    idx = cube(:,14) == 1;
    if any(idx)
        cube(idx,14) = label(idx);
        cube(idx,:) = p_oct_label(2,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
    end

    idx = cube(:,16) == 1;
    if any(idx)
        cube(idx,16) = label(idx);
        cube(idx,:) = p_oct_label(3,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
    end
    
    idx = cube(:,17) == 1;
    if any(idx)
        cube(idx,17) = label(idx);
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
    end
    
    idx = cube(:,22) == 1;
    if any(idx)
        cube(idx,22) = label(idx);
        cube(idx,:) = p_oct_label(5,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
    end
    
    idx = cube(:,17) == 1;
    if any(idx)
        cube(idx,17) = label(idx);
        cube(idx,:) = p_oct_label(4,label(idx),cube(idx,:));
    end
    
    idx = cube(:,23) == 1;
    if any(idx)
        cube(idx,23) = label(idx);
        cube(idx,:) = p_oct_label(6,label(idx),cube(idx,:));
    end
    
    idx = cube(:,25) == 1;
    if any(idx)
        cube(idx,25) = label(idx);
        cube(idx,:) = p_oct_label(7,label(idx),cube(idx,:));
    end
    
    idx = cube(:,26) == 1;
    if any(idx)
        cube(idx,26) = label(idx);
    end
end
end

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
function LUT = FillEulerLUT

LUT = zeros(255,1, 'int8');

LUT(1)  =  1;
LUT(3)  = -1;
LUT(5)  = -1;
LUT(7)  =  1;
LUT(9)  = -3;
LUT(11) = -1;
LUT(13) = -1;
LUT(15) =  1;
LUT(17) = -1;
LUT(19) =  1;
LUT(21) =  1;
LUT(23) = -1;
LUT(25) =  3;
LUT(27) =  1;
LUT(29) =  1;
LUT(31) = -1;
LUT(33) = -3;
LUT(35) = -1;
LUT(37) =  3;
LUT(39) =  1;
LUT(41) =  1;
LUT(43) = -1;
LUT(45) =  3;
LUT(47) =  1;
LUT(49) = -1;
LUT(51) =  1;

LUT(53) =  1;
LUT(55) = -1;
LUT(57) =  3;
LUT(59) =  1;
LUT(61) =  1;
LUT(63) = -1;
LUT(65) = -3;
LUT(67) =  3;
LUT(69) = -1;
LUT(71) =  1;
LUT(73) =  1;
LUT(75) =  3;
LUT(77) = -1;
LUT(79) =  1;
LUT(81) = -1;
LUT(83) =  1;
LUT(85) =  1;
LUT(87) = -1;
LUT(89) =  3;
LUT(91) =  1;
LUT(93) =  1;
LUT(95) = -1;
LUT(97) =  1;
LUT(99) =  3;
LUT(101) =  3;
LUT(103) =  1;

LUT(105) =  5;
LUT(107) =  3;
LUT(109) =  3;
LUT(111) =  1;
LUT(113) = -1;
LUT(115) =  1;
LUT(117) =  1;
LUT(119) = -1;
LUT(121) =  3;
LUT(123) =  1;
LUT(125) =  1;
LUT(127) = -1;
LUT(129) = -7;
LUT(131) = -1;
LUT(133) = -1;
LUT(135) =  1;
LUT(137) = -3;
LUT(139) = -1;
LUT(141) = -1;
LUT(143) =  1;
LUT(145) = -1;
LUT(147) =  1;
LUT(149) =  1;
LUT(151) = -1;
LUT(153) =  3;
LUT(155) =  1;

LUT(157) =  1;
LUT(159) = -1;
LUT(161) = -3;
LUT(163) = -1;
LUT(165) =  3;
LUT(167) =  1;
LUT(169) =  1;
LUT(171) = -1;
LUT(173) =  3;
LUT(175) =  1;
LUT(177) = -1;
LUT(179) =  1;
LUT(181) =  1;
LUT(183) = -1;
LUT(185) =  3;
LUT(187) =  1;
LUT(189) =  1;
LUT(191) = -1;
LUT(193) = -3;
LUT(195) =  3;
LUT(197) = -1;
LUT(199) =  1;
LUT(201) =  1;
LUT(203) =  3;
LUT(205) = -1;
LUT(207) =  1;

LUT(209) = -1;
LUT(211) =  1;
LUT(213) =  1;
LUT(215) = -1;
LUT(217) =  3;
LUT(219) =  1;
LUT(221) =  1;
LUT(223) = -1;
LUT(225) =  1;
LUT(227) =  3;
LUT(229) =  3;
LUT(231) =  1;
LUT(233) =  5;
LUT(235) =  3;
LUT(237) =  3;
LUT(239) =  1;
LUT(241) = -1;
LUT(243) =  1;
LUT(245) =  1;
LUT(247) = -1;
LUT(249) =  3;
LUT(251) =  1;
LUT(253) =  1;
LUT(255) = -1;
end

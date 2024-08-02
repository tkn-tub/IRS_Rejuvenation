function fOffset = dmgCFOEstimate(stf)
%dmgCFOEstimate DMG carrier frequency offset estimation
%
%   FOFFSET = dmgCFOEstimate(STF) estimates the carrier frequency
%   offset FOFFSET in Hertz using time-domain DMG-STF. Only the SC PHY is
%   supported.
%  
%   STF is a complex Ns-by-1 vector where Ns is the number of time domain
%   samples in the DMG-STF.

%   Copyright 2017 The MathWorks, Inc.

%#codegen

narginchk(1,1);
nargoutchk(0,1);

validateattributes(stf,{'double'}, {'2d','finite'}, mfilename, 'signal input');

L = 2176; % Length of the STF field
if size(stf, 1) < L 
    fOffset = [];
    return;
end

L = 128;     % Length of single repetition of Ga for SC PHY
Nreps = 7;   % Number of Ga repetitions to use for CFO estimation
fs = 1.76e9; % Single carrier PHY sample rate

% Use partial STF to estimate the CFO. As the estimated offset from packet
% detection can be earlier or later than the actual start.
fOffset = wlan.internal.cfoEstimate(stf((1+L):(Nreps*L)), L).*fs/L;

end
function [startOffset, chanEst] = dmgTimingAndChannelEstimate(preamble)
%dmgTimingAndChannelEstimate DMG single carrier symbol timing and channel estimation
%
%   [STARTOFFSET,CHANEST] = dmgTimingAndChannelEstimate(PREAMBLE) returns
%   the symbol timing offset, and the frequency domain channel estimate.
%   The symbol timing offset is selected to minimize the energy of the
%   channel impulse response out with the guard interval. Only the SC PHY
%   is supported.
% 
%   STARTOFFSET is the estimated offset between the first input sample of
%   PREAMBLE, and the start of the STF.
%
%   CHANEST is a complex column vector of length 512 containing the
%   frequency domain channel estimate for each symbol in a block.
%
%   PREAMBLE is a complex column vector containing the DMG-STF, DMG-CE and
%   DMG header field symbols.

%   Copyright 2017 The MathWorks, Inc.

%#codegen

narginchk(1,1);
nargoutchk(1,2);

[Ga128,Gb128] = wlanGolaySequence(128);
Gu = [-Gb128; -Ga128; Gb128; -Ga128];
Gv = [-Gb128; Ga128; -Gb128; -Ga128];
lengthCEField = 1152; % The length of CE field for DMG SC format
lengthGuGvField = numel(Gu) + numel(Gv);
Nblk = 512;

validateattributes(preamble, {'double'}, {'2d','finite'}, mfilename, 'signal input');

L = (2176 + lengthCEField); % Length of STF and CE field of DMG SC PHY
if size(preamble,1) < L 
    startOffset = [];
    chanEst = [];
    return;
end

% Correlate against Gu and GV for channel estimation
gucor = xcorr(preamble, dmgRotate(Gu));
gvcor = xcorr(preamble, dmgRotate(Gv));
h512 = gucor(1:end-512) + gvcor(1+512:end); % Gv is later so delayed

% Location of maximum impulse; use this as the basis to search around
[~,maxImpulseIdx] = max(h512);

% Measure power in search region around the maximum impulse 
seachStartOffset = 63;
searchWindow = size(Ga128,1); 
searchRegion = abs(h512(maxImpulseIdx - 1 + (-seachStartOffset + (0:searchWindow-1)))).^2; 

% Measure the energy in the guard period (64 samples) and find the max
Ngi = 64;
cirEnergy = filter(ones(Ngi,1), 1, searchRegion);
[~, maxCIREnergyIdx] = max(cirEnergy);
syncIdx = maxCIREnergyIdx;

% Index to start sync in the search region
startIdxSearchRegion = syncIdx-Ngi+1;
% Offset in samples from max impulse where we actually synchronize
offsetFromMaxImpulseIdx = startIdxSearchRegion - (seachStartOffset + 1) - 1;

% Determine the start offset of the packet within the waveform
startOffset = maxImpulseIdx + offsetFromMaxImpulseIdx - (numel(preamble) + lengthCEField + lengthGuGvField);

% Extract 128 sample CIR
cirEst = h512(maxImpulseIdx + offsetFromMaxImpulseIdx-1+(1:searchWindow))/lengthGuGvField;

% Convert channel estimate to frequency domain
chanEst = fftshift(fft([cirEst; zeros(Nblk-length(cirEst),1)], [], 1), 1);

end

function y = dmgRotate(x)
    y = bsxfun(@times, x, repmat(exp(1i*pi*(0:3).'/2), size(x,1)/4, 1));
end
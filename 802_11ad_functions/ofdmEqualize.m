function [eqSym, csi] = ofdmEqualize(rxSym,hEst,varargin)
%OFDMEQUALIZE OFDM Equalization
%
%   [EQSYM,CSI] = OFDMEQUALIZE(RXSYM,HEST,NVAR) returns equalized symbols
%   EQSYM and soft channel state information CSI by performing minimum mean
%   squared error equalization on an OFDM signal RXSYM using an estimated
%   channel information HEST and an estimated noise variance NVAR.
%
%   RXSYM is an Nsc-by-Nsym-by-Nr array of real or complex values, where
%
%       Nsc  = Number of OFDM subcarriers
%       Nsym = Number of OFDM symbols
%       Nr   = Number of receive antennas.
%
%   HEST is an Nsc-by-Ns-by-Nr array or an (Nsc*Nsym)-by-Ns-by-Nr array of
%   real or complex values, where
%
%       Ns   = Number of data streams.
%
%   NVAR is a nonnegative real scalar.
%
%   EQSYM is an Nsc-by-Nsym-by-Ns array of real or complex values.
%
%   CSI is a matrix where size(CSI,1) = size(HEST,1) and size(CSI,2) = Ns.
%
%   If size(HEST,1) is equal to Nsc, all OFDM symbols in RXSYM are equalized
%   by the same channel estimate. If size(HEST,1) is equal to Nsc*Nsym, each
%   OFDM symbol in RXSYM is equalized by the corresponding entry in HEST.
%
%   [EQSYM,CSI] = ofdmEqualize(RXSYM,HEST) performs minimum mean squared
%   error equalization with estimated noise variance equal to 0.
%
%   [EQSYM,CSI] = ofdmEqualize(RXSYM,HEST,...,Name,Value) specifies
%   additional name-value pair arguments described below:
%
%   "Algorithm"    One of the strings: "mmse", or "zf". "mmse" indicates
%                  that the minimum mean squared error algorithm should be
%                  used. "zf" indicates that the zero-forcing algorithm
%                  should be used and NVAR, if provided, should be ignored.
%                  The default value is "mmse".
%
%   "DataFormat"   One of the strings: "2-D", or "3-D". "3-D" indicates
%                  that RXSYM and EQSYM are as defined above, i.e. as an
%                  Nsc-by-Nsym-by-Nr array and an Nsc-by-Nsym-by-Ns array
%                  respectively, where OFDM subcarriers and OFDM symbols
%                  use two separate dimensions in the representation of RXSYM
%                  and EQSYM.
%                  "2-D" indicates that RXSYM is specified by an
%                  NRE-by-Nr array and EQSYM is an NRE-by-Ns array,
%                  i.e. OFDM subcarriers and OFDM symbols use one combined
%                  dimension in the representation of RXSYM and EQSYM, and
%                  NRE is the number of elements in a subset of the
%                  OFDM subcarrier-symbol grid. When "2-D" is specified,
%                  HEST should be specified by an NRE-by-Ns-by-Nr array.
%                  The default value is "3-D".
%
%   Class Support
%   -------------
%   - Received symbols, RXSYM, can be specfied as a real or complex
%     array, dlarray, or gpuArray.
%   - Channel estimate, HEST, can be specfied as a,
%              - Real or complex array, dlarray, or gpuArray if Ns == 1.
%              - Real or complex array or gpuArray if Ns > 1.
%   - Noise variance, NVAR, can be specified as a real vector or gpuArray.
%   - Equalized symbols, EQSYM, can be dlarray or gpuArray or combination
%     of both if inputs are specified as dlarray or gpuArray or combination
%     of both respectively.
%   - Soft channel state information, CSI, can be dlarray or combination of
%     dlarray or gpuArray only when Ns == 1. It can be gpuArray if inputs are
%     specified as gpuArray.
%
%   Notes
%   -----
%   - Nb is the number of batch observations which is an optional dimension
%     that can be added to RXSYM, HEST and NVAR.
%   - Received symbols, RXSYM, can be an array specified as,
%                   - Nsc-by-Nsym-by-Nr-by-Nb, if DataFormat is specified
%                     as "3-D".
%                   - NRE-by-Nr-by-Nb, if DataFormat is specified as "2-D".
%   - Channel estimate, HEST, can be an array specified as,
%                   - Nsc-by-Ns-by-Nr-by-Nb (or)
%                     (Nsc*Nsym)-by-Ns-by-Nr-by-Nb, if DataFormat is
%                     specified as "3-D".
%                   - NRE-by-Ns-by-Nr-by-Nb, if DataFormat is
%                     specified as "2-D".
%   - Noise variance, NVAR, can be a real vector with number of elements
%     equal to number of batch observations, Nb.
%
%   % Example: OFDM equalization  with transmit beamforming over a MIMO
%   % channel
%
%     numStreams = 2;
%     numTxAntenna = 4;
%     numRxAntenna = 3;
%     fftLen = 256;
%     cpLen = 16;
%     modOrder = 2^6; % 6 bits per OFDM data subcarrier
%     ofdmNullIdx = [1:9 (fftLen/2+1) (fftLen-8+1:fftLen)]'; % Guard bands and DC subcarrier
%     numOFDMSymbols = 10;
%     SNRdB = 40;
%
%     % OFDM modulation
%     numDataSubcarriers = fftLen-length(ofdmNullIdx);
%     srcBits = randi([0,1], [numDataSubcarriers*log2(modOrder) numOFDMSymbols numStreams]);
%     ofdmData = qammod(srcBits,modOrder,"InputType","bit","UnitAveragePower",true);
%     ofdmModOut = ofdmmod(ofdmData,fftLen,cpLen,ofdmNullIdx);
%
%     % Beamform the transmitted signal
%     fc = 1e9;
%     lambda = physconst('LightSpeed')/fc;
%     ang = 45;
%     antIdx = (0:numTxAntenna-1);
%     antDelay = (0:numStreams-1).'*2*pi*sin(2*pi*ang/360)/lambda;
%     B = exp(1i*antIdx.*antDelay);
%     txSignal = ofdmModOut * B;
%
%     % MIMO channel and AWGN
%     mimoChannel = comm.MIMOChannel("SampleRate",1e6, ...
%         "PathDelays",[1.5e-6 3e-6 5e-6],"AveragePathGains",[1.2 0.5 0.2], ...
%         "MaximumDopplerShift",1,"SpatialCorrelationSpecification","None", ...
%         "NumTransmitAntennas",numTxAntenna,"NumReceiveAntennas",numRxAntenna, ...
%         "PathGainsOutputPort",true);
%     [channelOut,pathGains] = mimoChannel(txSignal);
%     [rxSignal,nVar] = awgn(channelOut,SNRdB,"measured");
% 
%     % Use channel filter coefficients and path gains from comm.MIMOChannel to
%     % get channel response
%     mimoChannelInfo = info(mimoChannel);
%     pathFilters = mimoChannelInfo.ChannelFilterCoefficients;
%     timingOffset = mimoChannelInfo.ChannelFilterDelay;
%     H = ofdmChannelResponse(pathGains,pathFilters,fftLen,cpLen,...
%             setdiff(1:fftLen,ofdmNullIdx),timingOffset);
%     hEst = reshape(H,[],numTxAntenna,numRxAntenna);
%
%     % Compute the effective channel formed by the beamformer and MIMO
%     % channel
%     hEff = zeros(numDataSubcarriers*numOFDMSymbols,numStreams,numRxAntenna);
%     for k = 1:numOFDMSymbols*numDataSubcarriers
%         hEff(k,:,:) = B * squeeze(hEst(k,:,:));
%     end
% 
%     % Handle timing offset before OFDM demodulation:
%     % Remove initial samples and pad zeros to keep signal length unchanged
%     demodInput = [rxSignal(timingOffset+1:end,:); zeros(timingOffset,numRxAntenna)];
%     % OFDM demodulation and equalization
%     symOffset = cpLen/2; % Sampling offset for OFDM demodulation
%     rxSym = ofdmdemod(demodInput,fftLen,cpLen,symOffset,ofdmNullIdx); % The padded zeros are not used if timingOffset <= cpLen/2
%     eqSym = ofdmEqualize(rxSym,hEff,nVar);
%     constellationDiagram = comm.ConstellationDiagram("XLimits",[-2 2],"YLimits",[-2 2], ...
%         "ReferenceConstellation",qammod(0:modOrder-1,modOrder,"UnitAveragePower",true));
%     constellationDiagram(eqSym(:));
%
%   See also OFDMMOD, OFDMDEMOD, OFDMCHANNELRESPONSE.

%   Copyright 2022-2023 The MathWorks, Inc.

%#codegen

narginchk(2, 7);
nInArgs = nargin;

% Parse name-value arguments
defaults = struct('DataFormat', '3-D', 'Algorithm', 'mmse');
fcnName = 'ofdmEqualize';
if nInArgs > 2
    if mod(nInArgs,2)
        noiseVariance = varargin{1};
        ind = 2;
    else
        noiseVariance = 0;
        ind = 1;
    end
    res = comm.internal.utilities.nvParser(defaults, varargin{ind:end});
    validatestring(res.DataFormat, {'2-D', '3-D', '2D', '3D'}, fcnName, 'DataFormat');
    validatestring(res.Algorithm, {'mmse', 'zf'}, fcnName, 'Algorithm');
else
    noiseVariance = 0;
    res.DataFormat = '3-D';
    res.Algorithm = 'mmse';
end

if strcmpi(res.Algorithm,'mmse')
    algorithm = 0;
    validateattributes(noiseVariance, {'double', 'single'}, ...
        {'vector', 'real', 'nonnegative', 'finite'}, ...
        fcnName, 'NVAR', 3);
else
    algorithm = 1;
    noiseVariance(:) = 0; % For ZF
end

% Validate inputs
comm.internal.ofdm.validateInputs(res.DataFormat, rxSym, hEst, fcnName, 'RXSYM', 'HEST', 0);
coder.internal.errorIf((~isscalar(noiseVariance) && (length(noiseVariance) ~= size(hEst,4))), ...
    'comm:ofdmEqualize:UnequalBatches', '3', 'NVAR', size(hEst,4));
coder.internal.errorIf(isa(noiseVariance, "dlarray"), ...
    'comm:ofdmEqualize:InvalidNVARType');

if strcmpi(res.DataFormat,'2-D') || strcmpi(res.DataFormat,'2D')
    [eqSym, csi] = comm.internal.ofdm.equalizeCore2D(rxSym, hEst, noiseVariance, algorithm);
else
    [eqSym, csi] = comm.internal.ofdm.equalizeCore3D(rxSym, hEst, noiseVariance, algorithm);
end



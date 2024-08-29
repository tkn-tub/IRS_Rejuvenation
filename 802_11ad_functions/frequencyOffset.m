function y = frequencyOffset(x,sampleRate,offset)
%FREQUENCYOFFSET Apply frequency offset to input signal
%   Y = FREQUENCYOFFSET(X,SAMPLERATE,OFFSET) applies the specified
%   frequency offset to the real or complex input signal X. Y is the
%   impaired output signal of the same size as X. X is a matrix. SAMPLERATE
%   is the sampling rate of X, in Hz, which must be a positive scalar.
%   OFFSET is the frequency offset, in Hz, applied to X. OFFSET must be a
%   scalar or a row vector with the same number of columns as X. For a
%   vector, each element value is applied independently to each column of
%   X.
%
%   % Example:
%   % Apply frequency offset to a complex sine wave.
%
%   fs = 1024; % Sampling frequency (Hz)
%   time = (0:1/fs:1-1/fs)';
%   freq = 256; % Hz
%   sig = exp(2*pi*1i*freq*time);
%
%   % Plot waveform
%   freqVec = (-fs/2:fs/2-1)';
%   plot(freqVec,abs(fftshift(fft(sig)/fs)));
%   xlim([-fs/2 fs/2]);
%   ylim([0 1.05]);
%   xlabel("Frequency (Hz)");
%   ylabel("Normalized Amplitude");
%   hold on;
%
%   % Apply frequency offset
%   offset = 32; % Frequency offset (Hz)
%   sigOffset = frequencyOffset(sig,fs,offset);
%
%   % Plot waveform with frequency offset
%   plot(freqVec,abs(fftshift(fft(sigOffset)/fs)),"r");
%   legend("Original sine wave","Offset sine wave","Location","northwest");
%
%   See also comm.PhaseFrequencyOffset.

%   Copyright 2021-2022 The MathWorks, Inc.

%#codegen

% Validate number of arguments
narginchk(3,3)

% Validate attributes
validateattributes(x,{'double','single'}, ...
    {'2d','nonnan','finite'},'frequencyOffset','X');
validateattributes(sampleRate,{'double','single'}, ...
    {'scalar','real','nonnan','finite','>',0},'frequencyOffset','SampleRate');
validateattributes(offset,{'double','single'}, ...
    {'row','real','nonnan','finite'},'frequencyOffset','OFFSET');

% Check for dimension mismatch: Number of columns in x should equal the
% number of columns in offset.
if ~isscalar(offset) && (size(x,2)~=size(offset,2))
    coder.internal.error('comm:frequencyOffset:frequencyOffsetDims');
end

% Cast sampleRate and offset to have same data type as input signal
fs = cast(sampleRate,'like',x);
freqOffset = cast(offset,'like',x);
piVal = cast(pi,'like',x);

% Create vector of time samples
t = ((0:size(x,1)-1)./fs).';

% For each column, apply the frequency offset
y = x.*exp(1i*2*piVal*freqOffset.*t);


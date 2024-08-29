function plotDMGWaveform(x,cfgDMG,varargin)
%plotDMGWaveform Displays a DMG waveform with the fields highlighted
%
%   plotDMGWaveform(X,CFGDMG) displays the magnitude of a DMG waveform X
%   and a configuration CFGDMG. Individual fields are highlighted.
%
%   X is a complex column vector containing the waveform. The waveform is
%   assumed to begin at the first element of the vector.
%   
%   CFGDMG is a DMG format configuration object.
%
%   plotDMGWaveform(X,CFGDMG,TITLE) optionally plots the waveform with a
%   custom title. TITLE is a character array.

%   Copyright 2016-2019 The MathWorks, Inc.

narginchk(2,3);
if nargin>2
    titlestr = varargin{1};
else
    titlestr = 'Waveform with Highlighted Fields';
end

sr = wlanSampleRate(cfgDMG);
txTime = (numel(x)/sr)*1e6; % Duration to plot in microseconds
tick = (1/sr)*1e6; % Microseconds per sample
hf = figure;
hp = plot(0:tick:txTime-tick,abs(x(1:round(txTime*sr*1e-6),:)));
cy = ylim(gca);
ylim(gca,[cy(1) cy(2)+1]);
ylabel('Magnitude (V)');
xlabel('Time (microseconds)');
title(titlestr);
dmgPlotFieldColored(cfgDMG,hf,hp,0); % 5 us offset for plot
end

% Overlays field names on a plot
function dmgPlotFieldColored(cfg,hf,hp,varargin)

narginchk(3,4);

offset = 0;
if nargin>3
    offset = varargin{1};
end

% Field durations in Microseconds
Fs = wlanSampleRate(cfg);
ind = wlanFieldIndices(cfg);
Tstf = double((ind.DMGSTF(2)-ind.DMGSTF(1))+1)/Fs*1e6;
Tce = double((ind.DMGCE(2)-ind.DMGCE(1))+1)/Fs*1e6;
Theader = double((ind.DMGHeader(2)-ind.DMGHeader(1))+1)/Fs*1e6;
Tdata = double((ind.DMGData(2)-ind.DMGData(1))+1)/Fs*1e6;
Tagc = double((ind.DMGAGC(2)-ind.DMGAGC(1))+1)/Fs*1e6;
Tagcsf  = double((ind.DMGAGCSubfields(1,2)-ind.DMGAGCSubfields(1,1))+1)/Fs*1e6;
Ttrn = double((ind.DMGTRN(2)-ind.DMGTRN(1))+1)/Fs*1e6;
Ttrnsf  = double((ind.DMGTRNSubfields(1,2)-ind.DMGTRNSubfields(1,1))+1)/Fs*1e6;
N = cfg.TrainingLength/4;

figure(hf);
ax = gca;
hold(ax,'on');
legendTxt = [];
lh = [];

% Set first color to use for plotting
ListColors = colorcube(64);
colidx = 39; % Start within the color map

xlimits = xlim(ax);
Tcum = 0;
if offset<Tstf
    % STF
    legendTxt = [legendTxt {'STF'}];   
    plotLine(Tstf);
    if Tstf>=xlimits(2)
        return
    end
end
Tcum = Tstf;
if offset<(Tstf+Tce)
    % CE
    legendTxt = [legendTxt {'CE'}];
    plotLine(Tce);
    if (Tcum+Tce)>=xlimits(2)
        return
    end
end
Tcum = double(ind.DMGCE(2))/Fs*1e6;
if offset<(Tcum+Theader)
    % Header
    legendTxt = [legendTxt {'Header'}];
    plotLine(Theader);
    if (Tcum+Theader)>=xlimits(2)
        return
    end
end
Tcum = double(ind.DMGHeader(2))/Fs*1e6;
if offset<(Tcum+Tdata)
    % Data
    legendTxt = [legendTxt {'Data'}];
    plotLine(Tdata);
    if (Tcum+Tdata)>=xlimits(2)
        return
    end
end
Tcum = double(ind.DMGData(2))/Fs*1e6;
if offset<(Tcum+Tagc)
    % AGC
    for i = 1:N*4
        if (Tcum+i*Tagcsf)>=xlimits(2)
            return
        end
        legendTxt = [legendTxt {['AGC-SF' num2str(i)]}]; %#ok<AGROW>
        plotLine(Tagcsf);
        Tcum = double(ind.DMGAGCSubfields(i,2))/Fs*1e6;
    end
end
if offset<(Tcum+Ttrn)
    % TRN
    for i = 1:N*5
        if mod(i-1,5)==0
            % TRN-CE
            if (Tcum+Tce)>=xlimits(2)
                return
            end
            legendTxt = [legendTxt {'TRN-CE'}]; %#ok<AGROW>
            plotLine(Tce);
            trnCEIdx = mod(i-1,5)+(i-1)/5+1;
            Tcum = double(ind.DMGTRNCE(trnCEIdx,2))/Fs*1e6;
        else
            % TRN-SF
            if (Tcum+Ttrnsf)>=xlimits(2)
                return
            end
            trnSFIdx = mod(i-1,5)+floor((i-1)/5)*4;
            legendTxt = [legendTxt {['TRN-SF' num2str(trnSFIdx)]}]; %#ok<AGROW>
            plotLine(Ttrnsf);
            Tcum = double(ind.DMGTRNSubfields(trnSFIdx,2))/Fs*1e6;
        end
    end
end
hold(ax,'off');
xlim([offset xlimits(2)]);
legend(lh,legendTxt,'location','best')
delete(hp) % Remove original waveform from plot

function plotLine(Tfield)
    % Get portion of waveform for current field and replot it with desired
    % color
    a = get(ax,'children');
    replotIdx = (a(end).XData>=Tcum)&(a(end).XData<(Tcum+Tfield));
    col = ListColors(mod(colidx,size(ListColors,1))+1,:); % Get color
    hl = plot(a(end).XData(replotIdx),a(end).YData(replotIdx),'Color',col);
    colidx = colidx+1; % Increment color index for next field
    lh = [lh hl]; % Store handle for legend
    
    % Plot field boundary line
    plot(ax,[Tcum+Tfield Tcum+Tfield],ylim(gca),'k:');
end

end
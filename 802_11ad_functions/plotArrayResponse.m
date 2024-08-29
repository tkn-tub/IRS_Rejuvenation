function plotArrayResponse(TxArray,receiverAz,fc,weights)
%plotArrayResponse  Featured example helper function
%
%   Plot the array response

%   Copyright 2018 The MathWorks, Inc.

d = directivity(TxArray,fc,[0 90]); % Broadside and end-fire directivity
figure;
pattern(TxArray,fc,-90:90,0,'Weights',weights); % Plot array pattern
p = polarpattern('gco');
add(p,[0 receiverAz],[d(2) d(1)-d(2)]); % Plot receiver direction
numAWV = size(weights,2);
legendStr = cell(numAWV+1,1); % Create legend
legendStr{1} = 'Data field weights';
legendStr(2:end-1) = arrayfun(@(x)sprintf('TRN-SF%d weights',x),1:numAWV-1,'UniformOutput',false);
legendStr{end} = 'Receiver direction';
p.LegendLabels = legendStr;
end
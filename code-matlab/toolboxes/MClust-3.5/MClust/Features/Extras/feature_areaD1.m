function [AreaData, AreaNames, AreaPars] = feature_AreaD1(V, ttChannelValidity, Params)

% MClust
% for number of samples in waveform.
%
% JCJ Nov 2003

TTData = Data(V);

[nSpikes, nCh, nSamp] = size(TTData);

f = find(ttChannelValidity);

AreaData = zeros(nSpikes, length(f));

AreaNames = cell(length(f), 1);
AreaPars = {};
AreaData = squeeze(sum(diff(TTData(:, f, :),1, 3),3))./nSamp;

for iCh = 1:length(f)
   AreaNames{iCh} = ['AreaD1: ' num2str(f(iCh))];
end
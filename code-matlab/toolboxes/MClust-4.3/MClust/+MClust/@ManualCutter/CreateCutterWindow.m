function CreateCutterWindow(self)
% MClustCutter.CreateCutterWindow

MCS = MClust.GetSettings();
MCD = MClust.GetData();

self.CreateCutterWindow@MClust.Cutter();  % call superclass to build initial window

%--------------------------------
% constants to make everything identical

uicHeight = self.uicHeight;
uicWidth  = self.uicWidth;
uicWidth0 = self.uicWidth0;
uicWidth1 = self.uicWidth1;
XLocs = self.XLocs;
dY = self.dY;
YLocs = self.YLocs;

set(self.CC_figHandle, 'name','Manual Cutting Control Window');

MCS.PlaceWindow(self.CC_figHandle); % ADR 2013-12-12

% ----- axes

% ----- Drawing

% ----- Clusters
[~,AvailableTypes] = MCS.FindAvailableClusterTypes();
StartingType = find(strncmp(MCS.StartingClusterType, AvailableTypes, length(MCS.StartingClusterType)), 1, 'first');
if isempty(StartingType), StartingType = 1; end
self.clusterTypeToAddMenu = ...
    uicontrol('Parent', self.CC_figHandle,...
    'Units', 'Normalized', 'Position', [XLocs(1)+1.5*uicWidth YLocs(9) 0.25*uicWidth uicHeight],...
    'Style', 'popupmenu',...
    'String', AvailableTypes,...
    'Max', 1, 'Min', 1, 'value', StartingType, ...
    'Enable','on', ...
    'Callback', @(src,event)ChangeClusterTypeToAdd(self),...
    'TooltipString', 'New cluster type to add.');

self.addClusterButton = ...
    uicontrol('Parent', self.CC_figHandle, ...
    'Units', 'Normalized', 'Position', [XLocs(1) YLocs(9) 1.5*uicWidth uicHeight], ...
    'Style', 'pushbutton', 'String', 'Add Cluster', ...
    'Callback', @(src,event)AddCluster(self), ...
    'TooltipString', 'Add a cluster to the list.');
self.ChangeClusterTypeToAdd();

%-----------------------------------
%
uicontrol('Parent', self.CC_figHandle, ...
    'Units', 'Normalized', 'Position', [XLocs(1) YLocs(10) (uicWidth+uicWidth0)/2 uicHeight], ...
    'Style', 'pushbutton', 'String', 'Pack', ...
    'Callback', @(src,event)PackClusters(self), ...
    'TooltipString', 'Pack clusters; clear unused clusters');
uicontrol('Parent', self.CC_figHandle, ...
    'Units', 'Normalized', 'Position', [XLocs(1)+(uicWidth+uicWidth0)/2 YLocs(10) (uicWidth+uicWidth0)/2 uicHeight], ...
    'Style', 'PushButton', 'String', 'Clear Clusters',  ...
    'Callback', @(src,event)ClearClusters(self), ...
    'TooltipString', 'Remove all clusters.');


% undo/redo
self.undoButton = ...
    uicontrol('Parent', self.CC_figHandle, ...
    'Units', 'Normalized', 'Position', [XLocs(1) YLocs(12) (uicWidth+uicWidth0)/2 uicHeight], ...
    'Style', 'pushbutton', 'String', 'Undo',  ...
    'Callback', @(src,event)PopUndo(self));
self.redoButton = ...
    uicontrol('Parent', self.CC_figHandle, ...
    'Units', 'Normalized', 'Position', [XLocs(1)+(uicWidth+uicWidth0)/2 YLocs(12) (uicWidth+uicWidth0)/2 uicHeight], ...
    'Style', 'pushbutton', 'String', 'Redo',  ...
    'Callback', @(src,event)PopRedo(self));

% % Cutter options
% Load/Save/Clear clusters

uicontrol('Parent', self.CC_figHandle, ...
    'Units', 'Normalized', 'Position', [XLocs(1) YLocs(14) (uicWidth+uicWidth0)/2 uicHeight], ...
    'Style', 'PushButton', 'String', {'Load','Clusters'},  ...
    'Callback', @(src,event)LoadClusters(self), ...
    'TooltipString', 'Load clusters - replaces clusters in memory');
uicontrol('Parent', self.CC_figHandle, ...
    'Units', 'Normalized', 'Position', [XLocs(1)+(uicWidth+uicWidth0)/2 YLocs(14) (uicWidth+uicWidth0)/2 uicHeight], ...
    'Style', 'PushButton', 'String', 'Save Clusters',  ...
    'Callback', @(src,event)SaveClusters(self), ...
    'TooltipString', 'Save Clusters to file');
self.autosaveButton = ...
    uicontrol('Parent', self.CC_figHandle, ...
    'Units', 'Normalized', 'Position', [XLocs(1) YLocs(15) uicWidth+uicWidth0 uicHeight], ...
    'Style', 'pushbutton', 'String', ['Autosave in ' num2str(self.Autosave)], ...
    'Callback', @(src,event)SaveAutosave(self), ...
    'TooltipString', 'Steps to autosave');

end
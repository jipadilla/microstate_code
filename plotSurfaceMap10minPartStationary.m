
% This script will plot individual surface map and combine individual
% ones into one panel

clear
clc
close all
%%%Get the Surface maps

numSeed=4;
session='session1';
dataLength='all_10min';
mapType='stationaryFCMap';
%mapType='corBrainMapAvg';

if strcmp(mapType, 'corBrainMapAvg')
    NMin=0; PMin = 0.0000001;
    NMax=-1.5; PMax=2;
else
    NMin=-0.00000000001; PMin = 0.00000000001;
    NMax=-10; PMax=10;
end


Prefix='';

PicturePrefix='';

ClusterSize=0;

SurfaceMapSuffix='_SurfaceMap.jpg';


ConnectivityCriterion=18;

[BrainNetViewerPath, fileN, extn] = fileparts(which('BrainNet.m'));

SurfFileName=[BrainNetViewerPath,filesep,'Data',filesep,'SurfTemplate',filesep,'BrainMesh_ICBM152_smoothed.nv'];

viewtype='MediumView';

ColorMap=jet(100);

imgInputDir = ['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/',dataLength, filesep,session, filesep, mapType];

surfaceMapOutputDir = ['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/', dataLength, filesep, session,filesep,'surfaceMap', filesep, mapType];

for i=1:numSeed
    InputName = [imgInputDir,filesep,'thresholdedPartialStationaryFCMap_seed', num2str(i), '_',session, '.nii'];
    
    OutputName = [surfaceMapOutputDir,filesep,'thresholdedPartialStationaryFCMap_seed', num2str(i), '_',session, SurfaceMapSuffix];
    
    H_BrainNet = rest_CallBrainNetViewer(InputName,NMin,PMin,ClusterSize,ConnectivityCriterion,SurfFileName,viewtype,ColorMap,NMax,PMax);
    
    eval(['print -r300 -djpeg -noui ''',OutputName,''';']);
end



%%% Auto Draw on a panel

%LeftMaskFile = '/home/data/HeadMotion_YCG/YAN_Scripts/HeadMotion/Parts/Left2FigureMask_BrainNetViewerMediumView.jpg';
close all
DataUpDir = ['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/',dataLength, filesep, session,filesep,'surfaceMap',filesep, mapType];

OutputUpDir = ['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/', dataLength, filesep, session,filesep,'surfaceMap', filesep, mapType];

SurfaceMapSuffix='_SurfaceMap.jpg';


UnitRow = 2168;
UnitColumn = 3095;

BackGroundColor = uint8([255*ones(1,1,3)]);

numRow=2;
numColumn=2;

imdata_All = repmat(BackGroundColor,[UnitRow*numRow,UnitColumn*numColumn,1]);

%LeftMask = imread(LeftMaskFile);

k=0;
for i=1:numRow
    for  j=1:numColumn
        k=k+1;
        imdata = imread([DataUpDir, filesep,'thresholdedPartialStationaryFCMap_seed', num2str(k), '_',session, SurfaceMapSuffix]);
        
        %imdata(LeftMask==255) = 255;
        
        % imdata = imdata(1:end-80,120:1650,:);
        
        imdata=imdata(1:end,120:3214,:);
        
        imdata_All (((i-1)*UnitRow + 1):i*UnitRow,((j-1)*UnitColumn + 1):j*UnitColumn,:) = imdata;
    end
end

figure

image(imdata_All)

axis off          % Remove axis ticks and numbers

axis image        % Set aspect ratio to obtain square pixels



OutJPGName=[OutputUpDir,filesep,session, '_Partial_', mapType, '_allSeedsCombined.jpg'];

eval(['print -r300 -djpeg -noui ''',OutJPGName,''';']);



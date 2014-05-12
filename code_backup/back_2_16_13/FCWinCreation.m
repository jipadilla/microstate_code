function [winAllSubAllSeedFullCor, winAllSubAllSeedPartialCor]=FCWinCreation(TR,session,subList)
% Output: this function output windows of full correlation or regularized covariance
% with all subjects and all seeds concatenated.
%Input:
%1.TRList: cell format, e.g. {'645','2500'};
%2.sessionlist: string, e.g. {'session1'}
%3.SubList: in cell format, e.g. subList={'0021002', '0021006'} or in a
%text file.
%4.corType: numerical, 1=full correlation; 2=regularized covariance (This
%is removed from the original function)


winWidth=69;
step=3;
numVol=450;
numWin=floor((numVol-winWidth)/step)+1;
numSub=length(subList);
numWinAllSub=numWin*numSub;
analyDir=['/home/data/Projects/microstate/DPARSF_preprocessed/'];

% create the convolved window
[finalWin]=winCreation(winWidth,0);
finalWin=finalWin';

disp(['Create full and partial correlation windows for ',TR,' ', session,'.'])

for k=1:numSub
    sub=subList{k};
    disp (['Working on sub ', char(sub),' ......'])
    subDir=[analyDir,'data/',TR,'/',session,'/',char(sub)];
    seedROISignals = load([subDir,'/ROISignals_seed_ROISignal.mat']);
    TC1=seedROISignals.ROISignals;
    numSeed=size(TC1,2);
    
    ROIROISignals=load([subDir,'/ROISignals_atlas_ROISignal.mat']);
    TC2=ROIROISignals.ROISignals;
    numROI=size(TC2,2);
    
    % concatenate the time series of seeds and ROIs
    TC=[TC1,TC2];
    
    % apply the sliding window to the time series
    asize = size(TC);
    
    % win(winWidth,asize(2),numWinAllSub);
    for q=1+numWin*(k-1):numWin*k;
        for n=((q-1)-(k-1)*numWin)*step+1:winWidth+((q-1)-(k-1)*numWin)*step
            for m=1:asize(2)
                win(n-((q-1)-(k-1)*numWin)*step,m,q)=TC(n,m)*finalWin((n-((q-1)-(k-1)*numWin)*step),1);
            end
        end
    end
end

disp (['Window applying done for all subjects. All windows of time series are saved in one matrix!'])
disp (['Compute the full and parital correlation for each window'])

% generate the full correlation for each window
for q=1:numWinAllSub
    corrWin(:,:,q)=corrcoef(win(:,:,q));
    for n=1:numSeed
        for m=1:numSeed
            dynFCBtwSeed(n,m,q)=corrWin(n,m,q);
            zDynFCBtwSeed(n,m,q)=0.5*log((1+dynFCBtwSeed(n,m,q))./(1-dynFCBtwSeed(n,m,q)));
        end
        for m=numSeed+1:numROI+numSeed
            dynFC(n,m-numSeed,q)=corrWin(n,m,q);
            zDynFC(n,m-numSeed,q)=0.5*log((1+dynFC(n,m-numSeed,q))./(1-dynFC(n,m-numSeed,q)));
        end
    end
end
disp('Full correlation between seeds and between seeds and ROIs are extracted for each window.')

winAllSubSeed1=reshape(zDynFC(1,:,:),numROI,[])';
winAllSubSeed2=reshape(zDynFC(2,:,:),numROI,[])';
winAllSubSeed3=reshape(zDynFC(3,:,:),numROI,[])';
winAllSubSeed4=reshape(zDynFC(4,:,:),numROI,[])';
winAllSubAllSeedFullCor=vertcat(winAllSubSeed1, winAllSubSeed2, winAllSubSeed3, winAllSubSeed4);
disp ('Full correlation windows were concatenated as numWin/sub * numSub * numSeed.')

% generate partial correlation for each window
for q=1:numWinAllSub
    clear tmp normWin
    tmp1=squeeze(win(:,:,q));
    normWin= (tmp1-repmat(mean(tmp1),size(tmp1,1),1))./repmat(std(tmp1),size(tmp1,1),1);
    normWin(isnan(normWin))=0;
    [W, theta, lambda, errors]=GraphicalLassoPath(normWin,0.11);
    partialCorWin(:,:,q)=theta;
    disp(['Graphical Lasso for window',num2str(q),' done!'])
    for n=1:numSeed
        for m=1:numSeed
            partialDynFCBtwSeed(n,m,q)=partialCorWin(n,m,q);
            partialZDynFCBtwSeed(n,m,q)=0.5*log((1+partialDynFCBtwSeed(n,m,q))./(1-partialDynFCBtwSeed(n,m,q)));
        end
        for m=numSeed+1:numROI+numSeed
            partialDynFC(n,m-numSeed,q)=partialCorWin(n,m,q);
            partialZDynFC(n,m-numSeed,q)=0.5*log((1+partialDynFC(n,m-numSeed,q))./(1-partialDynFC(n,m-numSeed,q)));
        end
    end
end
disp('Partial correlation between seeds and between seeds and ROIs are extracted for each window.')

partWinAllSubSeed1=reshape(partialZDynFC(1,:,:),numROI,[])';
partWinAllSubSeed2=reshape(partialZDynFC(2,:,:),numROI,[])';
partWinAllSubSeed3=reshape(partialZDynFC(3,:,:),numROI,[])';
partWinAllSubSeed4=reshape(partialZDynFC(4,:,:),numROI,[])';
winAllSubAllSeedPartialCor=vertcat(partWinAllSubSeed1, partWinAllSubSeed2, partWinAllSubSeed3, partWinAllSubSeed4);
disp ('Patial correlation windows were concatenated as numWin/sub * numSub * numSeed.')





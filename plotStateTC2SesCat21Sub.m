

clear
clc
close all


dataLength='all_10min';
W_width = 69;
% window sliding step in TRs
step=3;
% total number of time points
N_vol=884;
numSub=21;
numSeed=4;
% number of windows
numWinPerSub=floor((N_vol-W_width)/step)+1;
numWinPerSeed=numWinPerSub*numSub
numWinPerSes=numWinPerSeed*numSeed;
Time=ceil(W_width/2):step:(ceil(W_width/2)+step*(numWinPerSub-1));

numROI=156;
resultDir=['/home/data/Projects/microstate/DPARSF_preprocessed/results/645/',dataLength,'/2sessions/'];
figDir=['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/',dataLength, '/2sessions/stateTC/21sub/individual/'];


indx=load([resultDir,'clustIndxNormWinAllSeeds_FullCorLasso_2sessions_10min_21sub.txt']);
numWinPerSes=numWinPerSub*numSub*numSeed
indxSes1=indx(1:numWinPerSes,1);
length(indxSes1)
indxSes2=indx(numWinPerSes+1:end, 1);
length(indxSes2)

session='session2';
% plot time course of these states
if strcmp (session,'session1');
    indx=indxSes1;
else
    indx=indxSes2;
end

plotcolor=['r' 'b' 'm' 'g'];
for j=1:numSub
    for i=1:numSeed
        figure(j)
        indxSeed=indx((1+numWinPerSeed*(i-1)):numWinPerSeed*i);
        indxSeedSub=indxSeed((1+numWinPerSub*(j-1)):numWinPerSub*j);
        h=plot(Time,indxSeedSub,plotcolor(i))
        set(h,'LineWidth',3.5)
        set(gca, 'yTick', 0:6 )
        ylim([0 6])
        xlim([0 N_vol])
        ylabel('States')
        xlabel('Time')
        title('Time Course of States')
        %legend('Seed1','Seed2','Seed3','Seed4')
        hold on
    end
    hold off
    saveas(figure(j),[figDir, 'stateTC_sub', num2str(j), '_',session, 'seedsTogether.png'])
end
close all

plotcolor=['r' 'b' 'm' 'g'];
for j=1:numSub
    for i=1:numSeed
        figure(j)
        subplot(2,2,i)
        indxSeed=indx((1+numWinPerSeed*(i-1)):numWinPerSeed*i);
        indxSeedSub=indxSeed((1+numWinPerSub*(j-1)):numWinPerSub*j);
        h=plot(Time,indxSeedSub, plotcolor(i))
        set(h,'LineWidth',3.5)
        ylim([0 6])
        xlim([0 N_vol])
        ylabel('States')
        xlabel('Time')
        title(['Time Course of States -- Seed ', num2str(i)])
    end
    
    saveas(figure(j),[figDir, 'stateTC_sub', num2str(j), '_',session, 'seedSep.png'])
end
close all

% compute the correlation of time course among 4 seeds
% correl=zeros(numSeed,numSeed,numSub);
% for j=1:numSub
%     indxRecodeSubSeed1=indxRecode((1+numWinPerSub*(j-1)):numWinPerSub*j);
%     indxRecodeSubSeed2=indxRecode((1+numWinPerSub*(j-1)+numWinPerSeed):(numWinPerSub*j+numWinPerSeed));
%     indxRecodeSubSeed3=indxRecode((1+numWinPerSub*(j-1)+numWinPerSeed*2):(numWinPerSub*j+numWinPerSeed*2));
%        indxRecodeSubSeed4=indxRecode((1+numWinPerSub*(j-1)+numWinPerSeed*3):(numWinPerSub*j+numWinPerSeed*3));
%        indxRecodeSub=[indxRecodeSubSeed1,indxRecodeSubSeed2,indxRecodeSubSeed3,indxRecodeSubSeed4];
%        correl(:,:,j)=corrcoef(indxRecodeSub)
% end
%
% if strcmp(session,'session2')
%     % sub 21 session2 seed2 is all in one state, the correlcoeff is NAN.
%     % Removeme this subject from the aveger analysis
%     correl(:,:,21)=[];
%     correlReshape=reshape(correl, [],21)';
%     meanCorrel=mean(correlReshape);
%     meanCorrelReshape=reshape(meanCorrel, 4,4);
% else
%     % sub 3 and 14 seed 3 and seed 4 are all in one state, the correlcoeff
%     % is NAN. These two subject were removed from the average. Correl(:, :,
%     % 13) were assigned to [], due to the order change after remove sub 3
%     correl(:,:,3)=[];
%     correl(:,:,13)=[];
%     correlReshape=reshape(correl, [],20)';
%     meanCorrel=mean(correlReshape);
%     meanCorrelReshape=reshape(meanCorrel, 4,4);
% end
%     save([resultDir, 'meanCorStatTCof4seeds_',session, '.txt'], 'meanCorrelReshape')
%



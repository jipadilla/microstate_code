% This script will compute R2 and pseudoF to estimate cluster number

clear
clc
close all

%TRList={'645','2500'};
%sessionList={'session1','session2'};
subList=load('/home/data/Projects/microstate/NKITRT_SubID.mat');
subList=subList.SubID;

TRList={'645'};
sessionList={'session2'};
%subList={'0021002'};

numSub=length(subList);
numSession=length(sessionList);
numTR=length(TRList);
analyDir=['/home/data/Projects/microstate/DPARSF_preprocessed/'];


minNumClust=2;
maxNumClust=200;
for i=1:numTR
    TR=TRList{i};
    for j=1:numSession
        session=sessionList{j};
        resultDir=[analyDir,'/results/',TR, '/',session,'/', session,'_ward_euclidean/computeClustIndx/'];
        figDir=[analyDir,'/fig/',TR, '/',session,'/', session,'_ward_euclidean/'];
        [ R2 pseudoF ] = clustNumEstimate( session, minNumClust, maxNumClust );
        save([resultDir,'R2','_',session,'_',num2str(minNumClust),'_to_', num2str(maxNumClust),'_clusters.mat'],'R2');
        save([resultDir,'pseudoF','_',session,'_',num2str(minNumClust),'_to_', num2str(maxNumClust),'_clusters.mat'],'pseudoF');
        figure (1)
        plot(R2)
        title('R2 as a function of number of clusters')
        xlabel('Number of Clusters')
        ylabel('R2')
        saveas(figure(1),[figDir,'R2_',session,'_',num2str(minNumClust),'_to_', num2str(maxNumClust),'clusters.png'])
        figure (2)
        plot(pseudoF)
        title('pseudoF as a function of number of clusters')
        xlabel('Number of Clusters')
        ylabel('pseudoF')
        saveas(figure(2),[figDir,'pseudoF_',session,'_',num2str(minNumClust),'_to_', num2str(maxNumClust),'clusters.png'])
    end
end

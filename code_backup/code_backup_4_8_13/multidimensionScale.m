clear
clc
close all


dataLength='all_10min';

resultDir1=['/home/data/Projects/microstate/DPARSF_preprocessed/results/645/', dataLength, filesep, 'session1/clustMean/'];
resultDir2=['/home/data/Projects/microstate/DPARSF_preprocessed/results/645/', dataLength, filesep, 'session2/clustMean/'];
figDir=['/home/data/Projects/microstate/DPARSF_preprocessed/fig/645/', dataLength, '/multidimScale/'];



numClust1=5;
numClust2=6;
tmp1=load([resultDir1,'/clusterMean_',num2str(numClust1),'clusters_session1_normWin.mat']);
tmp2=load([resultDir2,'/clusterMean_',num2str(numClust2),'clusters_session2_normWin.mat']);
clustMean1=tmp1.finalMeanWinOfClust;
clustMeanTransp1=clustMean1';
clustMean2=tmp2.finalMeanWinOfClust;
clustMeanTransp2=clustMean2';
clustMeanTransp=[clustMeanTransp1,clustMeanTransp2];
corClusters=corrcoef(clustMeanTransp);

%% euclidean distance
session='bothSessions';

clustMean2Sessions=vertcat(clustMean1,clustMean2);
D=pdist(clustMean2Sessions, 'euclidean');
[Y,eigvals] = cmdscale(D);
[eigvals eigvals./max(abs(eigvals))]

% the scree plot of eigvalue as a function of the number of eigvalue to
% help decide how many dimenssions to use
figure(1)
plot(1:length(eigvals),eigvals,'bo-');
axis([1,length(eigvals),min(eigvals),max(eigvals)*1.1]);
xlabel('Eigenvalue number');
ylabel('Eigenvalue');
saveas(figure(1),[figDir,'eigvalsMultidimScal_',session, '_euclidean.png'])

labels={'\leftarrows1c1','\leftarrows1c2','\leftarrows1c3','\leftarrows1c4',...
    '\leftarrows1c5','\leftarrows2c1','\leftarrows2c2','\leftarrows2c3',...
    '\leftarrows2c4','\leftarrows2c5','\leftarrows2c6'};

% plot 2D
figure(2)
plot(Y(1:5,1), Y(1:5,2), 'bo', 'MarkerSize', 8, 'MarkerEdgeColor','k',...
    'MarkerFaceColor','r');
hold on
plot(Y(6:end,1), Y(6:end,2), 'bs', 'MarkerSize', 8, 'MarkerEdgeColor','k',...
    'MarkerFaceColor','b');
axis(max(max(abs(Y))) * [-1.1,1.1,-1.1,1.1]); axis('square');
text(Y(:,1),Y(:,2),labels,'HorizontalAlignment','left','FontSize',10);

% add the two grey line at x=0 and y=0
if feature('HGUsingMATLABClasses')
    hx = specgraphhelper('createConstantLineUsingMATLABClasses',...
        'LineStyle','-','Color',[.7 .7 .7],'Parent',gca);
    hx.Value = 0;
else
    hx = graph2d.constantline(0,'LineStyle','-','Color',[.7 .7 .7]);
end
changedependvar(hx,'x');
if feature('HGUsingMATLABClasses')
    hy = specgraphhelper('createConstantLineUsingMATLABClasses',...
        'LineStyle','-','Color',[.7 .7 .7],'Parent',gca);
    hy.Value = 0;
else
    hy = graph2d.constantline(0,'LineStyle','-','Color',[.7 .7 .7]);
end
changedependvar(hy,'y');

saveas(figure(2),[figDir,'Distance_2D_',session, '_euclidean.png'])

% plot 3D
% figure(3)
% plot3(Y(:,1), Y(:,2), Y(:,3),'bo', 'MarkerSize', 8, 'MarkerEdgeColor','k',...
%     'MarkerFaceColor','g');
% box on
% view(35, 30);
% %set(gca, 'XGrid','on')
% axis(max(max(abs(Y))) * [-1.1,1.1,-1.1,1.1,-1.1,1.1]); axis('square');
% text(Y(:,1),Y(:,2),Y(:,3),labels,'HorizontalAlignment','left');
% xlabel('x axis','Rotation', -5, 'FontSize',15);
% ylabel('y axis','Rotation',35, 'FontSize',15);
% zlabel('z axis','FontSize',15);
% saveas(figure(3),[figDir,'Distance_3D_',session, '_euclidean.png'])

%% correlation
% session can be 'session1', 'session2', or 'bothSessions'
session='bothSessions';


if strcmp(session,'session1')
    corMatrix=corrcoef(clustMeanTransp1);
elseif strcmp(session, 'session2')
    corMatrix=corrcoef(clustMeanTransp2);
else
    corMatrix=corClusters;
end

[Y,eigvals] = cmdscale(1-corMatrix);
D=squareform(1-corMatrix);

% the scree plot of eigvalue as a function of the number of eigvalue to
% help decide how many dimenssions to use
[eigvals eigvals./max(abs(eigvals))]
figure(1)
plot(1:length(eigvals),eigvals,'bo-');
axis([1,length(eigvals),min(eigvals),max(eigvals)*1.1]);
xlabel('Eigenvalue number');
ylabel('Eigenvalue');
saveas(figure(1),[figDir,'eigvalsMultidimScal_',session, '_correl.png'])

% check whether use the first 2 columns of Y is an accurate representation
% of the original distance matrix by looking at the error in the distance
% between the 2-D congiguration and the original distancce
maxrelerr = max(abs(D - pdist(Y(:,1:2)))) / max(D)

if strcmp(session,'session1')
    labels={'1','2','3','4','5'};
elseif strcmp(session, 'session2')
    labels={'1','2','3','4','5','6'};
else
    labels={'\leftarrows1c1','\leftarrows1c2','\leftarrows1c3','\leftarrows1c4',...
    '\leftarrows1c5','\leftarrows2c1','\leftarrows2c2','\leftarrows2c3',...
    '\leftarrows2c4','\leftarrows2c5','\leftarrows2c6'};
end

% plot 2D
figure(2)
plot(Y(1:5,1), Y(1:5,2), 'bo', 'MarkerSize', 8, 'MarkerEdgeColor','k',...
    'MarkerFaceColor','r');
hold on
plot(Y(6:end,1), Y(6:end,2), 'bs', 'MarkerSize', 8, 'MarkerEdgeColor','k',...
    'MarkerFaceColor','b');
axis(max(max(abs(Y))) * [-1.1,1.1,-1.1,1.1]); axis('square');
text(Y(:,1),Y(:,2),labels,'HorizontalAlignment','left','FontSize',10);

% add the two grey line at x=0 and y=0
if feature('HGUsingMATLABClasses')
    hx = specgraphhelper('createConstantLineUsingMATLABClasses',...
        'LineStyle','-','Color',[.7 .7 .7],'Parent',gca);
    hx.Value = 0;
else
    hx = graph2d.constantline(0,'LineStyle','-','Color',[.7 .7 .7]);
end
changedependvar(hx,'x');
if feature('HGUsingMATLABClasses')
    hy = specgraphhelper('createConstantLineUsingMATLABClasses',...
        'LineStyle','-','Color',[.7 .7 .7],'Parent',gca);
    hy.Value = 0;
else
    hy = graph2d.constantline(0,'LineStyle','-','Color',[.7 .7 .7]);
end
changedependvar(hy,'y');

saveas(figure(2),[figDir,'Distance_2D_',session, '_correl.png'])

% % plot 3D
% 
% figure(3)
% plot3(Y(:,1), Y(:,2), Y(:,3),'bo', 'MarkerSize', 8, 'MarkerEdgeColor','k',...
%     'MarkerFaceColor','g');
% box on
% view(35, 30);
% %set(gca, 'XGrid','on')
% axis(max(max(abs(Y))) * [-1.1,1.1,-1.1,1.1,-1.1,1.1]); axis('square');
% text(Y(:,1),Y(:,2),Y(:,3),labels,'HorizontalAlignment','left');
% xlabel('x axis','Rotation', -5, 'FontSize',15);
% ylabel('y axis','Rotation',35, 'FontSize',15);
% zlabel('z axis','FontSize',15);
% saveas(figure(3),[figDir,'Distance_3D_',session, '_correl.png'])











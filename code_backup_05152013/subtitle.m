function ht = subtitle(kn,text)
% this fuction add a title at the center of figure with multiple subplots
% SUBTITLE ht = subtitle(kn,text)
% Input:
%     kn    Number of subplot columns
%     text  Title of the graph
% Output:
%     ht   Handle of this title
% Note:
% Vertical colorbar should be included in kn
%
% Example:
%   for kk = 1:6
%       subplot(2,3,kk);
%       plot(magic(3));
%   end
%   ht = subtitle(3,'title in the middle top')
% 
% Last revised 2011-04-15

h1 = get(gcf,'children');
axis1 = get(h1(end),'Position');
axis2 = get(h1(end-kn+1),'Position');

axest = [axis1(1),axis1(2)+axis1(4),1-axis1(1)-(1-axis2(1)-axis2(3)),0.01];
ht = axes('Position',axest);
axis(ht,'off')
title(ht,text)



end


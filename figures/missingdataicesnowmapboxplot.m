cc = load('../langenvironmentdata/idsplusclimate'); 

load('../mixedeffectsanalyses/ridsplusdata'); 

for cci = 1:length(rlabels)
  rli = find(ismember(rlabels, cc.gnames{cci}))  ;
  rlats(rli) = cc.lats(cci);
  rlongs(rli) = cc.longs(cci);
end

% include languages with 1000 or more out of 1310 concepts (roughly top 2
% thirds)

s = sum(rlangmat,2);
inclind = find(s>=1000);
rclimdata = rclimdata(inclind,:);
rclimdataind = rclimdataind(inclind);
reditd = reditd(inclind,:);
rfamcodes = rfamcodes(inclind);
rlabels = rlabels(inclind);
rlangmat = rlangmat(inclind,:);
rorigclimdata = rorigclimdata(inclind,:);
rlats = rlats(inclind);
rlongs = rlongs(inclind);

thisfeats = [15043];
thisdims = [6];


bgcolor = [0.5 0.5 0.5];
backv = [-180, 180, -90, 90];

figure(1)

S = shaperead('ne_110m_land.shp')

titles = {'forms for ice and/or snow absent', 'forms for ice and snow present'};

for ii = 1:length(thisfeats)
  f = thisfeats(ii);
  clf;
  %subplot('position', [0.5, 0.5, 0.2, 0.2]);
  subplot('position', [0.5, 0.5, 0.15, 0.1]);
  indicators = reditd(:, f);
  % begin hack
  oi = indicators;
  indicators = 0*indicators;
  indicators(isnan(oi))= 1;
  % end tmp hack
  mind = thisdims(ii);
  climdata = rorigclimdata(:,mind)/10;
  printind = find(~isnan(indicators));
  boxplot(climdata(printind), indicators(printind), 'orientation', 'horizontal', 'colors', 'k', 'symbol', 'ko', 'outliersize', 2)
  %scatter(climdata(printind), indicators(printind)+0.00*rand(size(printind)), 4, 'k');
  v = axis; v(1) = -15; v(2) = 30; v(3) = 0.5; v(4) = 2.5; axis(v);
  set(gca, 'ytick', [1,2], 'yticklabel', {'', ''});
  text(-17*[1, 1], [1,2],  {'both present', 'one or both absent'}, 'horizontalalign', 'right'); 
  text(7.5, -0.5, ['mean temperature (', sprintf('%sC)', char(176)), ], 'horizontalalign', 'center'); 
  set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
  box off
  print(1, '-depsc', 'colexboxplot_missingforms')
  clf
  
  subplot(3,3,1)
  thislangind = find(indicators==1);
  rectangle('position', [backv(1)-0.5, backv(3)-0.5, backv(2) - backv(1)+1, backv(4)-backv(3)+1], 'facecolor', bgcolor, 'edgecolor', bgcolor); 
  hold on
  mapshow(S, 'facecolor', 'black'); 
  
  axis equal;
  axis(backv) 
  colormap gray;
  plotlats = rlats(thislangind); 
  plotlongs = rlongs(thislangind); 
  plotlongs(plotlongs>180) = -360 + plotlongs(plotlongs>180);
  hold on
  scatter(plotlongs, plotlats, 2, 'o', 'filled', 'markerfacecolor', 0.999*[1 1 1], 'markeredgecolor', 0.999*[1 1 1]);
  
  axis off;
  title(titles{ii});
  disp(length(thislangind))
  v = axis; v(3) = -62; axis(v);
  
  print(1, '-depsc',  'colexmap1_missingforms')
  clf
  
  subplot(3,3,1)
  thislangind = find(indicators==0);
  
  rectangle('position', [backv(1)-0.5, backv(3)-0.5, backv(2) - backv(1)+1, backv(4)-backv(3)+1], 'facecolor', bgcolor, 'edgecolor', bgcolor); 
  hold on
  
  mapshow(S, 'facecolor', 'black'); 
  
  colormap gray;
  plotlats = rlats(thislangind); 
  plotlongs = rlongs(thislangind); 
  plotlongs(plotlongs>180) = -360 + plotlongs(plotlongs>180);
  hold on
  scatter(plotlongs, plotlats, 2, 'o', 'filled', 'markerfacecolor', 0.999*[1 1 1], 'markeredgecolor', 0.999*[1 1 1]);
  axis equal;
  axis(backv)
  axis off;
  colormap gray;
  title(titles{ii+1});
  v = axis; v(3) = -62; axis(v);
  print(1, '-depsc',  'colexmap2_missingforms')
end




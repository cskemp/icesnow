climdatapath = {'../langenvironmentdata/idsplusclimate', '../langenvironmentdata/dictisclimate'};

rdata = {'../mixedeffectsanalyses/ridsplusdata', '../mixedeffectsanalyses/rdictisdata'}; 

prefixes = {'idsplus', 'dict'};

% indices of ice/snow in colexification file
allthisfeats = {15043, 1};

% index of mean temperature
thisdims = [6];

titles = {'same term for ice, snow', 'different terms for ice, snow', 'XXX'};
bgcolor = [0.5 0.5 0.5];
backv = [-180, 180, -90, 90];

% read map data
S = shaperead('ne_110m_land.shp')

for di = 1:length(climdatapath)
  cc = load(climdatapath{di});
  load(rdata{di});

  for cci = 1:length(rlabels)
    rli = find(ismember(rlabels, cc.gnames{cci}))  ;
    rlats(rli) = cc.lats(cci);
    rlongs(rli) = cc.longs(cci);
  end
  
  % index of ice/snow in reditd
  thisfeats = allthisfeats{di};
  prefix = prefixes{di};
  
  figure(1)
    
  for ii = 1:length(thisfeats)
    f = thisfeats(ii);
    clf;
    subplot('position', [0.5, 0.5, 0.15, 0.1]);
    indicators = reditd(:, f);
    mind = thisdims(ii);
    climdata = rorigclimdata(:,mind)/10;
    printind = find(~isnan(indicators));
    boxplot(climdata(printind), indicators(printind), 'orientation', 'horizontal', 'colors', 'k', 'symbol', 'ko', 'outliersize', 2)
    v = axis; v(1) = -15; v(2) = 30; v(3) = 0.5; v(4) = 2.5; axis(v);
    set(gca, 'ytick', [1,2], 'yticklabel', {'', ''});
    text(-17*[1, 1], [1,2],  {'different terms', 'same term'}, 'horizontalalign', 'right'); 
    text(7.5, -0.5, ['mean temperature (', sprintf('%sC)', char(176)), ], 'horizontalalign', 'center'); 
    set(findobj(gcf,'LineStyle','--'),'LineStyle','-')
    box off
    print(1, '-depsc', [prefix, 'colexboxplot'])
    clf
  
    subplot(3,3,1)
    thislangind = find(reditd(:, f)==1);
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
    
    print(1, '-depsc', [prefix, 'colexmap1'])
    clf
  
    subplot(3,3,1)
    thislangind = find(reditd(:, f)==0);
  
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
    print(1, '-depsc', [prefix, 'colexmap2'])
  end
end
  




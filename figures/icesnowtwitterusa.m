
clear all

darkgray = 0.5*ones(1,3);
lightgray = 0.7*ones(1,3);

% index of mean monthly temperature
climind = 6;
twclim = load('../langenvironmentdata/twitterclimateusa'); 

[rcodes c1 c2 c3 c4]= textread('../freqdata/allcountsusageoonly.txt','%d %d %d %d %u', 'delimiter', ' ');

[s,sind] = sort(rcodes);
rcodes = rcodes(sind); c1 = c1(sind); c2 = c2(sind); c3 = c3(sind); c4 = c4(sind);

rprop = log((c1 + c2)./c3);
for i = 1:length(c1)
rraw{i} = sprintf('%d/%d', c1(i)+c2(i), c3(i));
end

tempvar = twclim.climdata(:, climind)/10;

labels = twclim.graphname;

clf;
subplot('position', [0.5, 0.5, 0.2, 0.3]);
subplot('position', [0.5, 0.5, 0.25, 0.375]);


tadj(1,:) = [-7.4, 0.005]; % NY
tadj(2,:) = [-0.2, 0.005]; % Los Angeles
tadj(3,:) = [-4, 0.06]; % Chicago
tadj(4,:) = [-0.2, -0.005]; % Miami
tadj(5,:) = [4, -0.010]; % Philadelphia
tadj(5,:) = [-0.5, -0.012]; % Philadelphia
tadj(6,:) = [-0.5, -0.02]; % Dallas
tadj(7,:) = [-0.5, -0.02]; % Houston
tadj(8,:) = [-0.6, 0.025]; % Washington
tadj(9,:) = [-5.7, 0.02]; % Atlanta
tadj(10,:) = [-0.2, 0]; % Boston
tadj(11,:) = [-5.6, 0.00]; % Detroit
tadj(12,:) = [-0.3, 0.0]; % Phoenix
tadj(13,:) = [-0.2, 0.0]; % San Frncisco
tadj(14,:) = [-0.2, 0.0]; % Seattle
tadj(15,:) = [-7.8, 0.025]; % San Diego
tadj(15,:) = [-7.9, 0.005]; % San Diego
tadj(16,:) = [-0.2, 0.01]; % Minneapolis
tadj(17,:) = [-0.5, 0.00]; % Tampa
tadj(18,:) = [-0.2, 0.00]; % Denver
tadj(19,:) = [-7.8, -0.07]; % Baltimore
tadj(19,:) = [-1, -0.08]; % Baltimore
tadj(20,:) = [-1.7, 0.07]; % St Louis
tadj(21,:) = [-7.2,0]; % Riverside
tadj(22,:) = [-8.1, 0]; % Las Vegas
tadj(23,:) = [-6, -0.035]; % Portland
tadj(24,:) = [-6.3, 0.045]; % Cleveland
tadj(25,:) = [-9, 0]; % San Antonio

% b/c changed axes
tadj(:,1) = 1.05*tadj(:,1);
hold on

text(tempvar+.9+tadj(:,1), rprop+tadj(:,2), labels, 'fontsize', 8, 'color', darkgray);

line([tempvar(3), tempvar(3)], [rprop(3), rprop(3)+0.03], 'color',lightgray);

line([tempvar(20)+0.01, tempvar(20)+0.01], [rprop(20), rprop(20) + 0.035], 'color',lightgray );

line([tempvar(19)+0.01, tempvar(19)+0.01], [rprop(19), rprop(19) - 0.04], 'color', lightgray );

scatter(tempvar, rprop, 'k.');

sum(isinf(rprop))
incl = ~isinf(rprop);
[cc p] =corrcoef(rprop(incl), tempvar(incl));

%title(sprintf('r = %.2f', cc(1,2)));
xlabel(['mean temperature (', sprintf('%sC)', char(176)), ]);
ylabel('    ln probability of mention of ice or snow');

v = axis; v(1) = 3; v(3) = -8.7; v(4) = -7.5;
axis(v);
set(gca, 'ytick', [-8.5, -8, -7.5]);

print(1, '-depsc', 'icesnowtwitterscatterusa');

[s,sind] = sort(rprop, 'descend');
for i = 1:length(sind)
  disp(sprintf('%5.2f, %5.2f, %s', rprop(sind(i)), tempvar(sind(i)), labels{sind(i)}));
end


maxsize = 20;

tempsizes = -tempvar;
tempsizes = ((tempsizes- min(tempsizes))/(max(tempsizes) - min(tempsizes)));

sizes = tempsizes*(maxsize-1) + 5; 
sizes = 6*ones(size(tempsizes));


S = shaperead('ne_50m_admin_0_countries.shp');
S = shaperead('ne_50m_admin_1_states_provinces_shp.shp');

clf
subplot('position', [0.1, 0.1, 0.8, 0.31])

thislangind = 1:25;

bgcolor = [0.5 0.5 0.5];
backv = [-128, -65, 22, 50]

rectangle('position', [backv(1)-0.5, backv(3)-0.5, backv(2) - backv(1)+1, backv(4)-backv(3)+1], 'facecolor', bgcolor, 'edgecolor', bgcolor); 
hold on
% drop Hawaaii
for i = setdiff(51:100, 61)
  t = mapshow(S(i), 'facecolor', 'black', 'edgecolor', 0.15*ones(1,3), 'linewidth', 0.5);
end

axis equal;

axis(backv) 
colormap gray;
plotlats = twclim.lats(thislangind); 
plotlongs = twclim.longs(thislangind)-360;

hold on
% 0.999 trick because otherwise markers don't get printed
scatter(plotlongs, plotlats, sizes, 'o', 'filled', 'markerfacecolor', 0.999*[1 1 1], 'markeredgecolor', 0.999*[1 1 1]);

axis off;
disp(thislangind)

print(1, '-depsc', 'icesnowtwittermapusa');

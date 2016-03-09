clear all
% use only languages that pass back-translation test?
cleanflag = 1;

darkgray = 0.5*ones(1,3);
lightgray = 0.7*ones(1,3);

% index of mean monthly temperature
climind = 6;
twclim = load('../langenvironmentdata/twitterclimate'); 

allshort = textread('../freqdata/allcodes.txt','%s', 'delimiter', ' ');
alllong =  textread('../freqdata/longnames.txt','%s', 'delimiter', ' ');

[rcodes c1 c2 c3 c4]= textread('../freqdata/allcounts.txt','%s %d %d %d %u', 'delimiter', ' ');
% because first number in c3 is large -- overflow issue 
disp('handcode first value')
c3(1) =  7630001193;
rprop = log((c1 + c2)./c3);
for i = 1:length(c1)
rraw{i} = sprintf('%d/%d', c1(i)+c2(i), c3(i));
end

if cleanflag
cleancodes = textread('../freqdata/cleancodes.txt', '%s', 'delimiter', '');
else

hidecodes = textread('../freqdata/cleancodes.txt', '%s', 'delimiter', '');
cleancodes = textread('../freqdata/allcodeswithspaces.txt', '%s', 'delimiter', '');
end

[c ia ib] = intersect(rcodes, twclim.codes2); 

rcodes = rcodes(ia); rprop = rprop(ia); rraw = rraw(ia)
tempvar = twclim.climdata(ib, climind)/10;

[cc ia ib] = intersect(rcodes, cleancodes);
rcodes = rcodes(ia); rprop = rprop(ia), tempvar = tempvar(ia); 
rraw = rraw(ia);

[jj ia ib] = intersect(allshort, rcodes);
longcodes = alllong(ia);

labels = strcat(rcodes, {' '},  rraw')
labels = rcodes;

clf;
subplot('position', [0.5, 0.5, 0.2, 0.3]);
subplot('position', [0.5, 0.5, 0.25, 0.375]);
hold on
tadj = zeros(length(longcodes), 2);
tadj(1,:) = [-1.6, -0.9]; % afrikaans
tadj(2,:) = [-0.2, 0.0]; % catalan
tadj(3,:) = [-3.9, -0.3]; % greek
tadj(4,:) = [-4.5, -0.3]; % estonian
tadj(5,:) = [-1.9, -0.4]; % basque
tadj(6,:) = [-2, 0.4]; % finnish
tadj(7,:) = [-0.1, 0.0]; % galician
tadj(8,:) = [0, 0.0]; % hebrew
tadj(9,:) = [0, 0.0]; % hungarian
tadj(10,:) = [-0.1, -0.1]; % javanese
tadj(11,:) = [0, 0.3]; % malay
tadj(13,:) = [0, 0.1]; % norwegian
tadj(14,:) = [-0.3, 0.2]; % polish
tadj(15,:) = [2.1, -0.55]; % portugese
tadj(18,:) = [0, -0.1]; % urdu

if ~cleanflag
  [j1 j2 j3] = intersect(rcodes, hidecodes);
  tadjnew = 0*tadj;
  tadjnew(j2,:) = tadj(1:18,:);
  tadj = tadjnew;
  tadj(2,:) = [-10, -0.9]; % arabid
  tadj(4,:) = [0, 0.0]; % danish
  tadj(6,:) = [-5.5, -0.2]; % greek
  tadj(9,:) = [-15.5, 0.0]; % estonian
  tadj(10,:) = [-13.5, -0.1]; % basque
  tadj(12,:) = [-13, 0]; % finnish
  tadj(17,:) = [0, -0.1]; % indonesian
  tadj(19,:) = [0, -0.2]; % javanese
  tadj(20,:) = [-12.6, 0.15]; % korean
  tadj(25,:) = [-18.5, 0]; % norwegian
  tadj(26,:) = [-7, 0.3]; % polish
  tadj(28,:) = [-18, 0]; % romanian
  tadj(29,:) = [-14, 0]; % russian
  tadj(30,:) = [-15, 0]; % swedish
  tadj(34,:) = [-0.3, 0.2]; % vietnamese

  if 1
  origlong = longcodes;
  %longcodes{2} = ''; %arabic
  %longcodes{3} = ''; %catalan
  longcodes{5} = ''; %german
  longcodes{8} = ''; %spanish
  longcodes{11} = ''; %farsi
  %longcodes{13} = ''; %french
  longcodes{16} = ''; %hungarian
  longcodes{18} = ''; %italian
  %longcodes{20} = ''; %korean
  longcodes{21} = ''; %latvian
  longcodes{24} = ''; %dutch
  %longcodes{26} = ''; %polish
  longcodes{32} = ''; %turkish
  end

  misslabelind = find(ismember(longcodes, ''));
  for mlii = 1:length(misslabelind)
    mli = misslabelind(mlii);
    disp(sprintf('%10s %.1f %.1f', origlong{mli}, tempvar(mli), rprop(mli)));
  end

end

text(tempvar+.9+tadj(:,1), rprop+tadj(:,2), longcodes, 'fontsize', 8, 'color', darkgray);
if cleanflag
line([tempvar(15)-0.0, tempvar(15) + 2.7], [rprop(15), rprop(15) - 0.4], 'color',lightgray );
else
line([tempvar(27)+0.4, tempvar(27) + 2.7], [rprop(27), rprop(27) - 0.4], 'color', lightgray );
line([tempvar(2)+0.0, tempvar(2) + 0], [rprop(2), rprop(2) - 0.7], 'color', lightgray );

end

line([tempvar(1)+0.0, tempvar(1) + 0.0], [rprop(1), rprop(1) - 0.7], 'color',0.7*ones(1,3) );

scatter(tempvar, rprop, 'k.');

sum(isinf(rprop))
incl = ~isinf(rprop);
[cc p] =corrcoef(rprop(incl), tempvar(incl));

if cleanflag
axis([0,30,-16,-7]);
else
axis([-5,30,-16,-7]);
end
set(gca, 'ytick', [-15, -10]);
xlabel(['mean temperature (', sprintf('%sC)', char(176)), ]);
ylabel('    ln probability of mention of ice or snow');


if cleanflag
print(1, '-depsc', 'icesnowtwitterscatter');
else
print(1, '-depsc', 'icesnowtwitterscatteralllangs');
end


maxsize = 13;

tempsizes = -tempvar;
tempsizes = ((tempsizes- min(tempsizes))/(max(tempsizes) - min(tempsizes)));

sizes = tempsizes*(maxsize-1) + 5; 
sizes = 6*ones(size(tempsizes));

clf
subplot('position', [0.1, 0.1, 0.64, 0.29])

[c ia ib] = intersect(twclim.codes2, labels); 
thislangind = ia;

bgcolor = [0.5 0.5 0.5];
backv = [-180, 180, -90, 90];

S = shaperead('ne_110m_land.shp')

rectangle('position', [backv(1)-0.5, backv(3)-0.5, backv(2) - backv(1)+1, backv(4)-backv(3)+1], 'facecolor', bgcolor, 'edgecolor', bgcolor); 
hold on
mapshow(S, 'facecolor', 'black'); 

axis equal;
axis(backv) 
colormap gray;
plotlats = twclim.lats(thislangind); 
plotlongs = twclim.longs(thislangind);
plotlongs(plotlongs>180) = -360 + plotlongs(plotlongs>180);

hold on
% 0.999 trick because otherwise markers don't get printed
scatter(plotlongs, plotlats, sizes, 'o', 'filled', 'markerfacecolor', 0.999*[1 1 1], 'markeredgecolor', 0.999*[1 1 1]);

axis off;
disp(thislangind)

v = axis; v(3) = -62; axis(v);
if cleanflag
print(1, '-depsc', 'icesnowtwittermap');
else
print(1, '-depsc', 'icesnowtwittermapalllangs');
end


idsplusfile = '../colexificationdata/idspluscolex.mat';
load(idsplusfile)
acodes = load('latlong.mat');

[c ia ib] = intersect(isocodes, acodes.isocodes); 
icodes = acodes.isocodes(ib);
gnames= acodes.iglottocodes(ib);
lats= acodes.ilats(ib); longs = acodes.ilongs(ib);

load('../environmentdata/climatedata');

negind = find(longs<0);
longs(negind) = 360 + longs(negind);

[climdataind, ocdist] = extractclimind(alldata, lats, longs, latclimate, longclimate);

[climdata, vname, oceanmap] = gatherclimdata(climdataind, alldata, climrels, climvars, ocdist);

% the code above chooses the first glottocode in latlong.mat corresponding
% to each isocode. For 'nep' it chooses 'nepa1252', which is superseded
% and not in the glottolog tree we subsequently use. So replace this with 'east1436'

nepind = find(strcmp('nep', icodes));
if ~isempty(nepind)
  gnames{nepind} = 'east1436';
end

save('idsplusclimate', 'climdataind', 'ocdist', 'climdata', 'vname', 'oceanmap', 'gnames', 'lats', 'longs', 'icodes');

map = double(oceanmap);
for i = 1:length(climdataind)
  spotind = addspot(map, climdataind(i));
  map(spotind) = 5;
end
imagesc(map)
axis equal; axis tight;

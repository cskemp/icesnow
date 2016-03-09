
infiles = {'../colexificationdata/dictiscolex'};

outfiles = {'dictisclimate'};

load(infiles{1});
acodes = load('latlong.mat');

[c ia ib] = intersect(glottocodes, acodes.iglottocodes); 
icodes = acodes.isocodes(ib);
gnames= acodes.iglottocodes(ib);
lats= acodes.ilats(ib); longs = acodes.ilongs(ib);

load('../environmentdata/climatedata');

negind = find(longs<0);
longs(negind) = 360 + longs(negind);

[climdataind, ocdist] = extractclimind(alldata, lats, longs, latclimate, longclimate);

[climdata, vname, oceanmap] = gatherclimdata(climdataind, alldata, climrels, climvars, ocdist);


save(outfiles{1}, 'climdataind', 'ocdist', 'climdata', 'vname', 'oceanmap', 'gnames', 'lats', 'longs', 'icodes');

map = double(oceanmap);
for i = 1:length(climdataind)
  spotind = addspot(map, climdataind(i));
  map(spotind) = 5;
end
imagesc(map)
axis equal; axis tight;

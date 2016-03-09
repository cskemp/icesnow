load('../langenvironmentdata/shortlatlong.mat');

lats = shortlat;
longs = shortlong;

load('../environmentdata/climatedata');

negind = find(longs<0);
longs(negind) = 360 + longs(negind);

[climdataind, ocdist] = extractclimind(alldata, lats, longs, latclimate, longclimate);

[climdata, vname, oceanmap] = gatherclimdata(climdataind, alldata, climrels, climvars, ocdist);

save('twitterclimateusa', 'climdataind', 'ocdist', 'climdata', 'vname', 'oceanmap', 'lats', 'longs', 'graphname');

map = double(oceanmap);
for i = 1:length(climdataind)
  spotind = addspot(map, climdataind(i));
  map(spotind) = 5;
end
imagesc(map)
axis equal; axis tight;

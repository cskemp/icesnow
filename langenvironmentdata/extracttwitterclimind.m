langfile= '../freqdata/icesnowforms.txt';
[codes2 langcodes jk2 jk3]= textread(langfile,'%s%s%s%s', 'delimiter', ',');

acodes = load('latlong.mat');

[c ia ib] = intersect(langcodes, acodes.iglottocodes); 
icodes = acodes.isocodes(ib);
gnames= acodes.iglottocodes(ib);
lats= acodes.ilats(ib); longs = acodes.ilongs(ib);
codes2 = codes2(ia);

load('../environmentdata/climatedata');

negind = find(longs<0);
longs(negind) = 360 + longs(negind);

[climdataind, ocdist] = extractclimind(alldata, lats, longs, latclimate, longclimate);

[climdata, vname, oceanmap] = gatherclimdata(climdataind, alldata, climrels, climvars, ocdist);

save('twitterclimate', 'climdataind', 'ocdist', 'climdata', 'vname', 'oceanmap', 'gnames', 'lats', 'longs', 'icodes', 'codes2');

map = double(oceanmap);
for i = 1:length(climdataind)
  spotind = addspot(map, climdataind(i));
  map(spotind) = 5;
end
imagesc(map)
axis equal; axis tight;

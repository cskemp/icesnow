ufile = 'urbanareas2010.txt';

[geoid name utype pop hu aland awater alandsqm awatersqm lat long]= textread(ufile, '%s%s%c%d%d%d%d%f%f%f%f','delimiter', '\t');

% drop "Urbanized Area"
for i = 1:length(name)
  n = name{i};
  n = n(1:end-15);
  name{i} = n;
end

[s,sind] = sort(pop, 'descend');

inclind = setdiff(1:26, 21); % drop San Juan

shortname = name(sind(inclind));
shortlat = lat(sind(inclind));
shortlong = long(sind(inclind));
shortpop = pop(sind(inclind));


outfile = 'shortlatlong.txt';

for i = 1:length(shortname)
  n = shortname{i};
  firstind = find(n==',' | n == '-',1);
  shortn = n(1:firstind-1);
  graphname{i} = shortn;
end

save('shortlatlong', 'shortname', 'shortlat', 'shortlong', 'graphname');
fp = fopen(outfile, 'w');
for i = 1:length(shortlat)
  fprintf(fp, '%.6f %.6f\n', shortlat(i), shortlong(i));
end
fclose(fp);









function [idsclimdata, vname, oceanmap] = gatherclimdata(climdataind, alldata, climrels, climvars, ocdist)

nlang = length(climdataind);

nvar = size(alldata,3);
idsclimdata = zeros(nlang, nvar, 3);

for i = 1:nlang
  thisind = climdataind(i);
  for j = 1:nvar
    for k = 1:3
      ad = alldata(:,:,j,k);
      if isnan(thisind)
        idsclimdata(i,j,k) = nan;
      else
        idsclimdata(i,j,k) = ad(thisind);
      end
    end
  end
end

idsclimdata = reshape(idsclimdata, nlang, nvar*3);

vind = 1;
for k = 1:3
  for j = 1:nvar
    vname{vind} = [climrels{k}, ' ', climvars{j}];
    vind = vind + 1;
  end
end

ad1 = alldata(:,:,1,1);
oceanmap = isnan(ad1);
idsclimdata = [idsclimdata, ocdist'];
vname{31} = 'dist from coast';


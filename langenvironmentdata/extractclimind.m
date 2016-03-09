function [climdataind, ocdist] = extractclimind(alldata, lats, longs, latclimate, longclimate)

ad1 = alldata(:,:,1,1);
ocean = isnan(ad1);

[longgrid latgrid] = meshgrid(1:size(ocean,2), 1:size(ocean,1));

for i = 1:length(lats)
  if ~isnan(lats(i));
    if longs(i) < 0
      longs(i) = 360 + longs(i);
    end
    dists = (lats(i) - latclimate).^2 + (longs(i) - longclimate).^2;
    [ms,minds] = sort(dists(:));
    ocsort = ocean(minds);
    % closest point for which we have data
    ii = find(ocsort==0, 1); 
    climdataind(i) = minds(ii);
    if ii ~= 1
      disp(sprintf('language %d moved to closest point on land', i));
    end
    [x,y] = ind2sub(size(ocean), climdataind(i));

    ocdists = sqrt((longgrid - y).^2 + (1*(latgrid - x)).^2);
    ocdist(i) = min(ocdists(ocean==1));
    if ii ~= 1
      ocdist(i) = 0;
    end
   else
    climdataind(i) = nan;
    ocdist(i) = nan;
  end
end




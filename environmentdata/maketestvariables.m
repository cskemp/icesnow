fnames = { 'ccld6190.mat', 'cdtr6190.mat', 'cpre6190.mat', 'crad6190.mat', 'ctmn6190.mat', 'ctmp6190.mat', 'ctmx6190.mat', 'cvap6190.mat', 'cwet6190.mat', 'cwnd6190.mat'};

for i = 1:length(fnames)
  load(fnames{i});
  alldata(:,:,i,1) = mean(data,3);
  alldata(:,:,i,2) = max(data,[],3);
  alldata(:,:,i,3) = min(data,[],3);
end

climvars= { 'cloud', 'diurnal range', 'precipitation', 'radiation', 'min temperature', 'mean temperature', 'maximum temperature', 'vapour pressure', 'wet days',  'wind speed'}; 

climrels= {'mean', 'max', 'min'};

xs = [xmin:grdsz:xmax];
ys = fliplr([ymin:grdsz:ymax]);

[longclimate, latclimate] = meshgrid(xs, ys);

save('climatedata', 'longclimate', 'latclimate', 'alldata', 'climvars', 'climrels');


fnames = { 'ccld6190.dat', 'cdtr6190.dat', 'cpre6190.dat', 'crad6190.dat', 'ctmn6190.dat', 'ctmp6190.dat', 'ctmx6190.dat', 'cvap6190.dat', 'cwet6190.dat', 'cwnd6190.dat'};

for i = 1:length(fnames)
  fname = fnames{i};
  disp(fname);
  fid = fopen(fname, 'r');
  
  lh = fgetl(fid);
  lh = fgetl(fid);
  [grdsz xmin ymin xmax ymax ncols nrows nmonths]= strread(lh, '%f%f%f%f%f%d%d%d');
  
  fmt = '%5d';
  
  D = textscan(fid, fmt, 'delimiter', '\n');
  
  data  = reshape(D{1}, ncols, nrows,nmonths);
  data = double(data);
  data(data==-9999)  = nan;
  data = permute(data, [2,1,3]);
  
  for i = 1:12
    subplot(3,4,i)
    imagesc(data(:,:,i));
    axis equal; axis tight;
  end
  
  save(fname(1:end-4), 'data', 'grdsz', 'xmin', 'ymin', 'xmax', 'ymax')
end






















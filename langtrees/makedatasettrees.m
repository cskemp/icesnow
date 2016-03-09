fulltreefile = 'tree-glottolog-newick.txt';

enfiles = {'../langenvironmentdata/idsplusclimate.mat', '../langenvironmentdata/dictisclimate.mat', '../langenvironmentdata/twitterclimate.mat'}; 

outfiles = {'idsplusentree', 'dictistree', 'twittertree'};

for k = 1:3
  load(enfiles{k})
  counts = zeros(1, length(gnames));
  rfamcodes = counts;
  fid = fopen(fulltreefile, 'r');
  tind = 1;
  tline = fgetl(fid);
  while ischar(tline)
    for i = 1:length(gnames)
      rout = regexpi(tline, gnames{i});
      if ~isempty(rout)
        counts(i) = counts(i) + 1;
	rfamcodes(i)  = tind;
      end
    end
    tline = fgetl(fid);
    tind = tind+1;
    disp(tind);
  end

  % each gname was found
  assert(sum(counts==0) == 0);
  % each gname was found only once
  assert(sum(counts>1) == 0);

  rlabels = gnames;
  % rlabels same as gnames: keep both for backwards compatibility

  [c ia ic] = unique(rfamcodes);
  rfamcodes = ic;

  save([outfiles{k}], 'rlabels', 'rfamcodes', 'gnames', 'icodes', 'climdataind', 'climdata', 'vname');
end


